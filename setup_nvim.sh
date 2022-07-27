#!/bin/bash

# install nvim
cd 
if ! which nvim >&/dev/null ; then
    curl -LsO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage || exit 1
    chmod u+x nvim.appimage || exit 1
    mkdir -p ~/.local/bin 2>/dev/null
    if ! ./nvim.appimage +qa ; then 
        ./nvim.appimage --appimage-extract || exit 1
        ln -s `pwd`/squashfs-root/AppRun ~/.local/bin/nvim || exit 1
        rm ~/nvim.appimage
    else 
        ln -s `pwd`/nvim.appimage ~/.local/bin/nvim || exit 1
    fi
fi

# install vimrc
cd 
git clone "https://github.com/yoavdim/vimrc.git" || exit 2
mkdir -p ~/.vim/after/ftplugin 2>/dev/null
mkdir -p ~/.config/nvim 2>/dev/null
ln -s `pwd`/vimrc/.vimrc ~/.vimrc || exit 3
ln -s `pwd`/vimrc/verilog_systemverilog.vim ~/.vim/after/ftplugin/verilog_systemverilog.vim || exit 3
ln -s `pwd`/vimrc/init.vim ~/.config/nvim/init.vim || exit 3

# PlugInstall plugins
~/.local/bin/nvim +PlugInstall +qa || exit 4

# done
echo "Finished. Dont forget to add to your bashrc: alias vim=nvim"

