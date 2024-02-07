using Base.Filesystem
using Test

include("./reader.jl")

dir_path = "./../test/sources/"
all_files_path = reading_pomdp_dir(dir_path)

# print(all_files_path, "\n\n\n")

# for file_path in all_files_path
#     ff = open(readlines, file_path) |> remove_comments_and_white_space

#     print(file_path, "\n\n")
#     # print(file[1:10], "\n\n")
    
#     lines_transition = get_all_occurences(ff, "T")
#     test_preamble, ~ = check_preamble_fields(ff)
#     discount, type_reward, actions, states, observations = processing_preamble(test_preamble)

#     dic_action = Dict(string(name) => index for (index, name) in enumerate(actions.names_of_actions))
#     dic_states = Dict(string(name) => index for (index, name) in enumerate(states.names_of_states))

#     # @test aa = processing_transition_probability(states.number_of_states, actions.number_of_actions, dic_states, dic_action, ff[lines_transition[1]:end])
# end

ff = open(readlines, "./../test/sources/bridge-repair.POMDP") |> remove_comments_and_white_space
ff = open(readlines, "./../test/sources/1d.pomdp") |> remove_comments_and_white_space
# ff = open(readlines, "./../test/sources/bridge-repair.POMDP") |> remove_comments_and_white_space


lines_transition = get_all_occurences(ff, "T")
test_preamble, ~ = check_preamble_fields(ff)
discount, type_reward, actions, states, observations = processing_preamble(test_preamble)

dic_action = Dict(string(name) => index for (index, name) in enumerate(actions.names_of_actions))
dic_states = Dict(string(name) => index for (index, name) in enumerate(states.names_of_states))

# key_fields = ["discount", "values", "states", "actions", "observations"]
# dict_scanning = Dict(field => get_first_occurence(file, field) for field in key_fields)
# sorted_fields = sort(collect(pairs(dict_scanning)), by=x->x[2])

# check_preamble_fields(file)







