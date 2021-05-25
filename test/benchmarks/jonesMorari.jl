using ControlBenchmarks
using ControlSystems

benchmarkProb = controlbenchmark( JonesMorari() )

@test ControlSystems.nstates( benchmarkProb.sys ) == 4
@test ControlSystems.ninputs( benchmarkProb.sys ) == 2
