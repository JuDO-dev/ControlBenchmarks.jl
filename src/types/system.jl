
"""
    ConstrainedSystem{T <: ControlConstraint}

Define a dynamical system with constraints on the states and inputs.
"""
struct ConstrainedSystem
    system::AbstractSystem
    stateBounds::BoundConstraint
    inputBounds::BoundConstraint
    constraints::Array{ControlConstraint, 1}
end

# Allow constructing with only bound constraints
function ConstrainedSystem( system::AbstractSystem, stateBounds::BoundConstraint, inputBounds::BoundConstraint )
    ConstrainedSystem( system, stateBounds, inputBounds, ControlConstraint[] )
end

# Allow construction with no constraints, and just default to all constraints
# infinite and bounds of a Float type
function ConstrainedSystem( sys::AbstractSystem )
    ConstrainedSystem( sys,
                       FloatBoundConstraint( nstates( sys ) ),
                       FloatBoundConstraint( ninputs( sys ) ) )
end

################################################################################
# Type modification methods
################################################################################

# Allow conversion of an unconstrained system into a constrained system
# where all the constraints are infinite
Base.convert( ::Type{ConstrainedSystem}, sys::AbstractSystem ) = ConstrainedSystem( sys )


################################################################################
# Printing methods
################################################################################
Base.print( io::IO, sys::ConstrainedSystem ) = show( io, sys )

function Base.show( io::IO, sys::ConstrainedSystem )
    # Print out the system
    print( io, sys.system )

    println( io, "\n\n" )
    println( io, "State bounds:")
    print( io, sys.stateBounds )

    println( io, "\n" )
    println( io, "Input bounds:")
    print( io, sys.inputBounds )
end
