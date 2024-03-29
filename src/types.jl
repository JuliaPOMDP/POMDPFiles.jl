## Types to deal with the memory saving feature
struct ContainerNames
    names::Vector{String}
    number::Int
end

function ContainerNames(number::Int;startindex::Int=0)
    names = [string(i) for i in startindex:(number-1)]
    return ContainerNames(names, number)
end

ContainerNames(names_of_actions::Vector{String}) = ContainerNames(names_of_actions, length(names_of_actions))
Base.names(a::ContainerNames) = a.names
number(a::ContainerNames) = a.number

struct InitialStateParam
    number::Int
    type_of_distribution::String
    support_of_distribution::Set{Int}
    value_of_distribution::Vector{Float64}

    InitialStateParam(number::Int) = new(number, " ", Set{Int}([]), Vector{Float64}([])) 
end
InitialStateParam() = InitialStateParam(0)

number(init::InitialStateParam) = init.size_of_states
support(init::InitialStateParam) = init.support_of_distribution
prob(init::InitialStateParam) = init.value_of_distribution
