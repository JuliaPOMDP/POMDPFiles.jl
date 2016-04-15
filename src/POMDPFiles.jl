module POMDPFiles

using Reexport
using POMDPs
@reexport using POMDPXFiles

import POMDPs: action, value

export
	POMDPFile,

	read_alpha

include("read.jl")
include("write.jl")

end # module
