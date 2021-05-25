
export BallOnPlate

"""
    BallOnPlate

The single-axis ball on a plate system example with a single actuator.

This system is a 2-state 1-input discrete-time system with bounds on both
the states and the inputs.

This example is from Section 9.6 of [1].

[1] S. Richter, ‘Computational complexity certification of gradient methods for real-time model predictive control’, Doctoral Thesis, ETH Zurich, 2012.
"""
struct BallOnPlate <: ControlBenchmarkProblem end

@addbenchmark BallOnPlate "lin01" "Ball on Plate (Single Axis)" "Single axis ball on plate" Set([:linear, :stable, :discrete])

function controlbenchmark( ::BallOnPlate )

    # System matrices
    A = [ 1.0 0.01;
          0.0 1.0 ]

    B = [-0.0004
         -0.0701]

    C = Matrix{Float64}( I, 2, 2 )

    D = fill( 0.0, (2, 1) )

    # State constraints
    stateBounds = Bounds( [ Bound( -0.2, 0.01 );
                            Bound( -0.1, 0.1 ) ] )

    # Input constraints
    inputBounds = Bounds( [ Bound( -0.0524, 0.0524 ) ] )

    return (; :sys => StateSpace( A, B, C, D, 0.01 ),
              :stateBounds => stateBounds,
              :inputBounds => inputBounds )

end
