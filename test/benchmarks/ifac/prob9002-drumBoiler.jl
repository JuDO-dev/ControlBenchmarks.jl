using ControlBenchmarks
using ControlSystems

sys = controlbenchmark( DrumBoiler() )

@test ControlSystems.nstates( sys ) == 9
@test ControlSystems.ninputs( sys ) == 3
