#!/bin/bash

if [[ $(uname) == Darwin ]]; then
  export LIBRARY_SEARCH_VAR=DYLD_FALLBACK_LIBRARY_PATH
elif [[ $(uname) == Linux ]]; then
  export LIBRARY_SEARCH_VAR=LD_LIBRARY_PATH
fi

export PYTHON="$PYTHON"
export PYTHON_LDFLAGS="$PREFIX/lib"
export LDFLAGS="$LDFLAGS -L$PREFIX/lib -Wl,-rpath,$PREFIX/lib"
export CFLAGS="$CFLAGS -fPIC -I$PREFIX/include"

mkdir build_ecmwf && cd build_ecmwf
cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D ENABLE_JPG=1 \
      -D ENABLE_NETCDF=1 \
      -D ENABLE_PNG=1 \
      -D ENABLE_FORTRAN=0 \
      -D ENABLE_PYTHON=1 \
      $SRC_DIR
make
make install

if [[ $(uname) == Darwin ]]; then
  ln -s $SP_DIR/gribapi/_gribapi_swig.dylib $SP_DIR/gribapi/_gribapi_swig.so
fi
