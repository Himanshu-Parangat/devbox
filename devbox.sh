#!/usr/bin/env bash

set -Eeuo pipefail

IFS=$'\n\t'


DRY_RUN=0
WORKSPACE=""
MOUNT_OPTIONS=()
NETWORK_OPTIONS=()
EXTRA_OPTIONS=()

SELF="$(realpath -- "${BASH_SOURCE[0]}")"
SCRIPT_DIR="$(dirname -- "$SELF")"



BIN_DIRECTORY="$HOME/.local/bin"
BIN_NAME="devbox"

IMAGE="devbox"
CONTAINERFILE="$SCRIPT_DIR/Containerfile"


usage() {
  cat <<EOF
Usage: ${0##*/} [options]

Run the "$IMAGE" container with a locked-down, ephemeral environment.

Options:
  -h, --help                   Show this help and exit
  -dr, --dry-run               Print the commands instead of running them
  -mo, --mount SPEC            Mount a host directory (repeatable)
  -w,  --workdir DIR           Directory to start in (resolved on the host with
                               realpath, must exist, e.g. ./config)
  -net, --network NETWORK      Join a Podman network (repeatable)
                               Default: none (no network access)
  --extra ARGS...              Pass all remaining arguments to "podman run"
  -bl, --build                 Build the "$IMAGE" image from $CONTAINERFILE
                               and exit
  --install                    Symlink this script to $BIN_DIRECTORY/$BIN_NAME
  --uninstall                  Remove that symlink

Mount SPEC formats:
  host                         Mounted at the same path, default mode
  host:mode                    Mounted at the same path, given mode
  host:target                  Mounted at an absolute path inside the container
  host:target:mode             Full form

  host     Resolved with realpath; must exist (relative paths are fine)
  target   Absolute path inside the container
  mode     Comma-separated Podman options (e.g. rw, ro,exec, rw,Z)
           Default: ro,nodev,noexec,nosuid
           Note: "host:foo" is read as a mode only if foo is a valid option,
           otherwise it is treated as a target.

Workspace (where the shell starts), first match wins:
  1. -w/--workdir
  2. Target of the first -mo
  3. current working directory: $PWD

  The workspace is created inside the container if missing. Outside a mount
  it lives in the container's temporary layer and is lost on exit (--rm).

Examples:
  ${0##*/} -bl
  ${0##*/} -mo ".:rw"
  ${0##*/} -mo ~/project:/src:rw -mo ~/data:/data -net bridge
  ${0##*/} --dry-run -mo ~/proj:/src:rw
EOF
}

die() {
  echo "Error: $*" >&2
  exit 1
}


run() {
  if ((DRY_RUN)); then
    local -a arguments=("$@")
    local last_entry="${arguments[-1]}"
    unset 'arguments[-1]'
    printf 'Command:\n\n  '
    printf '%q ' "${arguments[@]}"
    printf "'%s'\n\n" "$last_entry"
  else
    "$@"
  fi
}

requirePodman() {
  ((DRY_RUN)) && return 0
  command -v podman >/dev/null 2>&1 || die "podman is not installed or not in PATH"
}

installSelf() {
  run mkdir -p "$BIN_DIRECTORY"
  run chmod +x "$SELF"
  run ln -sfn "$SELF" "$BIN_DIRECTORY/$BIN_NAME"
  echo "Linked $BIN_DIRECTORY/$BIN_NAME -> $SELF"
  case ":$PATH:" in
    *":$BIN_DIRECTORY:"*) ;;
    *) echo "Note: $BIN_DIRECTORY is not in your PATH" >&2 ;;
  esac
}

uninstallSelf() {
  if [[ -L "$BIN_DIRECTORY/$BIN_NAME" ]]; then
    run rm -- "$BIN_DIRECTORY/$BIN_NAME"
    echo "Removed $BIN_DIRECTORY/$BIN_NAME"
  else
    die "$BIN_DIRECTORY/$BIN_NAME is not a symlink created by this script"
  fi
}

buildImage() {
  local containerfile

  requirePodman

  containerfile="$(realpath -e -- "$CONTAINERFILE")" \
    || die "Containerfile not found: $CONTAINERFILE"

  echo "Building $IMAGE from $containerfile"

  run podman build \
    -f "$containerfile" \
    -t "$IMAGE" \
    "$(dirname -- "$containerfile")"
}

prepareVolumeOption() {

  VOLUME_OPTIONS=()

  local opts="ro|rw|z|Z|U|O|dev|nodev|exec|noexec|suid|nosuid|(r?(shared|slave|private))|(r?unbindable)|r?bind|copy|nocopy"
  local mode_regex="^(${opts})(,(${opts}))*\$"

  local default_mode="ro,nodev,noexec,nosuid"

  local entry host target mode
  local -a parts

  for entry in "${MOUNT_OPTIONS[@]+"${MOUNT_OPTIONS[@]}"}"; do
    [[ -n "$entry" ]] || {
      echo "Empty mount specification" >&2
      return 1
    }

    IFS=':' read -r -a parts <<< "$entry"

    host="$(realpath -e "${parts[0]}")" || return 1

    case ${#parts[@]} in
      1)
        target="$host"
        mode="$default_mode"
        ;;
      2)
        if [[ "${parts[1]}" =~ $mode_regex ]]; then
          target="$host"
          mode="${parts[1]}"
        else
          target="${parts[1]}"
          mode="$default_mode"
        fi
        ;;
      3)
        target="${parts[1]}"
        mode="${parts[2]}"
        ;;
      *)
        echo "Invalid volume mount specification: $entry" >&2
        return 1
        ;;
    esac

    if [[ "$target" != /* ]]; then
      echo "Target must be an absolute path: $entry" >&2
      return 1
    fi

    if [[ -z "$WORKSPACE" ]]; then
      WORKSPACE="$target"
    fi

    VOLUME_OPTIONS+=(-v "$host:$target:$mode")

  done

}

runImage() {

  requirePodman

  prepareVolumeOption || exit 1

  local network=()
  local net

  if ((${#NETWORK_OPTIONS[@]} == 0)); then
    network+=(--network=none)
  else
    for net in "${NETWORK_OPTIONS[@]}"; do
      network+=(--network "$net")
    done
  fi

  if [[ -z "$WORKSPACE" ]]; then
    WORKSPACE="$PWD"
  fi

  if [[ -f "$WORKSPACE" ]]; then
    WORKSPACE="$(dirname -- "$WORKSPACE")"
  fi

  cmd='mkdir -p "$WORKSPACE" && cd "$WORKSPACE" && exec bash'

  run podman run --rm -it \
    --cap-drop=ALL \
    --security-opt=no-new-privileges \
    --ipc=private \
    --uts=private \
    "${network[@]}" \
    -v nvim-data:/root/.local/share/nvim \
    -v nvim-state:/root/.local/state/nvim \
    -v nvim-cache:/root/.cache/nvim \
    -v starship-cache:/root/.cache/starship \
    "${VOLUME_OPTIONS[@]+"${VOLUME_OPTIONS[@]}"}" \
    "${EXTRA_OPTIONS[@]+"${EXTRA_OPTIONS[@]}"}" \
    -e WORKSPACE="$WORKSPACE" \
    "$IMAGE" \
    bash -c "$cmd"
}

main() {
  local do_build=0
  local do_install=0
  local do_uninstall=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        usage
        exit 0
        ;;
      -dr|--dry-run)
        DRY_RUN=1
        shift
        ;;
      -bl|--build)
        do_build=1
        shift
        ;;
      --install)
        do_install=1
        shift
        ;;
      --uninstall)
        do_uninstall=1
        shift
        ;;
      -w|--workdir)
        (($# >= 2)) || die "Missing argument for $1"
        WORKSPACE="$(realpath -e -- "$2")" || die "Workdir cannot be resolved: $2"
        shift 2
        ;;
      -mo|--mount)
        (($# >= 2)) || die "Missing argument for $1"
        MOUNT_OPTIONS+=("$2")
        shift 2
        ;;
      -net|--network)
        (($# >= 2)) || die "Missing argument for $1"
        NETWORK_OPTIONS+=("$2")
        shift 2
        ;;
      --extra)
        shift
        (($# >= 1)) || die "--extra requires at least one argument"
        EXTRA_OPTIONS+=("$@")
        break
        ;;
      *)
        echo "Unknown argument: $1" >&2
        usage >&2
        exit 1
        ;;
    esac
  done

  if ((do_build)); then
    buildImage
    exit 0
  fi

  if ((do_install)); then
    installSelf
    exit 0
  fi

  if ((do_uninstall)); then
    uninstallSelf
    exit 0
  fi

  runImage
}

main "$@"

