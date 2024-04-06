# POMDPFiles
[![Build Status](https://github.com/licioromao/POMDPFiles.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/licioromao/POMDPFiles.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![codecov](https://codecov.io/gh/licioromao/POMDPFiles.jl/branch/main/graph/badge.svg?token=btTBnBTQyw)](https://codecov.io/gh/licioromao/POMDPFiles.jl)

<!-- [![Build Status](https://github.com/licioromao/POMDPFiles.jl/actions/workflows/CI.yml/bagde.svg)](https://github.com/licioromao/POMDPFiles.jl/actions/workflows/CI.yml/) -->

This package constitutes the interface between the [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) package and the file format .pomdp defined in [POMDP.org](https://www.pomdp.org/code/pomdp-file-spec.html).

## Installation 

Please use the following command to use this package
```julia
] add git@github.com:licioromao/POMDPFiles.jl.git
```
## API

```julia
WildcardArrayPOMDP(s::Int, a::Int, o::Int, initial_state::InitialStateParam, discount::Float64, T::WildcardArray{Float64, 3}, O::WildcardArray{Float64, 3}, R::WildcardArray{Float64, 4})

WildcardArrayPOMDP(filename::String)
```

Constructors for the `WilcardArrayPOMDP`. We allow the user to create this type either through a .POMDP file format or specifying manually the number of actions, initial distribution, and transitions using the type [WildcardArrays](git@github.com:sisl/WildcardArrays.jl.git). The API for the InitialStateParam is described below.

```julia
SWildcardArrayPOMDP(filename::String) 

statenames(m::SWildcardArrayPOMDP) 
actionnames(m::SWildcardArrayPOMDP) 
obsnames(m::SWildcardArrayPOMDP) 
```

To deal with pomdp specifications where states, actions, and observations are specified with strings, i.e., `ss = ["warm", "very-warm"], aa = ["north", "west", "east", "west"]`, one may use the SWildcardArrayPOMDP type. More details on the differences between these two types are presented below. Three methods, `statenames`, `actionnames`, and `obsnames`, are defined to retrieve the names associated with the corresponding field of an `SWildcardArrayPOMDP` type.  

> **Warning:** Functions `statenames`, `actionnames`, `obsnames` are not implemented for a `WildcardArrayPOMDP` type. 

```julia
mutable struct InitialStateParam
    number::Int
    type_of_distribution::String
    support_of_distribution::Set{Int}
    value_of_distribution::Vector{Float64}

end
InitialStateParam(number::Int) = InitialStateParam(number, " ", Set{Int}([]), Vector{Float64}([])) 
InitialStateParam() = InitialStateParam(0)
```

This is interface used to define the initial distribution of `WildcardArrayPOMDP`. It contains information about the number of states, support of the distribution, and a probability vector representation the initial distribution. The parameter `type_of_distribution` can either be equal to `"uniform"` or `"general distribution"`.

<!-- TODO: Try to add a more complex example here -->
## Quick example

In the example below we download the *paint.95.POMDP* file from [POMDP.org](https://www.pomdp.org/examples/paint.95.POMDP) and parse the content into a `SWildcardArrayPOMDP` variable type defined in this package. We then illustrate a few functionalities from *POMDPs.jl*.

```julia
using HTTP, POMDPs, POMDPFiles

mktempdir() do tmp_dir 
    url = "https://www.pomdp.org/examples/paint.95.POMDP"
    tmp_file_name = joinpath(tmp_dir, "paint.95.POMDP")
    HTTP.download(url, tmp_file_name)

    pomdp = SWildcardArrayPOMDP(tmp_file_name)

    states(pomdp)
end
```
Some of the examples in [POMDP.org](https://www.pomdp.org/examples), for instance, the `mini-hall2`, specifies a POMDP without associating names with the states, actions, and observations. In these cases, one may use the `WildcardArrayPOMDP` type as described in the example below. 

```julia
using HTTP, POMDPs, POMDPFiles

mktempdir() do tmp_dir 
    url = "https://www.pomdp.org/examples/mini-hall2.POMDP"
    tmp_file_name = joinpath(tmp_dir, "mini-hall2.POMDP")
    HTTP.download(url, tmp_file_name)

    pomdp = WildcardArrayPOMDP(tmp_file_name)

    initialstate(pomdp)
end
```

Using `SWildcardArrayPOMDP` in the previous example would allow us to refer to states, actions, and observations by means of a $0$-based indexing.
