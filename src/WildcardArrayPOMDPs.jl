"""
    WildcardArrayPOMDP is the main data structure of the package. It is used to represent a POMDP problem from a file.

        ns: number of states
        na: number of actions
        no: number of observations

        support_initialstate: support of the initial state distribution
        initialstate_distribution: initial state distribution

        discount: discount factor

        T: transition matrix
        O: observation matrix
        R: reward matrix
"""
struct WildcardArrayPOMDP <: POMDP{Int, Int, Int} 
    ns::Int
    na::Int
    no::Int

    support_initialstate::Set{Int}
    initialstate_distribution::Vector{Float64}

    discount::Float64

    T::WildcardArray{Float64, 3}
    O::WildcardArray{Float64, 3}
    R::WildcardArray{Float64, 4}
end

"""
    Constructors for the WildcardArrayPOMDP type.
"""
WildcardArrayPOMDP(s::Int, a::Int, o::Int, initial_state::InitialStateParam, discount::Float64, T::WildcardArray{Float64, 3}, O::WildcardArray{Float64, 3}, R::WildcardArray{Float64, 4})= WildcardArrayPOMDP(s, a, o, support(initial_state), prob(initial_state), discount, T, O, R)  
WildcardArrayPOMDP(filename::String) = read_pomdp(filename; output=:WildcardArrayPOMDP)

"""
        Implementing the functions required by the POMDP interface. See [POMDPs.jl](https://juliapomdp.github.io/POMDPs.jl/latest/) for more details on the interface.
"""
states(m::WildcardArrayPOMDP) = 1:m.ns
stateindex(m::WildcardArrayPOMDP, i::Int) = (i <= m.ns) ? i : error("Querying states outside the allowable range.")

actions(m::WildcardArrayPOMDP) = 1:m.na
actionindex(m::WildcardArrayPOMDP, i::Int) = (i <= m.na) ? i : error("Querying input outside the allowable range.")

observations(m::WildcardArrayPOMDP) = 1:m.no
obsindex(m::WildcardArrayPOMDP, i::Int) = (i <= m.no) ? i : error("Querying observations outside the allowable range.")

function initialstate(m::WildcardArrayPOMDP)
    if !isempty(m.initialstate_distribution)
        return SparseCat(states(m), m.initialstate_distribution)
    else
        return SparseCat(states(m), 1/m.ns*ones(m.ns))
    end
end

function transition(m::WildcardArrayPOMDP, s::Int, a::Int)
    prob_val = [m.T[a,s,sp] for sp in states(m)]
    return SparseCat(states(m), prob_val)
end

function observation(m::WildcardArrayPOMDP, a::Int, sp::Int)
    prob_obs = [m.O[a, sp, obs] for obs in observations(m)]
    return SparseCat(observations(m), prob_obs)
end

reward(m::WildcardArrayPOMDP, s::Int, a::Int, sp::Int, obs::Int) = m.R[a,s,sp,obs]
reward(m::WildcardArrayPOMDP, s::Int, a::Int, sp::Int) = m.R[a,s,sp,1]
reward(m::WildcardArrayPOMDP, s::Int, a::Int) = m.R[a,s,1,1]

discount(m::WildcardArrayPOMDP) = m.discount

# Data structure with names
"""
    SWildcardArrayPOMDP is used whenever the names of the states, actions, and observations are known. It is used to represent a POMDP problem from a file.

        dic_states: dictionary with the names of the states
        dic_actions: dictionary with the names of the actions
        dic_obs: dictionary with the names of the observations
        pomdp: WildcardArrayPOMDP structure
"""
struct SWildcardArrayPOMDP <: POMDP{String, String, String}
    dic_states::Dict{String, Int}
    dic_actions::Dict{String, Int}
    dic_obs::Dict{String, Int}
    pomdp::WildcardArrayPOMDP

    function SWildcardArrayPOMDP(dic_ss::Dict{String, Int}, dic_aa::Dict{String, Int}, dic_oo::Dict{String, Int}, pomdp::WildcardArrayPOMDP)
        @assert length(dic_ss) == pomdp.ns
        @assert length(dic_aa) == pomdp.na
        @assert length(dic_oo) == pomdp.no
        
        new(dic_ss, dic_aa, dic_oo, pomdp)
    end
end
SWildcardArrayPOMDP(filename::String) = read_pomdp(filename; output=:SWildcardArrayPOMDP)
"""
    Implementing the functions required by the POMDP interface. See [POMDPs.jl](https://juliapomdp.github.io/POMDPs.jl/latest/) for more details on the interface.
"""
states(m::SWildcardArrayPOMDP) = states(m.pomdp)
stateindex(m::SWildcardArrayPOMDP, key::Int) = stateindex(m.pomdp, key)
statenames(m::SWildcardArrayPOMDP) = collect(keys(m.dic_states))
function stateindex(m::SWildcardArrayPOMDP, key::String) 
    i = m.dic_states[key]
    return stateindex(m, i)
end

actions(m::SWildcardArrayPOMDP) = actions(m.pomdp)
actionindex(m::SWildcardArrayPOMDP, key::Int) = actionindex(m.pomdp, key)
actionnames(m::SWildcardArrayPOMDP) = collect(keys(m.dic_actions))
function actionindex(m::SWildcardArrayPOMDP, key::String)
    i = m.dic_actions[key]
    return actionindex(m, i)
end

observations(m::SWildcardArrayPOMDP) = observations(m.pomdp)
obsindex(m::SWildcardArrayPOMDP, i::Int) = obsindex(m.pomdp, i) 
obsnames(m::SWildcardArrayPOMDP) = collect(keys(m.dic_obs))
function obsindex(m::SWildcardArrayPOMDP, key::String)
    i = m.dic_obs[key]
    return obsindex(m, i)
end

initialstate(m::SWildcardArrayPOMDP) = initialstate(m.pomdp)

transition(m::SWildcardArrayPOMDP, s::Int, a::Int) = transition(m.pomdp, s, a)
function transition(m::SWildcardArrayPOMDP, s::String, a::String)
   is = m.dic_states[s]; ia = m.dic_actions[a] 
   return transition(m, is, ia)
end

observation(m::SWildcardArrayPOMDP, a::Int, sp::Int) = observation(m.pomdp, a, sp)
function observation(m::SWildcardArrayPOMDP, a::String, sp::String)
    isp = m.dic_states[sp]; ia = m.dic_actions[a] 
    return observation(m, ia, isp) 
end

reward(m::SWildcardArrayPOMDP, s::Int, a::Int, sp::Int, obs::Int) = reward(m.pomdp, s, a, sp, obs)
reward(m::SWildcardArrayPOMDP, s::String, a::String, sp::String, obs::String) = reward(m.pomdp, m.dic_states[s], m.dic_actions[a], m.dic_states[sp], m.dic_obs[obs])
reward(m::SWildcardArrayPOMDP, s::Int, a::Int, sp::Int) = reward(m.pomdp, s, a, sp)
reward(m::SWildcardArrayPOMDP, s::String, a::String, sp::String) = reward(m.pomdp, m.dic_states[s], m.dic_actions[a], m.dic_states[sp])
reward(m::SWildcardArrayPOMDP, s::Int, a::Int) = reward(m.pomdp, s, a)
reward(m::SWildcardArrayPOMDP, s::String, a::String) = reward(m.pomdp, m.dic_states[s], m.dic_actions[a])

discount(m::SWildcardArrayPOMDP) = discount(m.pomdp)  