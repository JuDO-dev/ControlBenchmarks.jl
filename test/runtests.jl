using ControlBenchmarks
using Test
using SafeTestsets

@testset "ControlBenchmarks.jl" begin

@testset "Benchmarks" begin
    # Run tests for all the benchmarks
    include( "benchmarks/runtests.jl" )
end

end
