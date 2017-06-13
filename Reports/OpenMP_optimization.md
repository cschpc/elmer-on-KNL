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

The implementation enabling cPardiso was done in an earlier commit(https://github.com/ElmerCSC/elmerfem/pull/43)

## Comparison of previous to new Poisson problem results

Like in the [previous](https://github.com/cschpc/elmer-on-KNL/blob/master/Reports/Initial_porting.md) phase, a simple test case solving the Poisson problem on an  unit-cube was set up, in order to evaluate the improvements achieved by the measures reported above. The problem size is given by 64k hexahedral elements.

**Table 1.** Comparison of timings between non-optimized and optimized version of PoissonThreaded example

| polynom. degree | Assembly (s) | Linear Solve (s)|
|:---------------:|:-------------|-----------------|
|	1	  |1.74E-01	 |  	6.90E-02   |
|	2	  |2.76E-01	 |	5.06E-01   |
|	3	  |8.10E-01	 |	1.17E+00   |
|	4	  |2.95E+00	 |	3.68E+00   |
|	5	  |9.53E+00	 |	1.03E+01   |
|	6	  |2.72E+01	 |	6.60E+00   |





