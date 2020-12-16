# CFITSIO with Modern CMake compilation
Modern CMake implementation for CFITSIO 3.49 library. For more information visit the official CFITSIO website: https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html

Changes include (but not limited to):
- Changed to CMake 3.17;
- Moved all source files into `cfitsio` directory;
- Forbid in-source builds;
- Fixed `Findpthreads not found` error;
- Fixed default build type to `Release`;
- Changed `-DUseCurl` into `-DUSE_CURL`;
