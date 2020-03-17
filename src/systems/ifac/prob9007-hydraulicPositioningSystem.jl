
export HydraulicPositioningSystem,
       hydraulicPositioningSystemParameterBounds

struct HydraulicPositioningSystem
    B::Float64      # Compressibility modulus
    m::Float64      # Mass
    R::Float64      # Friction coefficient
    Rc::Float64     # Coulomb friction coefficient
    KL::Float64     # Bypass oil coefficient
    σ::Float64      # Hydraulic constant
    V::Float64      # Volume
    A::Float64      # Piston area

    # The allowable region for the parameters
    bounds::BoundConstraint
end

function hydraulicPositioningSystemParameterBounds()
    # The upper and lower bounds the parameters should be inside
    #       B     m     R     Rc     KL        σ    V      A    FL
    lb = [ 9000, 0.05, 0.05,    0, 0.000103, 0.001,   0,  10.5,   0]
    ub = [16000,  0.3,    5, 0.05,   0.0035,    15, Inf, 11.10, 800]

    return FloatBoundConstraint( ub, lb )
end

function HydraulicPositioningSystem()
    HydraulicPositioningSystem(
        14000.0,   # Nominal compressibility modulus
        0.1287,    # Nominal mass
        0.150,     # Nominal friction coefficient
        0.01,      # Nominal Coulomb friction coefficient
        0.002,     # Nominal bypass oil coefficient
        0.24,      # Nominal hydraulic constant
        874.0,     # Nominal volume
        10.75,     # Nominal piston area
        hydraulicPositioningSystemParameterBounds() )
end

function generateControlBenchmark( p::HydraulicPositioningSystem )

# The state transition matrix
A = fill( 0.0, (3, 3) )
A[1, 2] = 1.0
A[2, 2] = -( p.R + 4.0 / π * p.Rc ) / p.m
A[3, 2] = -( 4.0 * p.B ) / p.V * p.A
A[2, 3] = p.A / p.m
A[3, 3] = -( 4.0 * p.B ) / p.V * ( p.σ + p.KL )

# The input matrix
B = fill( 0.0, (3, 1) )
B[3, 1] = -( 4.0 * p.B ) / p.V;

# The output matrix
C = fill( 0.0, (1, 3) )
C[1, 1] = 1.0

# The feed-forward matrix
D = fill( 0.0, (1, 1) )

# The disturbance matrix
# TODO: Extend ss to take this disturbance matrix
E = fill( 0.0, (3, 1) )
E[2, 1] = -1.0 / p.m


# Input constraints
#     Input   disturbance
ub = [ 866.0, 800.0]
lb = [-866.0,   0.0]

# Create the constrained system
return ConstrainedSystem( StateSpace( A, B, C, D, 0 ),
                          FloatBoundConstraint( 3 ),
                          FloatBoundConstraint( ub, lb, "u" ) )

end
