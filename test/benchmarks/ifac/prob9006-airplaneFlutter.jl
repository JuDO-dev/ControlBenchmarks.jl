using ControlBenchmarks
using ControlSystems
using SparseArrays

sys = controlbenchmark( B767FlutterCondition() )

@test ControlSystems.nstates( sys ) == 55
@test ControlSystems.ninputs( sys ) == 2

# Ensure it is a sparse matrix
@test issparse( sys.A )
@test issparse( sys.B )
@test issparse( sys.C )
@test issparse( sys.D )
