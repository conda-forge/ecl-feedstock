#!/bin/bash
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/gnuconfig/config.* ./src/gmp
cp $BUILD_PREFIX/share/gnuconfig/config.* ./src

export CC=$(basename $CC)
export AR=$(basename $AR)
export RANLIB=$(basename $RANLIB)
export CFLAGS="-g $CFLAGS"

if [[ "$target_platform" == osx-* ]]; then
    export CFLAGS="-Wno-unknown-attributes $CFLAGS"
fi

if [[ "$CONDA_BUILD_CROSS_COMPILATION" == "1" ]]; then
  export ECL_TO_RUN=$BUILD_PREFIX/bin/ecl
  if [[ "$target_platform" == "osx-arm64" ]]; then
    cp src/util/iOS-arm64.cross_config cross_config
    cp src/util/iOS-arm64.cross_config src/cross_config
  fi
fi

chmod +x configure
./configure \
        --prefix="$PREFIX" \
        --libdir="$PREFIX/lib" \
        --with-gmp-prefix="$PREFIX" \
        --with-libgc-prefix="$PREFIX" \
        --with-libffi-prefix="$PREFIX" \
        --enable-boehm=system \
        --enable-libatomic=system \
        --with-dffi=system \
        --enable-unicode=yes \
        --with-extra-files="$SRC_DIR/src/util/side-modules.lsp"

# Before running make we touch build/TAGS so its building process is never triggered
touch build/TAGS

# Default search path for (require :<module>), baked into the image by
# side-modules.patch; can be overridden at runtime with the same variable.
export ECL_SIDE_MODULES_PATH="$PREFIX/lib/ecl-$PKG_VERSION"

make -j${CPU_COUNT}
make install
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
  make check
fi

ln -s $PREFIX/lib/ecl-* $PREFIX/lib/ecl
ln -s $PREFIX/include/ecl $PREFIX/lib/ecl/ecl

cat $SRC_DIR/build/cmp/cmpdefs.lsp
mkdir -p $PREFIX/share/ecl
sed "s/defvar/defparameter/g" $SRC_DIR/build/cmp/cmpdefs.lsp > $PREFIX/share/ecl/cmpdefs.lsp
