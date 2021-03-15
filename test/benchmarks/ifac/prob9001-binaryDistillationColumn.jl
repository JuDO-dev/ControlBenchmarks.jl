using ControlBenchmarks
using ControlSystems
using SparseArrays

(sys, sBounds, inBounds) = controlbenchmark( BinaryDistillationColumn() )

@test ControlSystems.nstates( sys ) == 11
@test ControlSystems.ninputs( sys ) == 3

# Ensure it is a sparse matrix
@test issparse( sys.A )
@test issparse( sys.B )
@test issparse( sys.C )
@test issparse( sys.D )
