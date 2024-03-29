struct FilePOMDP <: POMDP{Int, Int, Int} 
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

FilePOMDP(s::Int, a::Int, o::Int, initial_state::InitialStateParam, discount::Float64, T::WildcardArray{Float64, 3}, O::WildcardArray{Float64, 3}, R::WildcardArray{Float64, 4})= FilePOMDP(s, a, o, support(initial_state), prob(initial_state), discount, T, O, R)  
FilePOMDP(filename::String) = read_pomdp(filename; output=:FilePOMDP)

states(m::FilePOMDP) = 1:m.ns
stateindex(m::FilePOMDP, i::Int) = (i <= m.ns) ? i : error("Querying states outside the allowable range.")

actions(m::FilePOMDP) = 1:m.na
actionindex(m::FilePOMDP, i::Int) = (i <= m.na) ? i : error("Querying input outside the allowable range.")

observations(m::FilePOMDP) = 1:m.no
obsindex(m::FilePOMDP, i::Int) = (i <= m.no) ? i : error("Querying observations outside the allowable range.")

function initialstate(m::FilePOMDP)
    if !isempty(m.initialstate_distribution)
        return SparseCat(states(m), m.initialstate_distribution)
    else
        return SparseCat(states(m), 1/m.ns*ones(m.ns))
    end
end

function transition(m::FilePOMDP, s::Int, a::Int)
    prob_val = [m.T[a,s,sp] for sp in states(m)]
    return SparseCat(states(m), prob_val)
end

function observation(m::FilePOMDP, a::Int, sp::Int)
    prob_obs = [m.O[(a, sp, obs)] for obs in observations(m)]
    return SparseCat(observations(m), prob_obs)
end

reward(m::FilePOMDP, s::Int, a::Int, sp::Int, obs::Int) = m.R[(a,s,sp,obs)]
reward(m::FilePOMDP, s::Int, a::Int, sp::Int) = m.R[(a,s,sp,1)]
reward(m::FilePOMDP, s::Int, a::Int) = m.R[(a,s,1,1)]

discount(m::FilePOMDP) = m.discount

# Data structure with names
struct SFilePOMDP <: POMDP{String, String, String}
    dic_states::Dict{String, Int}
    dic_actions::Dict{String, Int}
    dic_obs::Dict{String, Int}
    pomdp::FilePOMDP

    function SFilePOMDP(dic_ss::Dict{String, Int}, dic_aa::Dict{String, Int}, dic_oo::Dict{String, Int}, pomdp::FilePOMDP)
        @assert length(dic_ss) == pomdp.ns
        @assert length(dic_aa) == pomdp.na
        @assert length(dic_oo) == pomdp.no
        
        new(dic_ss, dic_aa, dic_oo, pomdp)
    end
end
SFilePOMDP(filename::String) = read_pomdp(filename; output=:SFilePOMDP)

states(m::SFilePOMDP) = states(m.pomdp)
stateindex(m::SFilePOMDP, key::Int) = stateindex(m.pomdp, key)
statenames(m::SFilePOMDP) = collect(keys(m.dic_states))
function stateindex(m::SFilePOMDP, key::String) 
    i = m.dic_states[key]
    return stateindex(m, i)
end

actions(m::SFilePOMDP) = actions(m.pomdp)
actionindex(m::SFilePOMDP, key::Int) = actionindex(m.pomdp, key)
actionnames(m::SFilePOMDP) = collect(keys(m.dic_actions))
function actionindex(m::SFilePOMDP, key::String)
    i = m.dic_actions[key]
    return actionindex(m, i)
end

observations(m::SFilePOMDP) = observations(m.pomdp)
obsindex(m::SFilePOMDP, i::Int) = obsindex(m.pomdp, i) 
obsnames(m::SFilePOMDP) = collect(keys(m.dic_obs))
function obsindex(m::SFilePOMDP, key::String)
    i = m.dic_obs[key]
    return obsindex(m, i)
end

initialstate(m::SFilePOMDP) = initialstate(m.pomdp)

transition(m::SFilePOMDP, s::Int, a::Int) = transition(m.pomdp, s, a)
function transition(m::SFilePOMDP, s::String, a::String)
   is = m.dic_states[s]; ia = m.dic_actions[a] 
   return transition(m, is, ia)
end

observation(m::SFilePOMDP, a::Int, sp::Int) = observation(m.pomdp, a, sp)
function observation(m::SFilePOMDP, a::String, sp::String)
    isp = m.dic_states[sp]; ia = m.dic_actions[a] 
    return observation(m, ia, isp) 
end

reward(m::SFilePOMDP, s::Int, a::Int, sp::Int, obs::Int) = reward(m.pomdp, s, a, sp, obs)
reward(m::SFilePOMDP, s::String, a::String, sp::String, obs::String) = reward(m.pomdp, m.dic_states[s], m.dic_actions[a], m.dic_states[sp], m.dic_obs[obs])
reward(m::SFilePOMDP, s::Int, a::Int, sp::Int) = reward(m.pomdp, s, a, sp)
reward(m::SFilePOMDP, s::String, a::String, sp::String) = reward(m.pomdp, m.dic_states[s], m.dic_actions[a], m.dic_states[sp])
reward(m::SFilePOMDP, s::Int, a::Int) = reward(m.pomdp, s, a)
reward(m::SFilePOMDP, s::String, a::String) = reward(m.pomdp, m.dic_states[s], m.dic_actions[a])

discount(m::SFilePOMDP) = discount(m.pomdp)  