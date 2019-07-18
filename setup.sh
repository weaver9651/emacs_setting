#!/bin/bash

lispdir='$HOME/.emacs.d/lisp'

if [ -d $lispdir ]; then
    echo "'$lispdir' exists."
else
    mkdir -p $HOME/.emacs.d/lisp
fi 

pushd ./lisp
cp * $lispdir
popd

if [ -f $HOME/.emacs ]; then
    echo "'.emacs' exists."
    cat ./emacs_config >> $HOME/.emacs
else
    cp ./emacs_config $HOME/.emacs
