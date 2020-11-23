"""
    listbenchmarks( keyword::Symbol = :all, returnlist = false )

Print a list of all registered control benchmarks that have `keyword` in their keyword list, or
simply all registered benchmarks if `:all` is specified.
The set of `ControlBenchmarkInfo` objects containing all the information printed is optionally
returned if `returnlist` is `true`.

# Example
```
julia> listbenchmarks( :ifac )
Benchmarks with keyword ":ifac":
┌────────┬──────────────────────────────┬─────────────────────────────────────────────────┬──────────────┬─────────────────────────────────────────────────────────────────────────────────────┐
│ ID     │ Name                         │ Description                                     │ Configurable │ Keywords                                                                            │
├────────┼──────────────────────────────┼─────────────────────────────────────────────────┼──────────────┼─────────────────────────────────────────────────────────────────────────────────────┤
│ ifac01 │ Binary distillation column   │ A distillation column to separate two compounds │ No           │ [:continuous, :ifac, :linear, :process, :stable]                                    │
│ ifac02 │ Drum boiler                  │ A drum boiler where water is converted to steam │ No           │ [:continuous, :ifac, :linear, :nonminimum_phase, :process, :unstable]               │
│ ifac06 │ Boeing 767                   │ Boeing 767 at flutter condition                 │ No           │ [:aerospace, :continuous, :ifac, :linear, :nonminimum_phase, :nonnormal, :unstable] │
│ ifac07 │ Hydraulic positioning system │ Hydraulically controlled carriage on a track    │ Yes          │ [:continuous, :ifac, :linear, :mechanical, :stable]                                 │
└────────┴──────────────────────────────┴─────────────────────────────────────────────────┴──────────────┴─────────────────────────────────────────────────────────────────────────────────────┘

```
"""
function listbenchmarks( keyword::Symbol = :all, returnlist = false )
    foundbenchmarks = Set{ControlBenchmarkInfo}()

    header = ["ID" "Name" "Description" "Configurable" "Keywords"]
    list   = Array{Any, 2}(undef, 0, 5)

    for (T, b) in benchmarkinfo
        if keyword in b.keywords || keyword == :all
            push!( foundbenchmarks, b )
            config = b.configurable ? "Yes" : "No"
            keyw   = sort(collect(b.keywords))
            list = vcat( list, ["$(b.id)" "$(b.name)" "$(b.desc)" "$(config)" "$(keyw)"] )
        end
    end

    if isempty( foundbenchmarks )
        println( "No benchmarks found with keyword \":$keyword\"")
    else
        list = sortslices( list; dims=1 )

        if keyword == :all
            println( "All registered benchmarks:" )
        else
            println( "Benchmarks with keyword \":$keyword\":" )
        end

        pretty_table( list, header; alignment=:l )
    end

    if returnlist
        return foundbenchmarks
    else
        return nothing
    end
end


"""
    getbenchmark( id::string )

Get an instance of the problem type given by `id`. This type can then be modified (if the problem
is configurable), and used to create the benchmark problem data by calling [`controlbenchmark`](@ref).

# Example
```jldoctest
julia> prob = getbenchmark( "lin01" )
BallOnPlate()
```
"""
function getbenchmark( id::String )
    if( !haskey( benchmarkmap, id ) )
        error( "$id is not a registered benchmark problem" )
    end

    benchmarkmap[id]()
end


"""
    controlbenchmark( id::String )

Gets the default benchmark problem data for the problem given by `id`.

# Example
```jldoctest
julia> (sys, statebounds, inputbounds) = controlbenchmark( "lin01" )
(ControlSystems.StateSpace{Float64,Array{Float64,2}}
A =
 1.0  0.01
 0.0  1.0
B =
 -0.0004
 -0.0701
C =
 1.0  0.0
 0.0  1.0
D =
 0.0
 0.0

Sample Time: 0.01 (seconds)
Discrete-time state-space model, LazySets.Interval[LazySets.Interval{Float64,IntervalArithmetic.Interval{Float64}}([-0.200001, 0.0100001]), LazySets.Interval{Float64,IntervalArithmetic.Interval{Float64}}([-0.100001, 0.100001])], LazySets.Interval[LazySets.Interval{Float64,IntervalArithmetic.Interval{Float64}}([-0.0524001, 0.0524001])])
```
"""
function controlbenchmark( id::String )
    b = getbenchmark( id )
    controlbenchmark( b )
end
