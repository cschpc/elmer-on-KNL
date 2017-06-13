# IPCC Elmer - Second phase 

## OpenMP SIMD and threading
 
Improvements on the performance of Elmer have been achieved utilizing OpenMP threading and SIMD directives directly in the code and utilizing threaded libraries for operations during matrix assembly as well as for the solution of the global assembled matrix. These measures can be summarized in the following list
* Evaluate basis functions at all integration points in one function call
* Assemble local system matrix using optimized DGEMM call from BLAS
* Thread the element loop on each MPI task
* Utilize CPardiso/Pardiso

Their implementation is to be found within the following commits to the Elmer main repository at GitHub (here represented by the correpsonding pull requests):
* https://github.com/ElmerCSC/elmerfem/pull/100 
* https://github.com/ElmerCSC/elmerfem/pull/92
* https://github.com/ElmerCSC/elmerfem/pull/83
* https://github.com/ElmerCSC/elmerfem/pull/80

The implementation enabling cPardiso was done in an earlier commit(https://github.com/ElmerCSC/elmerfem/pull/43)

## Comparison of previous to new Poisson problem results

Like in the [previous](https://github.com/cschpc/elmer-on-KNL/blob/master/Reports/Initial_porting.md) phase, a simple test case solving the Poisson problem on an  unit-cube was set up, in order to evaluate the improvements achieved by the measures reported above. The problem size is given by 64k hexahedral elements. The reason for the compared to the [previous](https://github.com/cschpc/elmer-on-KNL/blob/master/Reports/Initial_porting.md) phase way smaller mesh size is justified by the fact that in case of very high polynomial degree (first column in tables below) the needed memory consumption increases exponentially with mesh size. Hence the problem size has to be accomodated to match the available memory in case of the highest degree being applied. Comparsion was done using the [PoissonPFEM](https://github.com/ElmerCSC/elmerfem/blob/devel/fem/tests/PoissonPFEM/Poisson.f90) test and a test similar to [PoissonThreaded](https://github.com/ElmerCSC/elmerfem/blob/devel/fem/tests/PoissonThreaded/Poisson.F90) that utilizes the basis function vectorizations and optimized assembly routines.
<!-- Elmer revision [aab88925](https://github.com/ElmerCSC/elmerfem/commit/aab88925498b66b120a80e839e497913b23ebcb9) (old, non-optimized version) with the revison [ae60671](https://github.com/ElmerCSC/elmerfem/commit/ae60671c0f44225e251c490465ca2155ffd3150f) (version including the pull-requests from above). -->

<!-- The relatively small problem size can be held repsonsible for the unusual performance for small polynomial degrees on the Xeon E5 platform (HSW). Nevertheless, past p=2 the to-be-expected enhancement in performance with increasing polynomial degree is similar than the one observed on KNL. -->

**Table 1.** Comparison of timings between non-optimized and optimized version of PoissonThreaded example on Xeon E5-2690v3, 12-core

| polynom. degree | Assembly (s) | Linear Solve (s)|Assembly (s) | Linear Solve (s)| performance enhancement|performance enhancement|
|:---------------:|:-------------|-----------------|:------------|:----------------|:-----------------------|:-----------------------|
|                 |**non-optimized**| **non-optimized**|**optimized**| **optimized**|**Assembly**  |**Linear Solve**|
|	1	  |1.74E-01	 |      6.90E-02   | 1.70E-02  |5.99E-02|10.24522396|1.067806954|
|	2	  |2.76E-01	 |	5.06E-01   | 2.89E-01  |4.41E-01|0.953407001|1.123007384|
|	3	  |8.10E-01	 |	1.17E+00   | 1.70E-01  |1.09E+00|4.759475921|1.067094734|
|	4	  |2.95E+00	 |	3.68E+00   | 5.79E-01  |3.64E+00|5.094699268|1.011871764|
|	5	  |9.53E+00	 |	1.03E+01   | 1.59E+00  |1.04E+01|5.987829908|0.995063425|
|	6	  |2.72E+01	 |	6.60E+00   | 4.19E+00  |5.81E+00|6.502229581|1.134924488|


KNL perfomrance is compared using a whole node of a Xeon Phi 7210 either with one MPI task/core (Table 2) or using OpenMP threads (Table 3). It is obvious that, while the assembly phase has a similar increase in performance compared to the multi-tasked MPI implementation, the solution phase did not utilize multi-threaded solvers in this case.

**Table 2.** Comparison of timings between non-optimized and optimized version of PoissonThreaded example on KNL (Xeon Phi 7210) using MPI tasks on KNL

| polynom. degree | Assembly (s) | Linear Solve (s)|Assembly (s) | Linear Solve (s)| performance enhancement|performance enhancement|
|:---------------:|:-------------|-----------------|:------------|:----------------|:-----------------------|:-----------------------|
|                 |**non-optimized**| **non-optimized**|**optimized**| **optimized**|**Assembly**  |**Linear Solve**|
|	1	  |6.96E-02	 | 1.93E-01        | 3.63E-02  |1.25E-01|1.92E+00|1.60E+00|
|	2	  |4.76E-01	 | 7.01E-01	   | 1.69E-01  |4.52E-01|2.81E+00|1.57E+00|
|	3	  |1.40E+00	 | 1.47E+00	   | 2.94E-01  |9.74E-01|4.75E+00|1.48E+00|
|	4	  |5.73E+00	 | 3.48E+00	   | 1.07E+00  |2.68E+00|5.36E+00|1.28E+00|
|	5	  |2.14E+01	 | 8.64E+00	   | 2.41E+00  |7.44E+00|8.87E+00|1.16E+00|
|	6	  |5.36E+01	 | 6.45E+00	   | 5.87E+00  |4.55E+00|9.14E+00|1.41E+00|	

**Table 3.** Comparison of timings between non-optimized and optimized version of PoissonThreaded example on KNL (Xeon Phi 7210) using OMP threads on KNL

| polynom. degree | Assembly (s) | Linear Solve (s)|Assembly (s) | Linear Solve (s)| performance enhancement|performance enhancement|
|:---------------:|:-------------|-----------------|:------------|:----------------|:-----------------------|:-----------------------|
|                 |**non-optimized**| **non-optimized**|**optimized**| **optimized**|**Assmebly**  |**Linear Solve**|
|	1	  |6.96E-02	 | 1.93E-01        | 4.59E-02|	1.68E-01| 1.52E+00|	2.39E-02|
|	2	  |4.76E-01	 | 7.01E-01	   | 2.13E-01|	6.43E-01| 2.23E+00|	2.01E-02|
|	3	  |1.40E+00	 | 1.47E+00	   | 3.11E-01|	1.49E+00| 4.49E+00|	2.54E-02|
|	4	  |5.73E+00	 | 3.48E+00	   | 1.17E+00|	2.48E+00| 4.91E+00|	4.80E-02|
|	5	  |2.14E+01	 | 8.64E+00	   | 2.61E+00|	3.94E+00| 8.19E+00|	8.38E-02|
|	6	  |5.36E+01	 | 6.45E+00	   | 6.13E+00|	6.05E+00| 8.76E+00|	4.25E-02|	






	






	
	
	
	
	
	

	
	
	












	
	
	

