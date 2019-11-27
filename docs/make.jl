using Documenter, ControlBenchmarks

makedocs(;
    modules=[ControlBenchmarks],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/imciner2/ControlBenchmarks.jl/blob/{commit}{path}#L{line}",
    sitename="ControlBenchmarks.jl",
    authors="Ian McInerney, Imperial College London",
    assets=String[],
)

deploydocs(;
    repo="github.com/imciner2/ControlBenchmarks.jl",
)
