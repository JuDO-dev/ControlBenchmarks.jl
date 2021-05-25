using ControlBenchmarks
using ControlSystems

benchmarkProb = controlbenchmark( BallOnPlate() )

@test ControlSystems.nstates( benchmarkProb.sys ) == 2
@test ControlSystems.ninputs( benchmarkProb.sys ) == 1
