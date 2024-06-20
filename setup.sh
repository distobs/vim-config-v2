#!/bin/sh

vimdir="$HOME/.vim/"
plugdir="$HOME/.vim/pack/plugins"

mkdir $vimdir

cp vimrc $vimdir

mkdir -p $plugdir ; cd $plugdir ; mkdir 'start' 'opt'

git clone --branch=master --depth=1 https://github.com/morhetz/gruvbox 'start/gruvbox'
git clone --branch=master --depth=1 https://github.com/mattn/emmet-vim 'opt/emmet-vim'
git clone --depth=1 --branch=release https://github.com/neoclide/coc.nvim 'opt/coc.nvim'
