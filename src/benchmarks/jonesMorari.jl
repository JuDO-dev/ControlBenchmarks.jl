export JonesMorari


"""
    JonesMorari

A simple 4-state 2-input discrete time system.

This system has simple upper and lower bounds on the states and inputs.
It was originally proposed in Section 6 of [1].

[1] C. N. Jones and M. Morari, ‘The Double Description Method for the Approximation of Explicit MPC Control Laws’, in 47th IEEE Conference on Decision and Control (CDC), Cancun, Mexico, 2008, pp. 4724–4730, doi: 10.1109/CDC.2008.4738794.
"""
struct JonesMorari <: ControlBenchmarkProblem end

@addbenchmark JonesMorari "lin02" "Schur-stable system (Jones-Morari)" "Simple 4-state 2-input schur-stable system" Set([:linear, :stable, :discrete])

"""
    controlbenchmark( ::JonesMorari ) -> ( sys, stateBounds, inputBounds )

Create the components of the [`JonesMorari`](@ref) benchmark problem.

* `sys` is the StateSpace system.
* `stateBounds` are the limits on the state variables.
* `inputBounds` are the limits on the input variables.
"""
function controlbenchmark( ::JonesMorari )

    # System matrices
    A = [ 0.7 -0.1  0.0  0.0;
          0.2 -0.5  0.1  0.0;
          0.0  0.1  0.1  0.0;
          0.5  0.0  0.5  0.5 ]

    B = [ 0.0  0.1;
          0.1  1.0;
          0.1  0.0;
          0.0  0.0 ]

    C = Matrix{Float64}( I, 4, 4 )

    D = fill( 0.0, (4, 2) )

    # Bounds
    stateBounds = Bounds( [ Bound( -5.0, 5.0 );
                            Bound( -5.0, 5.0 );
                            Bound( -5.0, 5.0 );
                            Bound( -5.0, 5.0 ) ] )

    inputBounds = Bounds( [ Bound( -5.0, 5.0 );
                            Bound( -5.0, 5.0 ) ] )

    return (; :sys => StateSpace( A, B, C, D, 0.01 ),
              :stateBounds => stateBounds,
              :inputBounds => inputBounds )
end
