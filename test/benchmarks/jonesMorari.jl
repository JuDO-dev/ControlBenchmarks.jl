using ControlBenchmarks
using ControlSystems

(sys, sBounds, inBounds) = controlbenchmark( JonesMorari() )

@test ControlSystems.nstates( sys ) == 4
@test ControlSystems.ninputs( sys ) == 2
