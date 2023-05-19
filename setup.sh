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

echo -e "After package-refresh, Install use-package"
echo -e "Install python3-venv to prevent elpy errors"
