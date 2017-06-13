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

**Table 1.** Comparison of timings between non-optimized and optimized version of PoissonThreaded example on Xeon E5-2690v3, 12-core

| polynom. degree | Assembly (s) | Linear Solve (s)|Assembly (s) | Linear Solve (s)| performance enhancement|performance enhancement|
|:---------------:|:-------------|-----------------|:------------|:----------------|:-----------------------|:-----------------------|
|                 |**non-optimized**| **non-optimized**|**optimized**| **optimized**|**Assmebly**  |**Linear Solve**|
|	1	  |1.74E-01	 |      6.90E-02   | 1.70E-02  |5.99E-02|10.24522396|1.067806954|
|	2	  |2.76E-01	 |	5.06E-01   | 2.89E-01  |4.41E-01|0.953407001|1.123007384|
|	3	  |8.10E-01	 |	1.17E+00   | 1.70E-01  |1.09E+00|4.759475921|1.067094734|
|	4	  |2.95E+00	 |	3.68E+00   | 5.79E-01  |3.64E+00|5.094699268|1.011871764|
|	5	  |9.53E+00	 |	1.03E+01   | 1.59E+00  |1.04E+01|5.987829908|0.995063425|
|	6	  |2.72E+01	 |	6.60E+00   | 4.19E+00  |5.81E+00|6.502229581|1.134924488|


**Table 2.** Comparison of timings between non-optimized and optimized version of PoissonThreaded example on KNL (Xeon Phi 7210)

	













	
	
	

