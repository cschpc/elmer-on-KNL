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

Code modification towards a mutli-threaded and thread safe version of Elmer already started a few years ago by enabling
the switch from GNU-autotools to cmake as the building system for Elmer in order to enable cross-platform compilations.
Already during the earlier stage Intel Parallel Computing Center the concept of mesh colouring has been introduced,
but only on the basis of the assembly of a single solver. Mesh colouring is needed in order to avoid race conditions
in the multi-threaded Finite Element matrix assembly. In the further, this functionality has been included in the 
default operations of Elmer, hence making this a library feature that in a generalized flexible way now can be used for 
any solver, simply by a flag added to the original default routines for matrix assembly, thereby guaranteeing backwards
compatibility.

## Performance Tests

We chose a specially with OpenMP for multi-threaded and vectorized matrix assembly adapted Solver, which is to be
 found in the Elmer test suite, [PoissonThreaded](https://github.com/ElmerCSC/elmerfem/tree/devel/fem/tests/PoissonThreaded).
 The testcase, as the name suggests, solves the Poisson equation using the weak formulation and hence represents a standard
 elliptic problem in FEM. Simply, the mesh size of only about 70k nodes in the test-case mentioned above was too small,
 which led us to create tow additional meshes, cube2.grd and cube3.grd that contain 1M and 3.3M nodes, respectively.
 Since the solver does not allow for improved multi-threaded and vectorized solution of the linear system, we confined our
 investigation in first instance to the assembly part of the matrix. Modifying a 
 [blueprint test-script](https://github.com/cschpc/ninja-scripts/tree/master/benchmarking/parametersweep), we tested different
 combination of MPI tasks and OpenMP threads for these two sizes of problems and compared each resulting time
 needed for matrix assembly with the value we got from a pure MPI parallel run on a two Haswell E5-2690v3, 12-core
 (hence 24 cores/tasks in total) on CSC's supercomputer sisu.
 
**Table 1.** Runs on one node of Sisu, using 2 Haswell (Xeon E5-2690v3, 12-core) processors using 12
MPI processes per CPU and 1 thread per process.

case   | size       | assembly  | total runtime
-------|------------|-----------|---------------
 cube2 | 1M nodes   |  0.6151 s |   2.68 s
 cube3 | 3.3M nodes |  2.0620 s |  10.34 s
 
The test runs on KNL were run in cached mode. Fixed parameters were the setting for the I_MPI_PIN_ORDER="compact". Varying parameters were the range of the MPI tasks (1,2,4,8,16,32,64) which determined the threads per task (OMP_NUM_THREADS) according to the different settings for the hypertrheading with the setting out of (1,2,4).
 
**Table 2.** Runs for test case cube2 (1 Mio. nodes) on KNL 7210 Xeon Phi processor in cached mode.

KMP_AFFINITY | MPI   | threads/task    | assembly time (s) | performance
-------------|-------|-----------------|-------------------|----------------------
             | tasks | (hypertreading) | assembly time (s) | timing KNL/E5-2690v3
compact | 1 | 64 (1) | 2.2498 | 3.65762
compact | 2 | 32 (1) | 1.9855 | 3.22793
compact | 4 | 16 (1) | 1.8974 | 3.0847
compact | 8 | 8 (1) | 1.8474 | 3.00341
compact | 16 | 4 (1) | 1.7792 | 2.89254
compact | 32 | 2 (1) | 1.6398 | 2.66591
compact | 64 | 1 (1) | 1.9583 | 3.18371
compact | 1 | 128 (2) | 2.4596 | 3.9987
compact | 2 | 64 (2) | 2.4051 | 3.9101
compact | 4 | 32 (2) | 2.4592 | 3.99805
compact | 8 | 16 (2) | 2.5132 | 4.08584
compact | 16 | 8 (2) | 2.5406 | 4.13039
compact | 32 | 4 (2) | 2.4804 | 4.03252
compact | 64 | 2 (2) | 2.5309 | 4.11462
compact | 1 | 256 (4) | 2.4953 | 4.05674
compact | 2 | 128 (4) | 2.3154 | 3.76427
compact | 4 | 64 (4) | 2.2716 | 3.69306
compact | 8 | 32 (4) | 2.6056 | 4.23606
compact | 16 | 16 (4) | 2.5933 | 4.21606
compact | 32 | 8 (4) | 2.4964 | 4.05853
compact | 64 | 4 (4) | 2.4908 | 4.04942
scatter | 1 | 64 (1) | 2.3421 | 3.80767
scatter | 2 | 32 (1) | 1.8964 | 3.08308
scatter | 4 | 16 (1) | 1.7985 | 2.92391
scatter | 8 | 8 (1) | 1.7584 | 2.85872
scatter | 16 | 4 (1) | 1.7453 | 2.83742
scatter | 32 | 2 (1) | 1.7464 | 2.83921
scatter | 64 | 1 (1) | 1.9962 | 3.24533
scatter | 1 | 128 (2) | 2.4281 | 3.94749
scatter | 2 | 64 (2) | 2.4307 | 3.95172
scatter | 4 | 32 (2) | 2.5144 | 4.08779
scatter | 8 | 16 (2) | 2.6426 | 4.29621
scatter | 16 | 8 (2) | 2.5254 | 4.10567
scatter | 32 | 4 (2) | 2.4634 | 4.00488
scatter | 64 | 2 (2) | 2.5302 | 4.11348
scatter | 1 | 256 (4) | 2.4142 | 3.92489
scatter | 2 | 128 (4) | 2.2800 | 3.70671
scatter | 4 | 64 (4) | 2.2708 | 3.69176
scatter | 8 | 32 (4) | 2.5897 | 4.21021
scatter | 16 | 16 (4) | 2.5689 | 4.17639
scatter | 32 | 8 (4) | 2.4920 | 4.05137
scatter | 64 | 4 (4) | 2.4986 | 4.0621
balanced | 1 | 64 (1) | 2.2709 | 3.69192
balanced | 2 | 32 (1) | 1.8956 | 3.08178
balanced | 4 | 16 (1) | 1.8829 | 3.06113
balanced | 8 | 8 (1) | 1.8011 | 2.92814
balanced | 16 | 4 (1) | 1.7021 | 2.76719
balanced | 32 | 2 (1) | 1.7118 | 2.78296
balanced | 64 | 1 (1) | 1.8759 | 3.04975
balanced | 1 | 128 (2) | 2.3986 | 3.89953
balanced | 2 | 64 (2) | 2.4316 | 3.95318
balanced | 4 | 32 (2) | 2.4507 | 3.98423
balanced | 8 | 16 (2) | 2.6594 | 4.32352
balanced | 16 | 8 (2) | 2.4849 | 4.03983
balanced | 32 | 4 (2) | 2.4522 | 3.98667
balanced | 64 | 2 (2) | 2.4983 | 4.06162
balanced | 1 | 256 (4) | 2.3840 | 3.87579
balanced | 2 | 128 (4) | 2.2563 | 3.66818
balanced | 4 | 64 (4) | 2.2605 | 3.67501
balanced | 8 | 32 (4) | 2.6199 | 4.25931
balanced | 16 | 16 (4) | 2.5738 | 4.18436
balanced | 32 | 8 (4) | 2.5060 | 4.07413
balanced | 64 | 4 (4) | 2.4791 | 4.0304

The overall runtime for the optimal case in Table 2 (compact-mode with 32 MPI tasks and 2 threads/task, i.e. no hyperthreading) was 6.80 seconds, leading to a relative performance with respect to a Xeon E5-2690v3 node of 6.80/2.68 = 2.54, which surprisingly is slightly better than the assembly-only performance of 2.67. We like to stress the fact that these numbers are only based on single instance runs with no statistics being collected and hence should be interpreted with respect to this background.

**Table 3.** Runs for test case cube3 (3.3 Mio. nodes) on KNL 7210 Xeon Phi processor in cached mode.

KMP_AFFINITY | MPI   | threads/task    | assembly time (s) | performance
-------------|-------|-----------------|-------------------|----------------------
             | tasks | (hypertreading) | assembly time (s) | timing KNL/E5-2690v3
compact | 2 | 32 (1) | 6.2505 | 3.03128
compact | 4 | 16 (1) | 6.1572 | 2.98603
compact | 8 | 8 (1) | 6.0782 | 2.94772
compact | 16 | 4 (1) | 5.9067 | 2.86455
compact | 32 | 2 (1) | 5.2953 | 2.56804
compact | 64 | 1 (1) | 5.9947 | 2.90723
compact | 2 | 64 (2) | 7.9943 | 3.87696
compact | 4 | 32 (2) | 8.3438 | 4.04646
compact | 8 | 16 (2) | 8.3390 | 4.04413
compact | 16 | 8 (2) | 8.5355 | 4.13943
compact | 32 | 4 (2) | 7.9908 | 3.87527
compact | 64 | 2 (2) | 8.3313 | 4.0404
compact | 2 | 128 (4) | 7.4633 | 3.61945
compact | 4 | 64 (4) | 7.5706 | 3.67148
compact | 8 | 32 (4) | 8.4612 | 4.10339
compact | 16 | 16 (4) | 8.7333 | 4.23535
compact | 32 | 8 (4) | 8.1695 | 3.96193
compact | 64 | 4 (4) | 8.2248 | 3.98875
scatter | 2 | 32 (1) | 6.3669 | 3.08773
scatter | 4 | 16 (1) | 6.2917 | 3.05126
scatter | 8 | 8 (1) | 6.3321 | 3.07085
scatter | 16 | 4 (1) | 5.3333 | 2.58647
scatter | 32 | 2 (1) | 5.4243 | 2.6306
scatter | 64 | 1 (1) | 5.7641 | 2.79539
scatter | 2 | 64 (2) | 7.9519 | 3.8564
scatter | 4 | 32 (2) | 8.4090 | 4.07808
scatter | 8 | 16 (2) | 8.3503 | 4.04961
scatter | 16 | 8 (2) | 8.1920 | 3.97284
scatter | 32 | 4 (2) | 8.1317 | 3.9436
scatter | 64 | 2 (2) | 8.1482 | 3.9516
scatter | 2 | 128 (4) | 7.4120 | 3.59457
scatter | 4 | 64 (4) | 7.5423 | 3.65776
scatter | 8 | 32 (4) | 8.4186 | 4.08274
scatter | 16 | 16 (4) | 8.6680 | 4.20369
scatter | 32 | 8 (4) | 8.2942 | 4.02241
scatter | 64 | 4 (4) | 8.1412 | 3.94821
balanced | 2 | 32 (1) | 6.4096 | 3.10844
balanced | 4 | 16 (1) | 5.8557 | 2.83982
balanced | 8 | 8 (1) | 6.6180 | 3.20951
balanced | 16 | 4 (1) | 5.5102 | 2.67226
balanced | 32 | 2 (1) | 5.3160 | 2.57808
balanced | 64 | 1 (1) | 5.7416 | 2.78448
balanced | 2 | 64 (2) | 8.0363 | 3.89733
balanced | 4 | 32 (2) | 8.4098 | 4.07847
balanced | 8 | 16 (2) | 8.3095 | 4.02983
balanced | 16 | 8 (2) | 8.3710 | 4.05965
balanced | 32 | 4 (2) | 8.0805 | 3.91877
balanced | 64 | 2 (2) | 8.1906 | 3.97216
balanced | 2 | 128 (4) | 7.9155 | 3.83875
balanced | 4 | 64 (4) | 8.0540 | 3.90592
balanced | 8 | 32 (4) | 8.3631 | 4.05582
balanced | 16 | 16 (4) | 8.7819 | 4.25892
balanced | 32 | 8 (4) | 8.2886 | 4.01969
balanced | 64 | 4 (4) | 8.2159 | 3.98443

Again, the best performance with respect to Xeon E5-2690v3 node is obtained with the combination (compact-mode with 32 MPI tasks and 2 threads/task, i.e. no hyperthreading). The single task runs all failed with a segmentation fault (reason unknown). Comparing the overall runtimes between those two platforms, we obtain a value of 21.79/10.34=2.11, which again is well below the one for the assembly stage, 2.57. Cheking the other components for this case we get the following values

**Table 4.** Timings of sub-processes accessible to timings for case cube3 (3.3M nodes)

simulation stage   |   Xeon E5-2690v3     | Xeon Phi KNL 7210  | relative
-------------------|----------------------|--------------------|---------
LoadMesh           |    0.6452 s          |    1.6390 s        | 2.54
MeshStabParams     |    0.0275 s          |    0.0511 s        | 1.86
Assembly           |    2.0620 s          |    5.2953 s        | 2.57

As there has been no output, the slightly improved performance of the complete simulation with respect to the assembly phase must come from either the solution stage or other factors.


