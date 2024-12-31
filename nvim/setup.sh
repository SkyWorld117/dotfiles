#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
CLUSTER=${HOSTNAME%?}

if [ $CLUSTER = "sbrinz" ] || [ $CLUSTER = "piora" ]; then
    echo "Assuming all dependencies are installed"
else
    sudo dnf -y install ninja-build cmake gcc make unzip gettext curl glibc-gconv-extra
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
# fd_tag="$( curl -s https://api.github.com/repos/sharkdp/fd/releases/latest | jq -r ".tag_name" )"
# wget "https://github.com/sharkdp/fd/archive/refs/tags/${fd_tag}.tar.gz"
# tar -xvf ${fd_tag}.tar.gz
# cd fd*

rm -rf ${SCRIPT_DIR}/tmp
