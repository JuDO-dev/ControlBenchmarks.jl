
export JonesMorari

struct JonesMorari end

function generateControlBenchmark( b::JonesMorari )

    # System matrices
    A = [ [0.7 -0.1  0.0  0.0];
          [0.2 -0.5  0.1  0.0];
          [0.0  0.1  0.1  0.0];
          [0.5  0.0  0.5  0.5] ]

    B = [ [0.0  0.1];
          [0.1  1.0];
          [0.1  0.0];
          [0.0  0.0] ]

    C = Matrix{Float64}( I, 4, 4 )

    D = fill( 0.0, (4, 2) )

    # Bounds
    ub = fill(  5.0, 4 )
    lb = fill( -5.0, 4 )

    return ConstrainedSystem( StateSpace( A, B, C, D, 0.01 ),
                              FloatBoundConstraint( ub, lb, "x" ),
                              FloatBoundConstraint( ub, lb, "u" ) )
end
