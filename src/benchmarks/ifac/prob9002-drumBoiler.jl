export DrumBoiler

"""
    DrumBoiler

Type representing the IFAC drum boiler benchmark problem.

From E. J. Davison, ‘Benchmark Problems for Control System Design: Report of the IFAC Theory Committee’, IFAC, 1990.
"""
struct DrumBoiler <: ControlBenchmarkProblem end

@addbenchmark DrumBoiler "ifac02" "Drum boiler" "A drum boiler where water is converted to steam" Set([:linear, :unstable, :continuous, :process, :nonminimum_phase, :ifac])


"""
    controlbenchmark(::DrumBoiler) -> sys

Create the system for the IFAC drum boiler sample problem.

`sys` is the linear statespace system describing the drum boiler.
"""
function controlbenchmark( ::DrumBoiler )

    A = [ -3.93     -3.15e-3     0.00        0.00        0.00        4.03e-5     0.00        0.00        0.00;
           3.68e2   -3.05        3.03        0.00        0.00       -3.77e-3     0.00        0.00        0.00;
           2.74e1    7.87e-2    -5.96e-2     0.00        0.00       -2.81e-4     0.00        0.00        0.00;
          -6.47e-2  -5.2e-5      0.00       -2.55e-1    -3.35e-6     3.60e-7     6.33e-5     1.94e-4     0.00;
           3.85e3    1.73e1     -1.28e1     -1.26e4     -2.91       -1.05e-1     1.27e1      4.31e1      0.00;
           2.24e4    1.80e1      0.00       -3.56e1     -1.04e-4    -4.14e-1     9.00e1      5.69e1      0.00;
           0.00      0.00        2.34e-3     0.00        0.00        2.22e-4    -2.03e-1     0.00        0.00;
           0.00      0.00        0.00       -1.27        1.00e-3     7.86e-5     0.00       -7.17e-2     0.00;
          -2.20     -1.77e-3     0.00       -8.44       -1.11e-4     1.38e-5     1.49e-3     6.02e-3    -1.00e-10 ]

    B = [ 0.00   0.00       0.00;
          0.00   0.00       0.00;
          1.56   0.00       0.00;
          0.00  -5.13e-6    0.00;
          8.28  -1.50       3.95e-2;
          0.00   1.78       0.00;
          2.33   0.00       0.00;
          0.00  -2.45e-2    2.84e-3;
          0.00   2.94e-5    0.00 ]

    C = zeros( Float64, 2, 9 )
    C[1, 6] = 1
    C[2, 9] = 1

    D = zeros( Float64, 2, 3 )

    E = [ -1.00e-2;
           0.00;
           0.00;
           0.00;
           5.20e1;
           0.00;
           0.00;
           0.00;
           0.00 ]

    return StateSpace( A, B, C, D, Continuous() )
end
