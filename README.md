# Elmer
[Elmer](http://www.elmerfem.org) is an open source FEM code owned by [CSC](http://www.csc.fi/elmer).
 Elmer is used for multi-physics simulations, including solid and fluid mechanics, heat transfer,
 electrostatics and dynamics as well as acoustics broadly used in engineering. The most prominent
 scientific application of the code is within theoretical Glaciology by the add-on package 
 [Elmer/Ice](http://elmerice.elmerfem.org).
 Elmer mainly is written in Fortran 90, with some parts in C. It original parallel paradigm is MPI.
 Elmer can be linked to external libraries delivering for linear system solutions, such as MUMPS,
 Hypre, Trilinos and Pardiso. The code consists of different solver modules. Some of them have been
 augmented with OpenMP directives, both, for multi-threading as well as vectorization.
 
## Activity within IPCC
 
The [initial phase](https://github.com/cschpc/elmer-on-KNL/blob/master/Reports/Initial_porting.md) was accomplished by porting and testing different settings on KNL to achieve best practice recipes for running on that platform. 

The second phase dealt with the introduction of SIMD and multi-threading OpenMP instructions to optimize the performance of Elmer on Xeon Phi as well as Xeon CPUs.


