# IPCC Elmer - Second phase 

## OpenMP SIMD and threading
 
Improvements on the performance of Elmer have been achieved utilizing OpenMP threading and SIMD directives directly in the code and utilizing threaded libraries for operations during matrix assembly as well as for the solution of the global assembled matrix. These measures can be summarized in the following list
* Evaluate basis functions at all integration points in one function call
* Assemble local system matrix using optimized DGEMM call from BLAS
* Thread the element loop on each MPI task
* Utilize CPardiso/Pardiso
Their implementation is to be found within the following commits to the Elmer main repository at GitHub:
  * https://github.com/ElmerCSC/elmerfem/pull/100 
  * https://github.com/ElmerCSC/elmerfem/pull/92
  * https://github.com/ElmerCSC/elmerfem/pull/83
  * https://github.com/ElmerCSC/elmerfem/pull/80
The implementation for using cPardiso was done in an earlier commit(https://github.com/ElmerCSC/elmerfem/pull/43)

## Comparison of previous to new Poisson problem results

Like in the [previous](https://github.com/cschpc/elmer-on-KNL/blob/master/Reports/Initial_porting.md) phase, a simple test case solving the Poisson problem on an  unit-cube was set up, in order to evaluate the improvements achieved by the measures reported above.

