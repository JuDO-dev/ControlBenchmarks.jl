using ControlBenchmarks
using ControlSystems
using SparseArrays

benchmarkProb = controlbenchmark( BinaryDistillationColumn() )

@test ControlSystems.nstates( benchmarkProb.sys ) == 11
@test ControlSystems.ninputs( benchmarkProb.sys ) == 3

# Ensure it is a sparse matrix
@test issparse( benchmarkProb.sys.A )
@test issparse( benchmarkProb.sys.B )
@test issparse( benchmarkProb.sys.C )
@test issparse( benchmarkProb.sys.D )
