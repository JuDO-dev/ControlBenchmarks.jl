export LinearMassSpringChain
export LinearMassSpringDamperChain

mutable struct LinearMassSpringDamperChain <: ControlBenchmarkProblem
    n::Integer          # The number of masses in the chain
    k::Vector{Float64}  # The spring constants in the chain
    β::Vector{Float64}  # The damping constants in the chain
    m::Vector{Float64}  # The masses in the chain
    inputs::Vector{Int} # The masses which have an acceleration input

    function LinearMassSpringDamperChain( n::Integer, k, β, m; inputs = [1; n] )
        if( n < 1 )
            throw( DomainError( n, "Must specify more than one mass" ) )
        end

        if isa( k, Number )
            k = fill( k, n+1 )
        end

        if isa( β, Number )
            β = fill( β, n+1 )
        end

        if isa( m, Number )
            m = fill( m, n )
        end

        # Create vectors
        k = reshape( k, : )
        β = reshape( β, : )
        m = reshape( m, : )

        if size( k, 1 ) != n+1
            error( "k must have n+1 values" )
        end

        if size( β, 1 ) != n+1
            error( "β must have n+1 values" )
        end

        if size( m, 1 ) != n
            error( "m must have n values" )
        end

        # Ensure no inputs are duplicated
        inputs = reshape( inputs, : )
        unique!( inputs )

        if size( inputs, 1 ) > n
            error( inputs, "More inputs requested than masses" )
        end

        if !all( inputs .<= n )
            throw( DomainError( inputs, "Inputs must be on masses" ) )
        end

        return new(n, k, β, m, inputs)
    end
end


LinearMassSpringChain( n::Integer, k, m; inputs = [1; n] ) = LinearMassSpringDamperChain( n, k, 0, m; inputs )


function controlbenchmark( chain::LinearMassSpringDamperChain )
    # Extract into temp variables for more easy reference
    n = chain.n
    k = chain.k
    β = chain.β
    m = chain.m
    inputs = chain.inputs

    # Create the diagonal elements for the matrix part for the springs
    springUpperDiag = k[2:end-1] ./ m[1:end-1]
    springMainDiag  = -( k[1:end-1] + k[2:end] ) ./ m[1:end]
    springLowerDiag = k[2:end-1] ./ m[2:end]

    # Create the state matrix
    S = spdiagm(  0 => springMainDiag,    # The main diagonal matrix elements
                 -1 => springLowerDiag,   # The elements below the diagonal
                  1 => springUpperDiag )  # The elements above the diagonal

    # Create the diagonal elements for the matrix part for the damper
    damperUpperDiag = β[2:end-1] ./ m[1:end-1]
    damperMainDiag  = -( β[1:end-1] + β[2:end] ) ./ m[1:end]
    damperLowerDiag = β[2:end-1] ./ m[2:end]

    Beta = spdiagm(  0 => damperMainDiag,    # The main diagonal matrix elements
                    -1 => damperLowerDiag,   # The elements below the diagonal
                     1 => damperUpperDiag )  # The elements above the diagonal


    Z   = spzeros( n, n )
    Eye = sparse( 1.0*I, n, n )

    A = [ Z Eye
          S Beta ]

    # Create the input matrix
    dim = size( inputs, 1 )
    ind = CartesianIndex.( inputs .+ n, 1:dim )
    B   = spzeros( 2*n, dim )
    B[ind] .= - 1 ./ m[inputs]

    C = sparse( 1.0*I, 2*n, 2*n )
    D = spzeros( 2*n, dim )

    return HeteroStateSpace( A, B, C, D, Continuous() )
end
