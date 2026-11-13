FROM archlinux:latest

ARG PACKAGES=" neovim \
bash bash-completion git tree-sitter-cli starship tmux \
lua luarocks gcc nodejs npm \
unzip gzip make wget less \
bat eza tree jq ripgrep fd fastfetch htop"

RUN pacman -Syu --noconfirm --needed $PACKAGES && \
  pacman -Scc --noconfirm

COPY config/bash/.bashrc /root/.bashrc
COPY config/nvim /root/.config/nvim
COPY config/starship/starship.toml /root/.config/starship.toml

CMD ["bash"]
