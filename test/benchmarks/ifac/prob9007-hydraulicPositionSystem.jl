using ControlBenchmarks
using ControlSystems

# Test the default constructor
let benchmarkProb = controlbenchmark( HydraulicPositioningSystem() )
    @test ControlSystems.nstates( benchmarkProb.sys ) == 3
    @test ControlSystems.ninputs( benchmarkProb.sys ) == 1
end


# Test setting a non-default value for a parameter
let hydPosSys = HydraulicPositioningSystem()
    hydPosSys.B = 10000

    benchmarkProb = controlbenchmark( hydPosSys )
    @test ControlSystems.nstates( benchmarkProb.sys ) == 3
    @test ControlSystems.ninputs( benchmarkProb.sys ) == 1
end


# Test setting a non-default value for a parameter that is out of bounds
let hydPosSys = HydraulicPositioningSystem()
    hydPosSys.B = 8000

    # Test without ignoring the bounds
    @test_throws DomainError controlbenchmark( hydPosSys; ignoreBounds = false )

    # Test while ignoring the bounds
    benchmarkProb = controlbenchmark( hydPosSys; ignoreBounds = true )
    @test ControlSystems.nstates( benchmarkProb.sys ) == 3
    @test ControlSystems.ninputs( benchmarkProb.sys ) == 1
end
