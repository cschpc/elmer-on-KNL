# CMake toolchain file for building on KNL
# 
# Author: Mikko Byckling, Intel corporation
# Version: 0.1

# No need to cross-compile for SNB nodes on taito.csc.fi,
# i.e., do NOT set CMAKE_SYSTEM_NAME etc. here 
SET(CMAKE_SYSTEM_NAME Linux)
SET(CMAKE_SYSTEM_PROCESSOR x86_64)
SET(CMAKE_SYSTEM_VERSION 1)

# Specify the cross compilers (serial)
SET(CMAKE_C_COMPILER icc)
SET(CMAKE_Fortran_COMPILER ifort)
SET(CMAKE_CXX_COMPILER icpc)

# Specify the cross compilers (parallel)
SET(MPI_C_COMPILER mpiicc)
SET(MPI_CXX_COMPILER mpiicpc)
SET(MPI_Fortran_COMPILER mpiifort)

# Compilation flags (i.e. with optimization)
SET(CMAKE_C_FLAGS "-O2 -g" CACHE STRING "")
SET(CMAKE_CXX_FLAGS "-O2 -g" CACHE STRING "")
SET(CMAKE_Fortran_FLAGS "-O2 -g -x=MIC-AVX512 -align array64byte -finline-functions -finline-limit=1000 -no-prec-div -no-prec-sqrt" CACHE STRING "")

SET(MPIEXEC mpirun)

# BLAS and LAPACK (from OpenBLAS, TODO)
# SET(BLAS_LIBRARIES $ENV{OPENBLASROOT}/lib/libopenblas.so  CACHE STRING "")
# SET(LAPACK_LIBRARIES $ENV{OPENBLASROOT}/lib/libopenblas.so  CACHE STRING "")
