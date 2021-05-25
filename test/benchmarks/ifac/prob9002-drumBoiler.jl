using ControlBenchmarks
using ControlSystems

benchmarkProb = controlbenchmark( DrumBoiler() )

@test ControlSystems.nstates( benchmarkProb.sys ) == 9
@test ControlSystems.ninputs( benchmarkProb.sys ) == 3
