using ControlBenchmarks
using ControlSystems

# Test the default constructor
let sys = controlbenchmark( HydraulicPositioningSystem() )
    @test ControlSystems.nstates( sys ) == 3
    @test ControlSystems.ninputs( sys ) == 1
end


# Test setting a non-default value for a parameter
let hydPosSys = HydraulicPositioningSystem()
    hydPosSys.B = 10000

    sys = controlbenchmark( hydPosSys )
    @test ControlSystems.nstates( sys ) == 3
    @test ControlSystems.ninputs( sys ) == 1
end


# Test setting a non-default value for a parameter that is out of bounds
let hydPosSys = HydraulicPositioningSystem()
    hydPosSys.B = 8000

    # Test without ignoring the bounds
    @test_throws DomainError controlbenchmark( hydPosSys; ignoreBounds = false )

    # Test while ignoring the bounds
    sys = controlbenchmark( hydPosSys; ignoreBounds = true )
    @test ControlSystems.nstates( sys ) == 3
    @test ControlSystems.ninputs( sys ) == 1
end
