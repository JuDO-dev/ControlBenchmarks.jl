export MassSpringChain

mutable struct MassSpringChain <: ControlBenchmarkProblem
    n::Integer          # The number of masses in the chain
    k::Vector{Float64}  # The spring constants in the chain
    m::Vector{Float64}  # The masses in the chain
    inputs::Vector{Int} # The masses which have an acceleration input

    function MassSpringChain( n::Integer, k::T, m::T; inputs::Vector{Int} = [1; n] ) where {T <: Union{Vector{Float64}, Float64}}
        if( n < 1 )
            throw( DomainError( n, "Must specify more than one mass" ) )
        end

        if isa( k, Number )
            k = fill( k, n+1 )
        end

        if isa( m, Number )
            m = fill( m, n )
        end

        if size( k, 1 ) != n+1
            error( "k must have n+1 values" )
        end

        if size( m, 1 ) != n
            error( "m must have n values" )
        end

        if size( inputs, 1 ) > n || !all( inputs .<= n )
            throw( DomainError( inputs, "Inputs must be on masses" ) )
        end

        return new(n, k, m, inputs)
    end
end

function controlbenchmark( chain::MassSpringChain )
    n = chain.n
    k = chain.k
    m = chain.m
    inputs = chain.inputs

    # Create the state matrix
    D = diagm(  0 => k[1:end-1] + k[2:end],      # The main diagonal matrix elements
               -1 => k[1:end-2] ./ m[1:end-1],   # The elements below the diagonal
                1 => k[3:end]   ./ m[2:end] )    # The elements above the diagonal

    A = [ zeros( Float64, (n,n) ) D;
          1.0*I(n) zeros(Float64, (n,n) ) ]

    # Create the input matrix
    dim = size( inputs, 1 )
    ind = CartesianIndex.( inputs, 1:dim )
    B   = zeros( Float64, (2*n, dim) )
    B[ind] .= 1 ./ m[inputs]

    C = Matrix{Float64}( I, 2*n, 2*n )

    return StateSpace( A, B, C, 0 )
end
