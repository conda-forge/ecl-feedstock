#!/bin/bash

export CC=$(basename $CC)
export AR=$(basename $AR)
export RANLIB=$(basename $RANLIB)
export CFLAGS="-g $CFLAGS"

if [[ "$target_platform" == osx-* ]]; then
    export CFLAGS="-Wno-unknown-attributes $CFLAGS"
fi

chmod +x configure
./configure \
        --prefix="$PREFIX" \
        --libdir="$PREFIX/lib" \
        --with-gmp-prefix="$PREFIX" \
        --disable-threads \
        --enable-unicode=yes

# Before running make we touch build/TAGS so its building process is never triggered
touch build/TAGS

make
make check
make install

ln -s $PREFIX/lib/ecl-* $PREFIX/lib/ecl
ln -s $PREFIX/include/ecl $PREFIX/lib/ecl/ecl
