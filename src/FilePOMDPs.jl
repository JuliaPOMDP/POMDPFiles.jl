##### 
struct FilePOMDP{Int64} <: POMDP{Int64, Int64, Int64} 
    number_of_states::Int64
    number_of_actions::Int64
    number_of_observations::Int64

    support_of_distribution::Set{Int64}
    value_of_distribution::Vector{Float64}

    discount::Float64

    T::TransitionProb
    O::ObservationProb
    R::RewardLookUp
end

FilePOMDP(s::Int64, a::Int64, o::Int64, initial_state::InitialStateParam, discount::Float64, T::TransitionProb, O::ObservationProb, R::RewardLookUp)= FilePOMDP(s, a, o, support(initial_state), prob(initial_state), discount, T, O, R)  

FilePOMDP(filename::String) = read_pomdp(filename, :FilePOMDP)

states(m::FilePOMDP{Int64}) = 1:m.number_of_states
stateindex(m::FilePOMDP{Int64}, i::Int64) = (i <= m.number_of_states) ? i : error("Querying states outside the allowable range.")

actions(m::FilePOMDP{Int64}) = 1:m.number_of_actions
actionindex(m::FilePOMDP{Int64}, i::Int64) = (i <= m.number_of_actions) ? i : error("Querying input outside the allowable range.")

observations(m::FilePOMDP{Int64}) = 1:m.number_of_observations
obsindex(m::FilePOMDP{Int64}, i::Int64) = (i <= m.number_of_observations) ? i : error("Querying observations outside the allowable range.")

function initialstate(m::FilePOMDP{Int64})

    if !isempty(m.value_of_distribution)
        return SparseCat(states(m), m.value_of_distribution)
    else
        @warn "No available initial condition."
        return false
    end
end

transition(m::FilePOMDP{Int64}, s::Int64, a::Int64, sp::Int64) = m.T[(s,a,sp)]

function transition(m::FilePOMDP{Int64}, s::Int64, a::Int64)

    prob_val = [transition(m, s, a, sp) for sp in states(m)]

    return SparseCat(states(m), prob_val)
end

function observation(m::FilePOMDP{Int64}, a::Int64, sp::Int64)

    prob_obs = [m.O[(sp, a, obs)] for obs in observations(m)]

    return SparseCat(observations(m), prob_obs)
end

reward(m::FilePOMDP{Int64}, s::Int64, a::Int64, sp::Int64, obs::Int64) = m.R[(s,a,sp,obs)]

reward(m::FilePOMDP{Int64}, s::Int64, a::Int64, sp::Int64) = m.R[(s,a,sp,1)]

reward(m::FilePOMDP{Int64}, s::Int64, a::Int64) = m.R[(s,a,1,1)]

discount(m::FilePOMDP{Int64}) = m.discount

# Data structure with names

struct SFilePOMDP{String} <: POMDP{String, String, String}
    dic_states::Dict{String, Int64}
    dic_actions::Dict{String, Int64}
    dic_obs::Dict{String, Int64}

    pomdp::FilePOMDP{Int64}

    function SFilePOMDP(dic_ss::Dict{String, Int64}, dic_aa::Dict{String, Int64}, dic_oo::Dict{String, Int64}, pomdp::FilePOMDP{Int64})

        @assert length(dic_ss) == pomdp.number_of_states
        @assert length(dic_aa) == pomdp.number_of_actions
        @assert length(dic_oo) == pomdp.number_of_observations
        
        new{String}(dic_ss, dic_aa, dic_oo, pomdp)

    end
end

SFilePOMDP(filename::String) = read_pomdp(filename)

states(m::SFilePOMDP{String}) = states(m.pomdp)
stateindex(m::SFilePOMDP{String}, key::Int64) = stateindex(m.pomdp, key)
statenames(m::SFilePOMDP{String}) = collect(keys(m.dic_states))

function stateindex(m::SFilePOMDP{String}, key::String) 
    i = m.dic_states[key]
    return stateindex(m, i)
end

actions(m::SFilePOMDP{String}) = actions(m.pomdp)
actionindex(m::SFilePOMDP{String}, key::Int64) = actionindex(m.pomdp, key)
actionnames(m::SFilePOMDP{String}) = collect(keys(m.dic_actions))

function actionindex(m::SFilePOMDP{String}, key::String)
    i = m.dic_actions[key]
    return actionindex(m, i)
end

observations(m::SFilePOMDP{String}) = observations(m.pomdp)
obsindex(m::SFilePOMDP{String}, i::Int64) = obsindex(m.pomdp, i) 
obsnames(m::SFilePOMDP{String}) = collect(keys(m.dic_obs))

function obsindex(m::SFilePOMDP{String}, key::String)
    i = m.dic_obs[key]
    return obsindex(m, i)
end

initialstate(m::SFilePOMDP{String}) = initialstate(m.pomdp)

transition(m::SFilePOMDP{String}, s::Int64, a::Int64, sp::Int64) = transition(m.pomdp, s, a, sp)
transition(m::SFilePOMDP{String}, s::Int64, a::Int64) = transition(m.pomdp, s, a)

function transition(m::SFilePOMDP{String}, s::String, a::String, sp::String)
    is = m.dic_states[s]; ia = m.dic_actions[a]; isp = m.dic_states[s]
    return transition(m.pomdp, is, ia, isp)
end

function transition(m::SFilePOMDP{String}, s::String, a::String)
   is = m.dic_states[s]; ia = m.dic_actions[a] 
   return transition(m, is, ia)
end

observation(m::SFilePOMDP{String}, a::Int64, sp::Int64) = observation(m.pomdp, a, sp)

function observation(m::SFilePOMDP, a::String, sp::String)
    isp = m.dic_states[sp]; ia = m.dic_actions[a] 
    return observation(m, ia, isp) 
end

reward(m::SFilePOMDP{String}, s::Int64, a::Int64, sp::Int64, obs::Int64) = reward(m.pomdp, s, a, sp, obs)
reward(m::SFilePOMDP{String}, s::String, a::String, sp::String, obs::String) = reward(m.pomdp, m.dic_states[s], m.dic_actions[a], m.dic_states[sp], m.dic_obs[obs])

reward(m::SFilePOMDP{String}, s::Int64, a::Int64, sp::Int64) = reward(m.pomdp, s, a, sp)
reward(m::SFilePOMDP{String}, s::String, a::String, sp::String) = reward(m.pomdp, m.dic_states[s], m.dic_actions[a], m.dic_states[sp])

reward(m::SFilePOMDP{String}, s::Int64, a::Int64) = reward(m.pomdp, s, a)
reward(m::SFilePOMDP{String}, s::String, a::String) = reward(m.pomdp, m.dic_states[s], m.dic_actions[a])

discount(m::SFilePOMDP) = discount(m.pomdp)  

