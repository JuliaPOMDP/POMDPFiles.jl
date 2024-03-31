push!(LOAD_PATH, "../src/")

using Documenter, POMDPs, POMDPFiles

makedocs(
    modules=[POMDPFiles],
    sitename="POMDPFiles.jl",
    format=Documenter.LaTeX(),
    # repo= https://github.com/licioromao/POMDPFiles.jl,
    pages= Any[
        "Home" => "index.md",
    ],
)