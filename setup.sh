#!/bin/bash

pushd $HOME/.emacs.d
mkdir 
git clone https://github.com/Fanael/rainbow-delimiters
cd rainbow-delimiters
cp rainbow-delimiters.el $HOME/.emacs.d/
