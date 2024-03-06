## Types to deal with the memory saving feature
struct ActionsParam 
    names_of_actions::Vector{SubString{String}}
    number_of_actions::Int
end

function ActionsParam(number_of_actions::Int)
    # @warn "Defining the action names from -1 to $(number_of_actions-1)"
    names_of_actions = [string(i) for i in 0:(number_of_actions-1)]
    
    return ActionsParam(names_of_actions, number_of_actions)
end

ActionsParam(names_of_actions::Vector{SubString{String}}) = ActionsParam(names_of_actions, length(names_of_actions))

Base.names(a::ActionsParam) = a.names_of_actions
number(a::ActionsParam) = a.number_of_actions

struct StateParam 
    names_of_states::Vector{SubString{String}}
    number_of_states::Int
end

function StateParam(number_of_states::Int)
    # @warn "Defining the states names from 0 to $(number_of_states-1)"
    names_of_states = [string(i) for i in 0:(number_of_states-1)]
    
    return StateParam(names_of_states, number_of_states)
end

StateParam(name_of_states::Vector{SubString{String}}) = StateParam(name_of_states, length(name_of_states))

Base.names(s::StateParam) = s.names_of_states
number(s::StateParam) = s.number_of_states

struct ObservationParam
    names_of_observations::Vector{SubString{String}}
    number_of_observations::Int
end

function ObservationParam(number_of_observations::Int)
    # @warn "Defining the states names from 0 to $(number_of_observations-1)"
    names_of_observations = [string(i) for i in 0:(number_of_observations-1)]
    
    return ObservationParam(names_of_observations, number_of_observations)
end

ObservationParam(names_of_observations::Vector{SubString{String}}) = ObservationParam(names_of_observations, length(names_of_observations))

Base.names(o::ObservationParam) = o.names_of_observations
number(o::ObservationParam) = o.number_of_observations

struct InitialStateParam{T}

    size_of_states::T
    type_of_distribution::String
    support_of_distribution::Set{T}
    value_of_distribution::Vector{Float64}

    function InitialStateParam{T}(size_of_states::T, type_of_distribution::String, support_of_distribution::Set{T}, 
                            value_of_distribution::Vector{Float64}) where T<:Int64 

        # Length of value_of_distribution must coincide with N, and all elements of support_of_distribution must be smaller, or equal to, N
        if isempty(type_of_distribution) 
            new{T}(size_of_states, "", Set{Int64}([]), Vector{Float64}([]))
        elseif (length(value_of_distribution) != size_of_states) || (collect(support_of_distribution) |> maximum) > size_of_states
            error("Vector of probabilities must have the same size of the state space.")
        elseif !isapprox(sum(value_of_distribution),1, atol=1e-3) || any(x -> (x > 1) || (x < 0),  value_of_distribution) # checking whether value_of_distribution is a valid probability distribution
            error("The last parameter must be a probability measure")
        else
            new{T}(size_of_states, type_of_distribution, support_of_distribution, value_of_distribution)
        end
    end
end

InitialStateParam() = InitialStateParam{Int64}(0, "", Set{Int64}([]), Vector{Float64}([])) 
InitialStateParam(size_of_states::Int64) = InitialStateParam{Int64}(size_of_states, "", Set{Int64}([]), Vector{Float64}([])) 

number(init::InitialStateParam) = init.size_of_states
support(init::InitialStateParam) = init.support_of_distribution
prob(init::InitialStateParam) = init.value_of_distribution

###############


abstract type TransitionsLookUp end;
abstract type RewardLookUp end;

struct TransitionProb{T}  <: TransitionsLookUp 
    trans_parsed::OrderedDict{NTuple{3, T}, Float64}
    number_of_states::Int64
    number_of_actions::Int64
end

struct ObservationProb{T}  <: TransitionsLookUp 
    obs_parsed::OrderedDict{NTuple{3, T}, Float64}
    number_of_states::Int64
    number_of_actions::Int64
    number_of_observations::Int64
end

struct RewardValue{T} <: RewardLookUp
    reward_parsed::OrderedDict{NTuple{4, T}, Float64}
    number_of_states::Int64
    number_of_actions::Int64
    number_of_observations::Int64
end

max_num_states(trans_prob::TransitionProb) = [trans_prob.number_of_states, trans_prob.number_of_actions, trans_prob.number_of_states]
max_num_states(obs_prob::ObservationProb) = [obs_prob.number_of_states, obs_prob.number_of_actions, obs_prob.number_of_observations]
max_num_states(reward::RewardLookUp) = [reward.number_of_states, reward.number_of_actions, reward.number_of_states, reward.number_of_observations]

dict(trans_prob::TransitionProb) = trans_prob.trans_parsed
dict(obs_prob::ObservationProb) = obs_prob.obs_parsed

dict(reward::RewardLookUp) = reward.reward_parsed

function Base.getindex(obj::TransitionsLookUp, key::NTuple{3, Int})
    keys_obj = dict(obj) |> keys |> collect
    n = length(key)

    max_num = max_num_states(obj) 

    if !isequal(n,3)
        error("The key argument must be an integer tuple of size equal to 3")
    end

    if any(x -> x <= 0, key) || any(key[i] > max_num[i] for i in 1:n)
        println(key)
        error("Indices must be integers larger than zero and less than or equal to the entries of the vector $(max_num)")
    end

    index = 1
    status = false

    possible_keys = [collect(key), [key[1], 0, 0], [key[1], 0, key[3]], [key[1], key[2], 0], [0, key[2], 0], [0, key[2], key[3]], [0, 0, key[3]], [0,0,0]] # all possible keys on the reduced dictionary
    
    for kk in possible_keys
        temp_index = findfirst(x->isequal(x,Tuple(kk)), keys_obj)

        if !isnothing(temp_index)
            status = true
            if temp_index > index
                index = temp_index
            end
        end
    end

    if !status
       return 0 
    end

    return dict(obj)[keys_obj[index]]
end

function Base.getindex(reward::RewardLookUp, key::NTuple{4, Int})
    keys_obj = dict(reward) |> keys |> collect
    n = length(key)

    max_num = max_num_states(reward) 

    if !isequal(n,4)
        error("The key argument must be an integer tuple of size equal to 4")
    end

    if any(x -> x <= 0, key) || any(key[i] > max_num[i] for i in 1:n)
        error("Indices must be integers larger than zero and less than or equal to the entries of the vector $(max_num)")
    end

    index = 1
    status = false

    possible_keys = [collect(key), [key[1], 0, 0, 0],  [0, key[2], 0, 0], [0, 0, key[3], 0], [0, 0, 0, key[4]],[key[1], key[2], 0, 0], [key[1], 0, key[3], 0], [key[1], 0, 0, key[4]], [0, key[2], key[3], 0], [0, key[2], 0, key[4]], [0, 0, key[3], key[4]], [key[1], key[2], key[3], 0], [key[1], key[2], 0, key[4]], [key[1], 0, key[3], key[4]], [0, key[2], key[3], key[4]], [0, 0, 0, 0]] # all possible keys

    for kk in possible_keys
        temp_index = findfirst(x->isequal(x,Tuple(kk)), keys_obj)

        if !isnothing(temp_index)
            status = true
            if temp_index > index
                index = temp_index
            end
        end
    end

    if !status
       return 0 
    end

    return dict(reward)[keys_obj[index]]
end
