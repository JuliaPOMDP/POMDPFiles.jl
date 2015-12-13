module POMDPFiles

using POMDPs
using POMDPXFile

import POMDPs: action, value

export
	POMDPFile,
	Alphas,

	action,
	value,
	read_alphas

include("read.jl")
include("write.jl")

end # module
