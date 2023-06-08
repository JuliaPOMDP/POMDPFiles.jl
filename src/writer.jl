
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

"""
Write out a `.pomdp` file using the POMDPs.jl interface
Specification: http://cs.brown.edu/research/ai/pomdp/examples/pomdp-file-spec.html
A more recent version of the spec: https://pomdp.org/code/pomdp-file-spec.html
"""
function Base.write(io::IO, pomdp::POMDP; pretty = false)
	if pretty
		prettyprint(io, pomdp)
	else
		print(io, pomdp)
	end
end

function print(io::IO, pomdp::POMDP)
	_states       = ordered_states(pomdp)
	_actions      = ordered_actions(pomdp)
	_observations = ordered_observations(pomdp)

	println(io, "discount: $(discount(pomdp))")
	println(io, "values: reward")
    println(io, "states: $(length(_states))")
    println(io, "actions: $(length(_actions))")
    println(io, "observations: $(length(_observations))")
	println(io)

	# --------------------------------------------------------------------------
	# TRANSITION
	#
	# T: <action>
	# %f %f ... %f
	# %f %f ... %f
	# ...
	# %f %f ... %f
	#
	# each row corresponds to one of the start states and
	# each column specifies one of the ending states

	for a=_actions
		aidx = actionindex(pomdp, a) -1
		println(io, "T: $(aidx)")
		for s=_states
			T = transition(pomdp, s, a)
			for sp=_states
				print(io, pdf(T, sp))
				print(io, (sp == last(_states)) ? "\n" : " ")
			end
		end
		println(io)
	end

	# --------------------------------------------------------------------------
	# OBSERVATION
	#
	# O: <action>
	# %f %f ... %f
	# %f %f ... %f
	# ...
	# %f %f ... %f
	#
	# each row corresponds to one of the states and
	# each column specifies one of the observations

	for a=_actions
		aidx = actionindex(pomdp, a) -1
		println(io, "O: $(aidx)")
		for s=_states
			O = observation(pomdp, a, s)
			for o=_observations
				print(io, pdf(O, o))
				print(io, (o == last(_observations)) ? "\n" : " ")
			end
		end
		print(io, "\n")
	end

	# --------------------------------------------------------------------------
	# REWARD
	#
	# R: <action> : <start-state> : <end-state> : <observation> %f
	# where * is used for <end-state> and <observation> to indicate a wildcard
	# that is expanded to all existing entities

	for a=pomdp_actions, s=pomdp_states, sp=pomdp_states, o=pomdp_observations
		aidx = actionindex(pomdp, a) - 1
		sidx = stateindex(pomdp, s) - 1
		spidx = stateindex(pomdp, sp) - 1
		oidx = obsindex(pomdp, o) - 1
        r = reward(pomdp, s, a, sp, o)
        println(io, "R: $(aidx) : $(sidx) : $(spidx) : $(oidx) $(r)")
	end

	println(io)
end

function normalize(s)
	s = string(s)
	clean = replace(s, r"[^a-zA-Z0-9]" => "_")
	return replace(clean, r"_+" => "_")
end

function prettyprint(
	io::IO, pomdp::POMDP;
	sname::Function=normalize, aname::Function=normalize, oname::Function=normalize
)
	_states       = ordered_states(pomdp)
	_actions      = ordered_actions(pomdp)
	_observations = ordered_observations(pomdp)

	println(io, "discount: $(discount(pomdp))")
	println(io, "values: reward")
    println(io, "states: $(join(map(sname, _states), " "))")
    println(io, "actions: $(join(map(aname, _actions), " "))")
    println(io, "observations: $(join(map(oname, _observations), " "))")
	println(io)

	println("# ------------------------------------------------------------------------")
	println("# TRANSITIONS")
	println("T: * : * : * 0.0")
	for a=_actions, s=_states, sp=_states
		T = transition(pomdp, s, a)
		println(io, "T: $(aname(a)) : $(sname(s)) : $(sname(sp)) : $(pdf(T, sp))")
	end
	println(io)

	println("# ------------------------------------------------------------------------")
	println("# OBSERVATIONS")
	println("O: * : * : * 0.0")
	for a=_actions, sp=_states, o=_observations
		O = observation(pomdp, a, sp)
		println(io, "O: $(aname(a)) : $(sname(sp)) : $(oname(o)) $(pdf(O, obs))")
	end
	println(io)

	println("# ------------------------------------------------------------------------")
	println("# REWARDS")
	println("R: * : * : * : * 0.0")
	for a=_actions, s=_states, sp=_states, o=_observations
		r = reward(pomdp, s, a, sp, o)
		println(io, "R: $(aname(a)) : $(sname(s)) : $(sname(sp)) : $(oname(o)) $(r)")
	end
	println(io)
end