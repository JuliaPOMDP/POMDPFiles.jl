"""
Writes out the alpha vectors in the `.alpha` file format
"""
function Base.write(io::IO, alphas::POMDPAlphas)
    alphavectors = alphas.alpha_vectors
    for aidx in eachindex(alphas.alpha_actions)
        println(io, alphas.alpha_actions[aidx])
        vector_as_str = join([@sprintf "%.25f" v for v=alphavectors[aidx]], " ")
        println(io, vector_as_str)
    end
    println(io)
end

"""
Write out a `.pomdp` file using the POMDPs.jl interface
Specification: http://cs.brown.edu/research/ai/pomdp/examples/pomdp-file-spec.html
A more recent version of the spec: https://pomdp.org/code/pomdp-file-spec.html
"""
function Base.write(io::IO, pomdp::POMDP; pretty=false)
    pretty ? symbolicprint(io, pomdp) : numericprint(io, pomdp)
end

function numericprint(filename::String, pomdp::POMDP)
    file = open(filename, "w")
    numericprint(file, pomdp)
    close(file)
end

function numericprint(io::IO, pomdp::POMDP)
    _states       = ordered_states(pomdp)
    _actions      = ordered_actions(pomdp)
    _observations = ordered_observations(pomdp)

    println(io, "discount: $(discount(pomdp))")
    println(io, "values: reward")
    println(io, "states: $(length(_states))")
    println(io, "actions: $(length(_actions))")
    println(io, "observations: $(length(_observations))")
    println(io)

    for a=_actions
        aidx = actionindex(pomdp, a) -1
        println(io, "T: $(aidx)")
        for s=_states
            T = transition(pomdp, s, a)
            Trow = join([pdf(T, sp) for sp=_states], " ")
            println(io, Trow)
        end
        println(io)
    end

    for a=_actions
        aidx = actionindex(pomdp, a) -1
        println(io, "O: $(aidx)")
        for s=_states
            O = observation(pomdp, a, s)
            Orow = join([pdf(O, o) for o=_observations], " ")
            println(io, Orow)
        end
        print(io, "\n")
    end

    for a=_actions, s=_states, sp=_states, o=_observations
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

function symbolicprint(
    filename::String, pomdp::POMDP;
    sname::Function=normalize, aname::Function=normalize, oname::Function=normalize
)
    file = open(filename, "w")
    symbolicprint(file, pomdp; sname=sname, aname=aname, oname=oname)
    close(file)
end

function symbolicprint(
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

    println(io, "# -------------------------------------------------------------------")
    println(io, "# TRANSITIONS")
    println(io, "T: * : * : * 0.0")
    for a=_actions, s=_states, sp=_states
        T = transition(pomdp, s, a)
		if pdf(T, sp) > 0.
        	println(io, "T: $(aname(a)) : $(sname(s)) : $(sname(sp)) : $(pdf(T, sp))")
		end
    end
    println(io)

    println(io, "# -------------------------------------------------------------------")
    println(io, "# OBSERVATIONS")
    println(io, "O: * : * : * 0.0")
    for a=_actions, sp=_states, o=_observations
        O = observation(pomdp, a, sp)
		if pdf(O, o) > 0.
        	println(io, "O: $(aname(a)) : $(sname(sp)) : $(oname(o)) $(pdf(O, o))")
		end
    end
    println(io)

    println(io, "# -------------------------------------------------------------------")
    println(io, "# REWARDS")
    println(io, "R: * : * : * : * 0.0")
    for a=_actions, s=_states, sp=_states, o=_observations
        r = reward(pomdp, s, a, sp, o)
		if r != 0
        	println(io, "R: $(aname(a)) : $(sname(s)) : $(sname(sp)) : $(oname(o)) $(r)")
		end
    end
    println(io)
end