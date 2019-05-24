#!/bin/bash

PROJ_DIR=/home/gykim/work/lee
SRC_DIR=$PROJ_DIR/

# Directory where the source files are located
# It is possible to select more than one search directory just writing other directories after one space.
SEARCH_DIR="$PROJ_DIR"

# Directory where the resulting files will be located
DEST_DIR=$PROJ_DIR

cd $DEST_DIR
rm -rf cscope.out cscope.files
find $SEARCH_DIR  \( -name '*.c' -o -name '*.h' -o -name '*.cpp' \) -print > cscope.files
cscope -b
