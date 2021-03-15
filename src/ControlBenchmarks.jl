module ControlBenchmarks

################################################################################
# Main exports from this package
#
# The individual benchmarks are exported at the top of their respective files.
################################################################################
export controlbenchmark,
       parameterbounds,
       listbenchmarks,
       getbenchmark


################################################################################
# Packages we need
################################################################################
using ControlSystems
using ControlSystems: AbstractSystem, nstates, ninputs
using LazySets
using LinearAlgebra
using Printf
using PrettyTables
using Polyhedra
using SparseArrays


# Bounds for a variable/variables
"""
    Bound = LazySets.Interval

Alias to allow easy use of a `LazySets.Interval` to represent the upper and lower bound for a single
variable.
"""
const Bound = LazySets.Interval

"""
    Bounds = Vector{Bound}

Alias to allows easy use of a collection of single-variable upper and lower bounds.
"""
const Bounds = Vector{Bound}

"""
    ControlBenchmarkProblem

The abstract type that all benchmark problems must derive from.
"""
abstract type ControlBenchmarkProblem end

include( "internals.jl" )
include( "interface.jl" )


################################################################################
# The benchmark systems
################################################################################

# The IFAC benchmark systems
include( "benchmarks/ifac/prob9001-binaryDistilationColumn.jl" )
include( "benchmarks/ifac/prob9002-drumBoiler.jl" )
include( "benchmarks/ifac/prob9006-airplaneFlutter.jl" )
include( "benchmarks/ifac/prob9007-hydraulicPositioningSystem.jl" )

# Mass-Spring systems
include( "benchmarks/massSpringSystems/linearMassSpringDamper.jl" )

# Miscellaneous benchmark systems
include( "benchmarks/ballOnPlate.jl" )
include( "benchmarks/jonesMorari.jl" )


end # module
