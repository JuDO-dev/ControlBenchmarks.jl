# Adding a Benchmark

Adding a new benchmark is as simple as creating a new type to represent the benchmark and then implementing the `controlbenchmark` function for that type.

```@contents
Pages = ["extending.md"]
Depth = 3
```

## Guidelines for Benchmarks

* If a benchmark comes from the literature, then a proper citation must be provided in the docstring and online documentation.
* Configurable benchmarks (e.g. ones that allow changing parameters) must have a default set of parameters specified by an outer constructor that takes no arguments.
* The ID chosen for the problem should either be based on the problem's field/application or its source (if implementing problems from an existing benchmark set).
* Choose appropriate keywords to describe the problem.

## Implementing a Benchmark

### Creating the type

The first element of a benchmark problem is the type.
This type must derive directly from the [`ControlBenchmarks.ControlBenchmarkProblem`](@ref) abstract type, and it will contain all parameters needed to generate the benchmark problem.

If no parameters are needed (e.g. the problem is fully defined and not customizable), then the type should be immutable, but if parameters are provided then the type
must be mutable and an outer constructor must be provided that initializes the type with a default set of parameters.

!!! note
    It is recommended that minimal/no bounds checking be done in the constructor, and instead be done when the problem is created. That way any changes the
    user makes to the parameters after construction are checked.

Each new problem type must also use the [`ControlBenchmarks.@addbenchmark`](@ref) macro so that it is added to the global list of all benchmarks and is able to be located
via [`listbenchmarks`](@ref).
This macro
Keywords for the problem are provided as a set of symbols

!!! warning
    The [`ControlBenchmarks.@addbenchmark`](@ref) macro must be used **after** the default constructor for the problem is defined when creating a parametric problem.

Below is an example of a non-parametric problem definition.
```
struct FixedProblem <: ControlBenchmarkProblem end

@addbenchmark FixedProblem "prob01" "Non-parametric problem" "A problem with no user-defined parameters" Set([:linear, :discrete])
```

Here is an example of a parametric problem definition.
```
mutable struct ParametricProblem <: ControlBenchmarkProblem
    param1::Float64
    param2::Float64
end

function ParametricProblem()
    return ParametricProblem( 1.0, 2.0 )    # Default values for the problem.
end

@addbenchmark ParametricProblem "prob02" "Parametric problem" "A problem with 2 parameters changable by the user" Set([:linear, :discrete, :unstable])
```

### Creating the benchmark problem

The actual benchmark problem is created inside the `controlbenchmark` method defined for the benchmark type.
This function should take an instance of the problem type as its first argument (even for non-parametric problems), and can also have optional arguments.
Optional arguments can be used to change how the problem is created (e.g. enabling/disabling bounds checking, etc.), but shouldn't be used for passing
parameters (those should be inside the problem's type).

!!! note
    The only required argument must be the problem type, all other arguments must be optional arguments with a default value provided in the function definition.

In general the `controlbenchmark` function should return a tuple containing all the problem data, but the exact items and their placement inside the tuple
will vary between benchmark problems.
It is suggested though that the system description (e.g. the `StateSpace` model, ODEs, DAEs, etc.) be the first item contained inside the tuple, so that
it is easy to access it.

Below is a sample structure for the `controlbenchmark` function.

```
function controlbenchmark( ::ParametricProblem )

    # Create the system dynamics...

    # Create any other items (e.g. constraints)

    # Return everything in a tuple
    return dynamics, constraints
end
