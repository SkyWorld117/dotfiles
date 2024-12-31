#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CLUSTER=${HOSTNAME%?}

if [ $CLUSTER = "sbrinz" ] || [ $CLUSTER = "piora" ]; then
    echo "Assuming all dependencies are installed"
else
    sudo dnf -y install ninja-build cmake gcc make unzip gettext curl glibc-gconv-extra lua lua-devel ncurses-devel libevent-devel readline-devel
fi

mkdir -p ${SCRIPT_DIR}/tmp
rm -rf ${SCRIPT_DIR}/tmp/*
cd ${SCRIPT_DIR}/tmp

# Install neovim
nvim_tag="$( curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r ".tag_name" )"
wget "https://github.com/neovim/neovim/archive/refs/tags/${nvim_tag}.tar.gz"
tar -xvf ${nvim_tag}.tar.gz
cd neovim*
make CMAKE_BUILD_TYPE=Release prefix=$HOME/.local
make install CMAKE_INSTALL_PREFIX=$HOME/.local
cd ..

# Install fd
fd_tag="$( curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | jq -r ".tag_name" )"
fd_name="$( curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | jq -r ".name" )"
if [ $(uname -m) = "x86_64" ]; then
    wget "https://github.com/sharkdp/fd/releases/download/${fd_name}/fd-${fd_name}-x86_64-unknown-linux-gnu.tar.gz"
else
    wget "https://github.com/sharkdp/fd/releases/download/${fd_name}/fd-${fd_name}-aarch64-unknown-linux-gnu.tar.gz"
fi
tar -xzf fd-${fd_name}-*.tar.gz
cp fd-${fd_name}-*/fd $HOME/.local/bin

# Install ripgrep
rg_tag="$( curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq -r ".tag_name" )"
rg_name="$( curl -s https://api.github.com/repos/BurntSushi/ripgrep/releases/latest | jq -r ".name" )"
if [ $(uname -m) = "x86_64" ]; then
    wget "https://github.com/BurntSushi/ripgrep/releases/download/${rg_name}/ripgrep-${rg_name}-x86_64-unknown-linux-musl.tar.gz"
else
    wget "https://github.com/BurntSushi/ripgrep/releases/download/${rg_name}/ripgrep-${rg_name}-aarch64-unknown-linux-gnu.tar.gz"
fi
tar -xzf ripgrep-${rg_name}-*.tar.gz
cp ripgrep-${rg_name}-*/rg $HOME/.local/bin

# Install LuaRocks
luarocks_version="$( curl -s https://luarocks.github.io/luarocks/releases/ | grep -oP "luarocks-\K.*?(?=.tar.gz)" | head -n 1 )"
wget "https://luarocks.github.io/luarocks/releases/luarocks-${luarocks_version}.tar.gz"
tar -xzf luarocks-${luarocks_version}.tar.gz
cd luarocks-${luarocks_version}
./configure --prefix=$HOME/.local
make install

# Install tree-sitter
if [ $(uname -m) = "x86_64" ]; then
    wget "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-x64.gz"
else
    wget "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-arm64.gz"
fi
gunzip tree-sitter-linux-*.gz
cp tree-sitter-linux-* $HOME/.local/bin/tree-sitter
chmod +x $HOME/.local/bin/tree-sitter

rm -rf ${SCRIPT_DIR}/tmp
