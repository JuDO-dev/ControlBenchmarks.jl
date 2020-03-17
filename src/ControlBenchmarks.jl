module ControlBenchmarks

################################################################################
# Main exports from this package
#
# The individual benchmarks are exported at the top of their respective files.
################################################################################
export ConstrainedSystem,
       FloatBoundConstraint,
       IntegerBoundConstraint,
       AffineConstraint,
       generateControlBenchmark


################################################################################
# Packages we need
################################################################################
using ControlSystems
using ControlSystems: AbstractSystem, nstates, ninputs
using Printf
using LinearAlgebra


################################################################################
# General utilities in this package
################################################################################
include( "types/constraints.jl" )
include( "types/system.jl" )


################################################################################
# The benchmark systems
################################################################################

# The IFAC benchmark systems
include( "systems/ifac/prob9007-hydraulicPositioningSystem.jl" )

# Miscellaneous benchmark systems
include( "systems/ballOnPlate.jl" )
include( "systems/jonesMorari.jl")


end # module
