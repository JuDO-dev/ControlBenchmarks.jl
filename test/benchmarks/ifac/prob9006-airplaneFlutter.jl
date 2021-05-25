using ControlBenchmarks
using ControlSystems
using SparseArrays

benchmarkProb = controlbenchmark( B767FlutterCondition() )

@test ControlSystems.nstates( benchmarkProb.sys ) == 55
@test ControlSystems.ninputs( benchmarkProb.sys ) == 2

# Ensure it is a sparse matrix
@test issparse( benchmarkProb.sys.A )
@test issparse( benchmarkProb.sys.B )
@test issparse( benchmarkProb.sys.C )
@test issparse( benchmarkProb.sys.D )
