
"""
Writes out the alpha vectors in the `.alpha` file format
"""
function Base.write(io::IO, alphas::POMDPAlphas)

	vector_length = size(alphas.alpha_vectors, 1)

	for i in 1 : length(alphas.alpha_actions)
		println(io, alphas.alpha_actions[i])

		for j in 1 : vector_length
			@printf(io, "%.25f", alphas.alpha_vectors[j,i])
			if j != vector_length
				print(io, " ")
			else
				print(io, "\n")
			end
		end

		println(io, "")
	end
end