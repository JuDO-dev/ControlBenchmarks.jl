"""
    ControlBenchmarkInfo

A struct to hold various information about a control benchmark problem, such as its name,
id, description and a set of keywords for locating benchmarks problems.
"""
struct ControlBenchmarkInfo
    name::String             # The name of the benchmark
    id::String               # A concise alpha-numeric ID for the benchmark
    desc::String             # A short description of the benchmark
    keywords::Set{Symbol}    # A set of keywords for the benchmark
    configurable::Bool       # True if the problem type contains configurable parameters
end

"""
    benchmarkmap

A dictionary mapping the benchmark ID to the type implementing the benchmark. Benchmarks are added
to this dictionary using the [`@addbenchmark`](@ref) macro.
"""
benchmarkmap = Dict{String,DataType}()

"""
    benchmarkinfo

A dictionary mapping the benchmark type to the struct containing its information. Benchmarks are added
to this dictionary using the [`@addbenchmark`](@ref) macro.
"""
benchmarkinfo = Dict{DataType, ControlBenchmarkInfo}()

"""
    @addbenchmark( T, id::String, name::String, desc::String, keywords )

Add a benchmark to the main benchmarks list.

`T` is the type for the benchmark. `id` is an alpha-numeric string used for identifying the benchmark
and easily locating it using either [`controlbenchmark`](@ref) or [`getbenchmark`](@ref).
`name` and `description` are short strings naming and describing the problem.
`keywords` is a set containing symbols that describe the system and are used by the
[`listbenchmarks`](@ref) function.

# Example
```
struct TestSystem <: ControlBenchmarkProblem end

@addbenchmark TestSystem "test01" "Sample system" "A sample system" Set([:sample, :linear])
```
"""
macro addbenchmark( T, id::String, name::String, desc::String, keywords )
    quote
        benchmarkmap[$(esc(id))] = $(esc(T))
        obj = $(T)()
        benchmarkinfo[$(esc(T))] = ControlBenchmarkInfo( $(esc(name)), $(esc(id)), $(esc(desc)), $(esc(keywords)), !isimmutable(obj) )
    end
end

"""
    @checkbounds( T, params )

Performs a bounds check on all the elements of the struct `params`, which is of type `T`. The bounds
are given inside a dictionary returned by the function `parameterbounds(::T)`, where the dictionary keys
must be the fieldnames. Every field must be included in the dictionary for this macro to be used. The comparison
is done using the `∈` operator, so the dictionary must return a type which implements that operator (such as [`Bound`](@ref))
"""
macro checkbounds( T, params )
    block = Expr(:block)
    push!(block.args, :(b = parameterbounds( $(esc(params)) ) ) )

    for f in eval( :(fieldnames( $(T) ) ) )
        str = String(f)
        push!(block.args, :($(esc(params)).$(f) ∈ b[$(str)]  || throw( DomainError( $(esc(params)).$(f), "$($(str)) is outside the allowed domain" ) ) ) )
    end

    return block
end
