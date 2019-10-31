#!/bin/bash

# avoid absolute-paths in compilers
export CC=$(basename "$CC")

export CFLAGS="-g $CFLAGS"

if [[ "${target_platform}" == osx* ]]; then
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

make -j${CPU_COUNT}
make install
make check

ln -s $PREFIX/lib/ecl-* $PREFIX/lib/ecl
ln -s $PREFIX/include/ecl $PREFIX/lib/ecl/ecl
