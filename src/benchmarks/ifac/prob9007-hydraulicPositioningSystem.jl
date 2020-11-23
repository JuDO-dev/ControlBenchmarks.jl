export HydraulicPositioningSystem

"""
Control of a carriage along a track using a hydraulic positioning system.

The plant model for this problem is defined by the following parameters:
* `B` - Compressibility modulus
* `m` - Mass
* `R` - Friction coefficient
* `Rc` - Coulomb friction coefficient
* `KL` - Bypass oil coefficient
* `σ` - Hydraulic constant
* `V` - Volume
* `A` - Piston area

From E. J. Davison, ‘Benchmark Problems for Control System Design: Report of the IFAC Theory Committee’, IFAC, 1990.
"""
mutable struct HydraulicPositioningSystem <: ControlBenchmarkProblem
    B::Float64      # Compressibility modulus
    m::Float64      # Mass
    R::Float64      # Friction coefficient
    Rc::Float64     # Coulomb friction coefficient
    KL::Float64     # Bypass oil coefficient
    σ::Float64      # Hydraulic constant
    V::Float64      # Volume
    A::Float64      # Piston area
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
        10.75 )    # Nominal piston area
end

@addbenchmark HydraulicPositioningSystem "ifac07" "Hydraulic positioning system" "Hydraulically controlled carriage on a track" Set([:linear, :stable, :continuous, :mechanical, :ifac])


"""
    parameterbounds(::HydraulicPositioningSystem)
"""
function parameterbounds( ::HydraulicPositioningSystem )
    # The intervals the parameters should be inside
    return Dict( "B"  => Bound( 9000, 16000 ),
                 "m"  => Bound( 0.05, 0.3 ),
                 "R"  => Bound( 0.05, 5.0 ),
                 "Rc" => Bound( 0.0, 0.05 ),
                 "KL" => Bound( 0.000103, 0.0035 ),
                 "σ"  => Bound( 0.001, 15.0 ),
                 "V"  => Bound( 0.0, Inf ),
                 "A"  => Bound( 10.5, 11.10 ) )
end


"""
    controlbenchmark(p::HydraulicPositioningSystem; ignoreBounds::Bool = false)

```@example
hps = HydraulicPositioningSystem()

# Change the mass from its default
hps.m = 0.25

sys, inputs, disturbance = controlbenchmark( hps )
```
"""
function controlbenchmark( p::HydraulicPositioningSystem; ignoreBounds::Bool = false )

    if( !ignoreBounds )
        @checkbounds HydraulicPositioningSystem p
    end

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
    inputBound = Bound( -866.0, 866.0 )

    # Disturbance bound for FL
    disturbanceBound = Bound( 0.0, 800.0 )

    # Create the constrained system
    return StateSpace( A, B, C, D ), inputBound, disturbanceBound
end
