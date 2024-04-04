# POMDPFiles

<!-- [![Build Status](https://github.com/licioromao/POMDPFiles.jl/actions/workflows/CI.yml/bagde.svg)](https://github.com/licioromao/POMDPFiles.jl/actions/workflows/CI.yml/) -->

This package constitutes the interface between the [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) package and the file format .pomdp defined in [POMDP.org](https://www.pomdp.org/code/pomdp-file-spec.html).

## Installation 

Please use the following command to use this package
```julia
] add git@github.com:licioromao/POMDPFiles.jl.git
```
<!-- TODO: Try to add a more complex example here -->
## Quick example

In the example below we download the *paint.95.POMDP* file from [POMDP.org](https://www.pomdp.org/examples/paint.95.POMDP) and parse the content into a *SFilePOMDP* variable type defined in this package. We then illustrate a few functionalities from *POMDPs.jl*.

```julia
using HTTP, POMDPs, POMDPFiles 

url = "https://www.pomdp.org/examples/paint.95.POMDP"
tmp_dir = mktempdir()
tmp_file_name = tmp_dir * "/paint.95.POMDP" 

HTTP.download(url, tmp_file_name)

pomdp = SWildcardArray(tmp_file_name)

initialstate(pomdp)
actions(pomdp)
observations(pomdp)
states(pomdp)
