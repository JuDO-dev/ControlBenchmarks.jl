
export BallOnPlate

"""
    BallOnPlate

The ball on a plate system example with a single actuator.

"""
struct BallOnPlate end


function generateControlBenchmark( b::BallOnPlate )

# System matrices
A = [ [1.0 0.01];
      [0.0 1.0] ]

B = [-0.0004
     -0.0701]

C = Matrix{Float64}( I, 2, 2 )

D = fill( 0.0, (2, 1) )

# State constraints
sub = [0.01;  0.1]
slb = [-0.2; -0.1]

# Input constraints
iub = [ 0.0524]
ilb = [-0.0524]

return ConstrainedSystem( StateSpace( A, B, C, D, 0.01 ),
                          FloatBoundConstraint( sub, slb, "x" ),
                          FloatBoundConstraint( iub, ilb, "u" ) )

end
