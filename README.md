# Elmer
[Elmer](http://www.elmerfem.org) is an open source FEM code owned by [CSC](http://www.csc.fi/elmer].
 Elmer is used for multi-physics simulations, including solid and fluid mechanics, heat transfer,
 electrostatics and dynamics as well as acoustics. 
 Elmer mainly is written in Fortran 90, with some parts in C. It original parallel paradigm is MPI.
 Elmer can be linked to external libraries delivering for linear system solutions, such as MUMPS,
 Hypre, Trilinos and Pardiso. The code consists of different solver modules. Some of them have been
 augmented with OpenMP directives, both, for multi-threading as well as vectorization.
 
## Porting
 
The code has been ported to CSC's KNL test environment Ninja, consisting of the Intel Knights Landing
(KNL) 7210  processor running CentOS 7.2. Compilation was done using Intel Parallel Studio version 17.1.043,
using MKL linked in as a replacement for the default (NetLIB) LaPack and BLAS libraries. Elmer build process
relies on cmake. The corresponding configuration and compilation script and the needed toolchain file are in
this very folder. Initially, as we used the seemingly buggy 17.0.035 version of Intel Parallel Studio, a 
special branch [ElmerCSC/ifort-workaround](https://github.com/ElmerCSC/elmerfem/tree/ifort-workaround) 
was created that avoided compilation errors. With the later version, we can directly build the main development
branch [ElmerCSC/devel](https://github.com/ElmerCSC/elmerfem/tree/devel).

## Code Adaptation

Code modification towards a mutli-threaded and thread safe version of Elmer started a few years by enabling
the switch from GNU-autotools to cmake as the building system for Elmer in order to enable cross-platform compilations.
Already during the earlier stage Intel Parallel Computing Center the concept of mesh colouring has been introduced,
but only on the basis of the assembly of a single solver. Mesh colouring is needed in order to avoid race conditions
in the multi-threaded Finite Element matrix assembly. In the further, this functionality has been included in the 
default operations of Elmer, hence making this a library feature that in a generalized flexible way now can be used for 
any solver, simply by a flag added to the original default routines for matrix assembly, thereby guaranteeing backwards
compatibility.
