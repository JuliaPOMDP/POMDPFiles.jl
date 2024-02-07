include("./reader.jl")

ff = open(readlines, "./../test/sources/bridge-repair.POMDP") |> remove_comments_and_white_space
# ff = open(readlines, "./../test/sources/1d.pomdp") |> remove_comments_and_white_space
# ff = open(readlines, "./../test/sources/bridge-repair.POMDP") |> remove_comments_and_white_space


lines_transition = get_all_occurences(ff, "T")
test_preamble, ~ = check_preamble_fields(ff)
discount, type_reward, actions, states, observations = processing_preamble(test_preamble)

dic_action = Dict(string(name) => index for (index, name) in enumerate(actions.names_of_actions))
dic_states = Dict(string(name) => index for (index, name) in enumerate(states.names_of_states))

 aa = processing_transition_probability(states.number_of_states, actions.number_of_actions, dic_states, dic_action, ff[lines_transition[1]:end])