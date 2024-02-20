# Testing how to index matrix in julia with a special caracter
using OrderedCollections

temp_dic = ((0,1,0),(1,0,0),(3,0,0),(3,2,2))
prob = [0.4,0.6,0.5,0.7]
dd = OrderedDict(tt => prob[index] for (index, tt) in enumerate(temp_dic))

abstract type ProbabilityLookup end;

struct TransitionProb{T}  <: ProbabilityLookup
    x::OrderedDict{Tuple{Vararg{T}}, Float64}
    number_of_states::Int64
    number_of_actions::Int64
end

struct ObservationProb{T, N}  <: ProbabilityLookup where {T <: Real}
    x::OrderedDict{NTuple{N, T}, Float64}
    number_of_states::Int64
    number_of_actions::Int64
    number_of_observations::Int64
end

max_num_states(::TransitionProb) = 1
max_num_states(::ObservationProb) = 1

function Base.getindex(obj:: ProbabilityLookup, key::Tuple{Vararg{Int}})
    # ...
end

function foo(args::Vararg{N, Int}...) where {N}
    N == length(args)
    @show N
end
NTuple{3, Int} == Tuple{Int, Int, Int}

function Base.getindex(obj:: TransitionProb, key::NTuple{Vararg{Int}})
    keys_obj = keys(obj.x) |> collect
    n = length(key)

    max_num = [obj.number_of_states, obj.number_of_actions, obj.number_of_states]

    if !isequal(n,3)
        error("The key argument must be an integer tuple of size equal to 3")
    end

    if any(x -> x <= 0, key) || any(key[i] > max_num[i] for i in 1:n)
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
        error("Key not found")
    end

    return obj.x[keys_obj[index]]
end


function Base.getindex(obj:: ObservationProb, key::Tuple{Vararg{Int}})
    keys_obj = keys(obj.x) |> collect
    n = length(key)

    max_num = [obj.number_of_states, obj.number_of_actions, obj.number_of_observations]

    if !isequal(n,3)
        error("The key argument must be an integer tuple of size equal to 3")
    end

    if any(x -> x <= 0, key) || any(key[i] > max_num[i] for i in 1:n)
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
        error("Key not found")
    end

    return obj.x[keys_obj[index]]
end
