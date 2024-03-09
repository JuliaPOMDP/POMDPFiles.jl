
using POMDPFiles, OrderedCollections
using POMDPs, D3Trees, ARDESPOT, POMDPTools, POMCPOW  
using BenchmarkTools

file_path = "./../test/sources/1d.noisy.POMDP"
    
pomdp_read = FilePOMDP(file_path) # This is POMDP type and can be used with any suitable solver

s0 = rand(initialstate(pomdp_read))
a0 = rand(actions(pomdp_read))

@time transition(pomdp_read, s0, a0) 

hr = HistoryRecorder(max_steps=10)

@time rhist = simulate(hr, pomdp_read, RandomPolicy(pomdp_read))

nothing




############ GENERATING JULIA CODE WITH THE INFORMATION READ ########################

# function generate_julia_pomdp_struct(name_of_file::String, name_of_POMDP::String) 
#     packages_def = """

#     using POMDPs, Distributions, POMDPModelTools
#     """

#     struct_def = """
#     struct $name_of_POMDP <: POMDP{Int, Int, Int} 
#         number_of_states::Int64
#         name_of_states::Vector{String}

#         number_of_actions::Int64
#         name_of_actions::Vector{String}

#         number_of_observations::Int64
#         name_of_observations::Vector{String}

#         support_of_distribution::Set{Int64}
#         value_of_distribution::Vector{Float64}

#         discount::Float64

#         T::TransitionProb
#         O::ObservationProb
#         R::RewardLookUp
#     end
#     """

#     constructor_def = """
#     $name_of_POMDP(s::StateParam, a::ActionsParam, o::ObservationParam, initial_state::InitialStateParam, discount::Float64, T::TransitionProb, O::ObservationProb, R::RewardLookUp)= $name_of_POMDP(s.number_of_states, s.names_of_states, a.number_of_actions, a.names_of_actions, o.number_of_observations, o.names_of_observations, initial_state.support_of_distribution, initial_state.value_of_distribution, discount, T, O, R)

#     $name_of_POMDP(s::StateParam, a::ActionsParam, o::ObservationParam, discount::Float64, T::TransitionProb, O::ObservationProb, R::RewardLookUp) = $name_of_POMDP(s.number_of_states, s.names_of_states, a.number_of_actions, a.names_of_actions, o.number_of_observations, o.names_of_observations, [], [], discount, T, O, R)
#     """

#     states_def = """
#     states(m::$name_of_POMDP) = 1:m.number_of_states
#     stateindex(m::$name_of_POMDP, i::Int64) = (i <= m.number_of_states) ? i : error("Querying states outside the allowable range.")
#     """

#     actions_def = """
#     actions(m::$name_of_POMDP) = 1:m.number_of_actions
#     actionindex(m::$name_of_POMDP, i::Int64) = (i <= m.number_of_actions) ? i : error("Querying input outside the allowable range.")
#     """

#     obs_def = """
#     observations(m::$name_of_POMDP) = 1:m.number_of_observations
#     obsindex(m::$name_of_POMDP, i::Int64) = (i <= m.number_of_observations) ? i : error("Querying observations outside the allowable range.")
#     """

#     initial_state_def = """
#     function initialstate(m::$name_of_POMDP)

#         if !isempty(m.value_of_distribution)
#             return SparseCat(1:m.number_of_states, m.value_of_distribution)
#         else
#             @warn "No available initial condition."
#             return false
#         end
#     end
#     """

#     transition_def = """
#     function transition(m::$name_of_POMDP, s::Int64, a::Int64)

#         prob_val = [m.T[(s,a,sp)] for sp in 1:m.number_of_states]

#         return SparseCat(1:m.number_of_states, prob_val)
#     end

#     transition(m::$name_of_POMDP, s::Int64, a::Int64, sp::Int64) = m.T[(s,a,sp)]
#     """

#     observation_def = """
#     function observation(m::$name_of_POMDP, s::Int64, a::Int64)

#         prob_obs = [m.O[(s, a, obs)] for obs in 1:m.number_of_observations]

#         return SparseCat(1:m.number_of_observations, prob_obs)
#     end

#     observation(m::$name_of_POMDP, s::Int64, a::Int64, obs::Int64) = m.O[(s,a,obs)]
#     """

#     reward_def = """
#     reward(m::$name_of_POMDP, s::Int64, a::Int64, sp::Int64, obs::Int64) = m.R[(s,a,sp,obs)]

#     reward(m::$name_of_POMDP, s::Int64, a::Int64, sp::Int64) = m.R[(s,a,sp,1)]
    
#     reward(m::$name_of_POMDP, s::Int64, a::Int64) = m.R[(s,a,1,1)]
#     """

#     discount_def = """
#     discount(m::$name_of_POMDP) = m.discount
#     """

#     open(name_of_file, "w") do io
#         println(io, packages_def)

#         println(io, struct_def*constructor_def)
#         println(io, states_def*actions_def*obs_def*initial_state_def)
#         println(io, transition_def*observation_def*reward_def)
#         println(io, discount_def)
#     end
# end

