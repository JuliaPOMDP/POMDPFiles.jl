
using POMDPs, Distributions

struct MyPOMDP <: POMDP{Int, Int, Int} 
    number_of_states::Int64
    name_of_states::Vector{String}

    number_of_actions::Int64
    name_of_actions::Vector{String}

    number_of_observations::Int64
    name_of_observations::Vector{String}

    support_of_distribution::Set{Int64}
    value_of_distribution::Vector{Float64}

    discount::Float64

    T::OrderedDict{NTuple{3, Int64}, Float64}
    O::OrderedDict{NTuple{3, Int64}, Float64}
    R::OrderedDict{NTuple{4, Int64}, Float64}
end

MyPOMDP(s::StateParam, a::ActionsParam, o::ObservationParam, initial_state::InitialStateParam, discount::Float64, T::OrderedDict{NTuple{3, Int64}, Float64}, O::OrderedDict{NTuple{3, Int64}, Float64}, R::OrderedDict{NTuple{4, Int64}, Float64}) = MyPOMDP(s.number_of_states, s.names_of_states, a.number_of_actions, a.names_of_actions, o.number_of_observations, o.names_of_observations, initial_state.support_of_distribution, initial_state.value_of_distribution, discount, T, O, R)

MyPOMDP(s::StateParam, a::ActionsParam, o::ObservationParam, discount::Float64, T::OrderedDict{NTuple{3, Int64}, Float64}, O::OrderedDict{NTuple{3, Int64}, Float64}, R::OrderedDict{NTuple{4, Int64}, Float64}) = MyPOMDP(s.number_of_states, s.names_of_states, a.number_of_actions, a.names_of_actions, o.number_of_observations, o.names_of_observations, [], [], discount, T, O, R)


states(m::MyPOMDP) = 1:m.number_of_states
stateindex(m::MyPOMDP, i::Int64) = (i <= m.number_of_states) ? i : error("Querying states outside the allowable range.")

actions(m::MyPOMDP) = 1:m.number_of_actions
actionindex(m::MyPOMDP, i::Int64) = (i <= m.number_of_actions) ? i : error("Querying input outside the allowable range.")

observations(m::MyPOMDP) = 1:m.number_of_observations
obsindex(m::MyPOMDP, i::Int64) = (i <= m.number_of_observations) ? i : error("Querying observations outside the allowable range.")

function initialstate(m::MyPOMDP)

    if !isempty(m.value_of_distribution)
        return SparseCat(1:m.number_of_states, m.value_of_distribution)
    else
        @warn "No available initial condition."
        return false
    end
end


function transition(m::MyPOMDP, s::Int64, a::Int64)

    prob_val = [m.T[(s,a,sp)] for sp in 1:m.number_of_states]

    return SparseCat(1:m.number_of_states, prob_val)
end

transition(m::MyPOMDP, s::Int64, a::Int64, sp::Int64) = m.T[(s,a,sp)]

function observation(m::MyPOMDP, s::Int64, a::Int64)

    prob_obs = [m.O[(s, a, obs) for obs in 1:m.number_of_observations]]

    return SparseCat(1:m.number_of_observations, prob_obs)
end

observation(m::MyPOMDP, s::Int64, a::Int64, obs::Int64) = m.O[(s,a,obs)]

reward(m::MyPOMDP, s::Int64, a::Int64, sp::Int64, obs::Int64) = m.R[(s,a,sp,obs)]

reward(m::MyPOMDP, s::Int64, a::Int64, sp::Int64) = m.R[(s,a,sp,1)]

reward(m::MyPOMDP, s::Int64, a::Int64) = m.R[(s,a,1,1)]


discount(m::MyPOMDP) = m.discount

