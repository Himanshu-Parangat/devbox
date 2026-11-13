# Devbox Development Environment

A throwaway, locked-down Podman container for development. Keep your host clean. All toolchains, editor with ts plugins live inside the container, not on your host machine.


## Why?

- Installing tools directly on the host often leaves stray files that become a mess after a year.
- Package managers like npm have frequent supply-chain attacks. Inside the container, a malicious package has very little to work with: no network by default, no new privileges, no capabilities, and filesystem isolation that resets.

> **Note:** Containers are not a complete security boundary. They add isolation, not guarantees.


## What this includes
- Fully configured Neovim with lazy plugin Manager,options, keymaps, utilities
- LSP for Lua, TypeScript, Astro, Biome, Tailwind CSS, JSON, YAML, Emmet, QML
- A wrapper script (devbox) that automates the long podman run flags


## Requirements

- [Podman](https://podman.io/) (rootless)
- Bash
- A [Nerd Font](https://www.nerdfonts.com) in your terminal


## One-time setup

### 1. Quick start
```bash
git clone https://github.com/Himanshu-Parangat/devbox && cd devbox
./devbox.sh --build      # build the image from ./Containerfile
./devbox.sh --install    # symlink to ~/.local/bin/devbox
```


> **Troubleshooting:** 
> If `devbox` isn't found, add it to your `PATH`:
>
> ```bash
> export PATH="$HOME/.local/bin:$PATH"
> ``` 
>
> If you see
> `Error: short-name "devbox" did not resolve to an alias and no containers-registries.conf(5) was found`,
> the image doesn't exist yet. Run `./devbox.sh --build` first.


### 2. Inside the container

Start a shell with the network enabled (needed for downloads only):

```bash
devbox -net bridge
```
Then run these inside it:

```bash
# Install Neovim plugins
nvim --headless "+Lazy! restore" +qa

# Install LSP servers, formatters, linters
nvim --headless "+MasonToolsInstallSync" +qa
```

Then try
```bash
devbox -mo ".:rw"
```


### Uninstall

```bash
devbox --uninstall                                          # remove the symlink
podman rmi devbox                                           # remove the image
podman volume rm nvim-data nvim-state nvim-cache starship-cache   # remove saved editor data
```



## Usage
```bash
devbox -mo ".:rw"                           # current dir, read-write(mostly used like this).
devbox -mo ~/project:/src:rw                # custom path inside container
devbox -mo ~/project:/src:rw -mo ~/data:/data   # one writable, one read-only
devbox -mo ".:rw" -net bridge               # enable network (e.g. lazy/mason update)
devbox --dry-run -mo ~/proj:/src:rw         # print the podman command only
```


| Option | Description |
|---|---|
| `-mo, --mount SPEC` | Mount a host directory (repeatable) |
| `-w, --workdir DIR` | Starting directory |
| `-net, --network NET` | Join a Podman network (default: none) |
| `-bl, --build` | Build the image |
| `-dr, --dry-run` | Print the command only |
| `--extra ARGS...` | Pass remaining args to `podman run` |
| `--install` / `--uninstall` | Add or remove the `devbox` symlink |
| `-h, --help` | Show help |



### Mount spec

```
host                  same path in container, read-only
host:mode             same path, custom mode (e.g. rw)
host:target           custom path in container
host:target:mode      full form
```

Default mode is `ro,nodev,noexec,nosuid`. Use `rw` to write. Add `exec` only if you must run binaries from that mount.


## How it works

- Your source code stays on the **host** and is tracked with Git.
- The project directory is **bind-mounted** into the container, so you edit files normally.
- Rootless Podman means files created in the container belong to your normal user on the host.
- Editors, language servers, formatters, and debuggers live in this container. Your app's runtime & servers can live in other containers.
- Neovim plugins, Mason packages, caches, and state stay in the container's named volumes.

## Tips

- Mount only what you need; make just the project directory writable.
- Turn the network on only when installing dependencies, then restart without it.
- Never mount `~`, `~/.ssh`, or other credentials, use podman secrets and pass it using `--extra`.

This repository provides one implementation of the container first development idea, You can either use this project as is (I do) or use it as a reference resource for your own implementation.

The core idea is the same:-

```bash
podman run --rm -it \
  --cap-drop=ALL \
  --security-opt=no-new-privileges \
  --network=none \
  -v "$PWD":"$PWD":rw \
  -w "$PWD" \
  Your-Image bash
```

## Related Projects

- Microsoft Dev Box</br>https://learn.microsoft.com/en-us/azure/dev-box/

- JetBrains Dev Containers</br>https://www.jetbrains.com/help/idea/connect-to-devcontainer.html

- NixOS Impermanence (Interesting one)</br>https://wiki.nixos.org/wiki/Impermanence

## License

Licensed under the BSD 3-Clause License. See [LICENSE](./LICENSE).
