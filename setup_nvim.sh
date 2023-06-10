#!/bin/bash

# to control this script export $use_root, $force_new_nvim_install (ignore the distribution version, download from git), $do_nvim_reinstall (remove downloaded version and reinstall)
vimrc_git_name=vimrc
bin_path=~/.local/bin
use_bin=0 # if binary in $path or not

# easy root install (export use_root=1)
if [[ $use_root -ne 0 ]]; then
    bin_path=/usr/bin
fi

# install nvim 
cd 
if [[ -n $force_new_nvim_install ]] || ! which nvim >&/dev/null ; then
    use_bin=1
    if [[ -n $do_nvim_reinstall ]] && [[ -n "$bin_path/nvim.appimage" ]] ; then
        rm -f "$bin_path/nvim.appimage"
        rm -f "$bin_path/nvim"
    fi
    if [[ ! -f "$bin_path/nvim" ]] ; then
        curl -LsO https://github.com/neovim/neovim/releases/download/stable/nvim.appimage || exit 1
        chmod u+x nvim.appimage || exit 1
        mkdir -p "$bin_path" 2>/dev/null
        if ! ./nvim.appimage +qa ; then 
            ./nvim.appimage --appimage-extract || exit 1
            ln -s `pwd`/squashfs-root/AppRun $bin_path/nvim || exit 1
            rm ~/nvim.appimage
        else 
            ln -s `pwd`/nvim.appimage $bin_path/nvim || exit 1
        fi
    fi

    if echo "$PATH" | grep -q "${bin_path}" ; then
        echo "Please add to bashrc: PATH=\"\${PATH}:${bin_path}\""
        echo "Or: alias nvim=\"${bin_path}/nvim\""
    fi
fi

# install vimrc (clone in ~)
cd 
if ! [[ -d ~/$vimrc_git_name ]] ; then
    git clone "https://github.com/yoavdim/vimrc.git" || exit 2
fi # todo: else, pull?

# link the vimrc
mkdir -p ~/.config/nvim 2>/dev/null
if [[ ! -L ~/.vimrc ]] ; then 
    ln -s `pwd`/vimrc/.vimrc ~/.vimrc || exit 3
fi
if [[ ! -L ~/.config/nvim/init.vim ]] ; then 
    ln -s `pwd`/vimrc/init.vim ~/.config/nvim/init.vim || exit 3
fi

# link more rc files
mkdir -p ~/.vim/after 2>/dev/null
for folder in ftplugin plugins ; do
    mkdir -p ~/.vim/after/$folder 2>/dev/null
    cd ~/vimrc/.vim/after/$folder
    for file in * ; do
        if [[ ! -L "~/.vim/after/$folder/$file" ]] ; then
            ln -s `pwd`/$file ~/.vim/after/$folder/$file  # allow to fail if exists
        fi
    done
done
cd

# Install language servers
user_flag=""
if [[ -n "$use_root" ]] ; then
    user_flag='--user'
fi
python3 -m pip install $user_flag pyright 

# PlugInstall plugins
if ! [[ $use_bin -eq 0 ]] ; then 
    $bin_path/nvim +PlugInstall +qa || exit 4
else
    nvim           +PlugInstall +qa || exit 4
fi

# done
echo "Finished. Dont forget to add to your bashrc: alias vim=nvim"

