#!/bin/bash

LISPDIR=$HOME/.emacs.d/lisp

if [ -d $LISPDIR ]; then
    echo "'$LISPDIR' exists."
    pushd ./lisp
    for ELFILE in *
    do
	isExist=$HOME/.emacs.d/lisp/$ELFILE
	if [ -f $isExist ]; then
	    continue
	else
	    cp $ELFILE $isExist
	fi
    done
    popd
else
    echo "'$LISPDIR' does not exist."
    mkdir -p ~/.emacs.d/lisp
    pushd ./lisp
    cp * $LISPDIR/
    popd
fi 


if [ -f $HOME/.emacs ]; then
    echo "'.emacs' exists."
    cat ./emacs_config >> $HOME/.emacs
else
    echo "'.emacs' does not exist."
    cp ./emacs_config $HOME/.emacs
    echo "cp .emacs ~/.emacs"
fi

echo -e "To install magit, choose package link in .eamcs file then\n M-x package-refresh-contents RET\n M-x package-install RET magit RET\n"
echo -e "To install meghanada, set melpa then M-x package-refresh-contents RET\n M-x package-install RET meghanada RET\n"
echo -e "installing use-package which is a pakcage manage tool will install packages automatically"
