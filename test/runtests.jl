using ControlBenchmarks
using Test

@testset "ControlBenchmarks.jl" begin

    @testset "BoundConstraint" begin
        ub = [ 1.0,  1.0,  1.0]
        lb = [-1.0, -1.0, -1.0]

        @test_throws DomainError       BoundConstraint{Float64}( lb, ub )
        @test_throws DimensionMismatch BoundConstraint{Float64}( [1.0], ub )
        @test_throws DomainError       BoundConstraint( -1 )
    end

    @testset "AffineConstraint" begin
        b = fill( 1.0::Float64, 4)
        A = fill( 1.0::Float64, ( 4, 5 ) )

        @test_throws DimensionMismatch AffineConstraint{Float64}( A, [-1.0] )
    end

end
