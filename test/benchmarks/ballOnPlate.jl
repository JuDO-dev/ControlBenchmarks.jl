using ControlBenchmarks
using ControlSystems

(sys, sBounds, inBounds) = controlbenchmark( BallOnPlate() )

@test ControlSystems.nstates( sys ) == 2
@test ControlSystems.ninputs( sys ) == 1
