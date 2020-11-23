using Documenter, ControlBenchmarks

DocMeta.setdocmeta!(ControlBenchmarks, :DocTestSetup, :(using ControlBenchmarks); recursive=true)

makedocs(;
    modules=[ControlBenchmarks],
    format=Documenter.HTML(prettyurls = false),
    repo="https://github.com/imciner2/ControlBenchmarks.jl/blob/{commit}{path}#L{line}",
    sitename="ControlBenchmarks.jl",
    authors="Ian McInerney, Imperial College London",
    pages = Any[
        "Home" => "index.md",
        "Usage" => "usage.md",
        "Problems" => [
            "ifac.md",
        ],
        "Extending" => "extending.md",
        "Internals" => "internals.md"
    ],
    assets=String[],
)

#deploydocs(;
#    repo="github.com/imciner2/ControlBenchmarks.jl",
#)
