#!/bin/bash

CMAKE=cmake

# Installation directory (set these!)
TIMESTAMP=$(date +"%m-%d-%y")
ELMERSRC="/homeappl/home/zwinger/Source/"
pushd ${ELMERSRC}/elmerfem
VERSION=$(git log -1 --pretty=format:%h)
popd
ELMER_REV="Elmer_intel17_${VERSION}_${TIMESTAMP}_devel_omp_AVX"
BUILDDIR="${ELMERSRC}/builddir_2017"
IDIR="/scratch/${ELMER_REV}"
TOOLCHAIN="$ELMERSRC/Elmer-linux-intel-knl_avx.cmake "
echo "Building Elmer from within " ${BUILDDIR}
#echo "using following toolchain file " ${TOOLCHAIN}
echo "installation into " ${IDIR}
cd ${BUILDDIR}
pwd
ls -ltr
rm -fr *
ls -ltr

echo $CMAKE $ELMERSRC #-DCMAKE_TOOLCHAIN_FILE=$TOOLCHAIN

$CMAKE $ELMERSRC/elmerfem -DCMAKE_TOOLCHAIN_FILE=${TOOLCHAIN} \
    -DCMAKE_BUILD_TYPE=None \
    -DCMAKE_INSTALL_PREFIX=$IDIR \
    -DWITH_MPI:BOOL=TRUE \
    -DWITH_OpenMP:BOOL=TRUE \
    -DWITH_MKL:BOOL=TRUE \
    -DWITH_Mumps:BOOL=FALSE \
    -DWITH_Hypre:BOOL=FALSE \
    -DWITH_ELMERGUI:BOOL=FALSE \
    -DBYPASS_CPACK:BOOL=TRUE
#$CMAKE $ELMERSRC/elmerfem -C$PRECACHE\
#    -DCMAKE_BUILD_TYPE=DEBUG\
#    -DCMAKE_INSTALL_PREFIX=$IDIR \
#    -DWITH_MPI:BOOL=TRUE \
#    -DWITH_Mumps:BOOL=TRUE \
#    -DWITH_Hypre:BOOL=TRUE \
#    -DWITH_Trilinos:BOOL=FALSE \
#    -DWITH_ElmerIce:BOOL=TRUE \
#    -DWITH_ELMERGUI:BOOL=TRUE \
#    -DWITH_OCC:BOOL=TRUE \
#    -DWITH_PARAVIEW:BOOL=TRUE \
#    -DWITH_PYTHONQT:BOOL=TRUE \
#    -DWITH_QWT:BOOL=TRUE \
#    -DWITH_VTK:BOOL=TRUE \
#    -DWITH_PYTHONQT:BOOL=FALSE \
#    -DWITH_MATC:BOOL=TRUE 

pwd				 
#make -j3 && sudo make install

#sudo rm /usr/local/Elmer-devel
#sudo ln -s $IDIR /usr/local/Elmer-devel

# cp  $IDIR/share/elmersolver/lib/FreeSurfaceSolver.so $HOME/lib/MyFreeSurfaceSolver.so
# chmod a+x  $HOME/lib/MyFreeSurfaceSolver.so
