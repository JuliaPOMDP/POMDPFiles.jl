module POMDPFiles

using Reexport
using POMDPs
@reexport using POMDPXFile

import POMDPs: action, value

export
	POMDPFile,

	read_alpha

include("read.jl")
include("write.jl")

end # module
