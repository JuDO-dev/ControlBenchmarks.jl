export BinaryDistillationColumn

"""
    BinaryDistillationColumn

Type representing the IFAC Binary Distillation Column benchmark problem.

From E. J. Davison, ‘Benchmark Problems for Control System Design: Report of the IFAC Theory Committee’, IFAC, 1990.
"""
struct BinaryDistillationColumn <: ControlBenchmarkProblem end

@addbenchmark BinaryDistillationColumn "ifac01" "Binary distillation column" "A distillation column to separate two compounds" Set([:linear, :stable, :continuous, :process, :ifac])


"""
    controlbenchmark(::BinaryDistillationColumn) -> (sys, input, disturbance)

Generate the components of the binary distillation column benchmark problem.

`sys` is the linear statespace system describing the distillation column.

`input` is the set of `Bounds` representing the constraints on the input actuators.

`disturbance` is the bound representing the constraint on the disturbance input (the input feed).
"""
function controlbenchmark( ::BinaryDistillationColumn )
    # The state transition matrix
    #           R   C    Value
    Aparts = [  1   1  -1.4e-2;
                1   2   4.3e-3;
                2   1   9.5e-3;
                2   2  -1.38e-2;
                2   3   4.6e-3;
                2  11   5.0e-4;
                3   2   9.5e-3;
                3   3  -1.41e-2;
                3   4   6.3e-3;
                3  11   2.0e-4;
                4   3   9.5e-3;
                4   4  -1.58e-2;
                4   5   1.1e-2;
                5   4   9.5e-3;
                5   5  -3.12e-2;
                5   6   1.5e-2;
                6   5   2.02e-4;
                6   6  -3.52e-2;
                6   7   2.2e-2;
                7   6   2.02e-2;
                7   7  -4.22e-2
                7   8   2.8e-2;
                8   7   2.02e-2;
                8   8  -4.82e-2;
                8   9   3.7e-2;
                8  11   2.0e-4;
                9   8   2.02e-2;
                9   9  -5.7e-2;
                9  10   4.2e-2;
                9  11   5.0e-4;
               10   9   2.02e-2;
               10  10  -4.83e-2;
               10  11   5.0e-4;
               11   1   2.55e-2;
               11  10   2.55e-2;
               11  11  -1.85e-2 ]

    A = sparse( Aparts[:, 1], Aparts[:, 2], Aparts[:, 3], 11, 11 )

    # The input matrix
    Bdense = [  0.0      0.0     0.0;
                5.0e-6  -4.0e-5  2.5e-3;
                2.0e-6  -2.0e-5  5.0e-3;
                1.0e-6  -1.0e-5  5.0e-3;
                0.0      0.0     5.0e-3;
                0.0      0.0     5.0e-3;
               -5.0e-6   1.0e-5  5.0e-3;
               -1.0e-5   3.0e-5  5.0e-3;
               -4.0e-5   5.0e-6  2.5e-3;
               -2.0e-5   2.0e-6  2.5e-3;
                4.6e-4   4.6e-4  0.0 ]

    B = sparse( Bdense )

    # The output matrix
    C = spzeros( 3, 11 )
    C[1, 10] = 1.0
    C[2,  1] = 1.0
    C[3, 11] = 1.0

    # The feed-forward matrix
    D = spzeros( 3, 3 )

    # The disturbance matrix
    # TODO: Extend ss to take this disturbance matrix
    E = spzeros( 11, 1 )
    E[5, 1] = 1.0e-2


    # Input constraints
    inputBound = Bounds( [ Bound( -2.5,  2.5 );
                           Bound( -2.5,  2.5 );
                           Bound( -0.30, 0.30) ] )

    # Disturbance bound for FL
    disturbanceBound = Bound( -1.0, 1.0 )

    # Create the constrained system
    # Use the explicit constructor so that the sparse type of the matrices is preserved
    # https://github.com/JuliaControl/ControlSystems.jl/issues/311
    return StateSpace{Float64, SparseMatrixCSC{Float64}}( A, B, C, D, 0.0 ), inputBound, disturbanceBound
end
