## Types to deal with the memory saving feature
"""
    ContainerNames 

        names: Vector{String} - a vector with the names of the actions, states, or observations.    
        number: Int - the number of actions, states, or observations.

    This type was created to store the names and number of actions, states, and observations when parsed from the preamble of a .pomdp file format.
"""
struct ContainerNames
    names::Vector{String}
    number::Int
end

"""
    This constructor can be used to create a ContainerNames object when the names of the actions, states, or observations are not known. Note that by default the startindex is 0.
"""
function ContainerNames(number::Int;startindex::Int=0)
    names = [string(i) for i in startindex:(number-1)]
    return ContainerNames(names, number)
end
"""
    We can also build a ContainerNames object by passing the names of the actions, states, or observations.
"""
ContainerNames(names_of_actions::Vector{String}) = ContainerNames(names_of_actions, length(names_of_actions))

Base.names(a::ContainerNames) = a.names

"""
    number returns the number of actions, states, or observations in the ContainerNames object.
"""
number(a::ContainerNames) = a.number

"""
    InitialStateParam was created to store the initial state distribution of a POMDP. The distribution can be of any type, but it is stored as a vector of Float64 values.
"""
mutable struct InitialStateParam
    number::Int
    type_of_distribution::String
    support_of_distribution::Set{Int}
    value_of_distribution::Vector{Float64}

end
InitialStateParam(number::Int) = InitialStateParam(number, " ", Set{Int}([]), Vector{Float64}([])) 
InitialStateParam() = InitialStateParam(0)

"""
    number returns the number of states in the initial state distribution.
"""
number(init::InitialStateParam) = init.size_of_states

"""
   support returns the support of the initial state distribution. 
"""
support(init::InitialStateParam) = init.support_of_distribution

"""
     value returns the a vector with the initial state distribution.
"""
prob(init::InitialStateParam) = init.value_of_distribution
