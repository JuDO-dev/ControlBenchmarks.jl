
abstract type ControlConstraint end
abstract type BoundConstraint end


# Helper function to verify that the requested bounds are valid
function verifyBounds( ub::T, lb::T ) where { T <: AbstractVector{<:Number} }
    if( length( ub ) != length( lb ) )
        throw( DimensionMismatch( "Upper and lower bounds must be the same length" ) )
    end

    for i in 1:length( lb )
        if( lb[i] > ub[i] )
            throw( DomainError( "Upper bound must be greater than lower bound" ) )
        end
    end

    return true
end


"""
    FloatBoundConstraint

A set of floating point upper and lower bounds for variables.
"""
struct FloatBoundConstraint <: BoundConstraint
    ub::AbstractVector{<:AbstractFloat}
    lb::AbstractVector{<:AbstractFloat}
    var::AbstractString

    function FloatBoundConstraint( ub::T, lb::T, var::AbstractString ) where { T <: AbstractVector{<:AbstractFloat} }
        if( verifyBounds( ub, lb ) )
            new( ub, lb, var )
        end
    end
end


"""
    IntegerBoundConstraint

A set of integer upper and lower bounds for variables.
"""
struct IntegerBoundConstraint <: BoundConstraint
    ub::AbstractVector{<:Integer}
    lb::AbstractVector{<:Integer}
    var::AbstractString

    function IntegerBoundConstraint( ub::T, lb::T, var::AbstractString ) where { T <: AbstractVector{<:Integer} }
        if( verifyBounds( ub, lb ) )
            new( ub, lb, var )
        end
    end
end


"""
    FloatBoundConstraint( n::Int )

Create a bound constraint using floating point for n variables where the upper
bound is Inf and the lower bound is -Inf.
"""
function FloatBoundConstraint( n::I ) where {I <: Int}
    if( n <= 0 )
        throw( DomainError( n, "Number of variables must be positive" ) )
    end

    FloatBoundConstraint( fill( Inf, n ), fill( -Inf, n ), "x" )
end


Base.print( io::IO, con::BoundConstraint ) = show( io, con )

# Printing function for the integer bound constraints
function Base.show( io::IO, con::IntegerBoundConstraint )
    numElems = length( con.lb )
    fillStr  = " "^length( con.var )

    for i in 1:numElems
        lowVal = con.lb[i]
        highVal = con.ub[i]

        if( i == ceil( numElems / 2 ) )
            @printf( io, " %d ≤ %s ≤ %d\n", lowVal, con.var, highVal )
        else
            @printf( io, " %d   %s   %d\n", lowVal, fillStr, highVal )
        end
    end
end

# Printing function for the floating point bound constraints
function Base.show( io::IO, con::FloatBoundConstraint )
    numElems = length( con.lb )
    fillStr  = " "^length( con.var )

    for i in 1:numElems
        lowVal = con.lb[i]
        highVal = con.ub[i]

        if( i == ceil( numElems / 2 ) )
            @printf( io, " %f ≤ %s ≤ %f\n", lowVal, con.var, highVal )
        else
            @printf( io, " %f   %s   %f\n", lowVal, fillStr, highVal )
        end
    end
end



"""
    AffineConstraint{T <: Number}

An affine constraint of the form Ax≤b with type T.
"""
struct AffineConstraint{T <: Number} <: ControlConstraint
    A::AbstractMatrix{T}
    b::AbstractVector{T}

    function AffineConstraint{T}( A, b ) where {T}
        if( length(b) != size( A, 1) )
            throw( DimensionMismatch( "A and b must have the same number of rows" ) )
        end

        new{T}( A, b )
    end
end
