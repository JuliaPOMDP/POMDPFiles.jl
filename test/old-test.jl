using POMDPFiles
using POMDPModels
using POMDPTools
using Test
using Downloads

# Tests drawn from https://pomdp.org/examples/
const TEST_SOURCES = joinpath(dirname(@__FILE__), "sources")
const TEST_DATA = joinpath(dirname(@__FILE__), "data")

println("Running tests:")

println("Running `reader` tests:")
include("reader.jl")

println("Running `writer` tests:")
include("writer.jl")