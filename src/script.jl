using Base.Filesystem
using Test

include("./reader.jl")

dir_path = "./../test/sources/"
all_files_path = reading_pomdp_dir(dir_path)

# print(all_files_path, "\n\n\n")

for file_path in all_files_path
    file = open(readlines, file_path) |> remove_comments_and_white_space
    
    lines_transition = get_all_occurences(file, "T")
    test_preamble, ~ = check_preamble_fields(file)
    discount, type_reward, actions, states, observations = processing_preamble(test_preamble)

    dic_action = Dict(string(name) => index for (index, name) in enumerate(actions.names_of_actions))
    dic_states = Dict(string(name) => index for (index, name) in enumerate(states.names_of_states))

    aa = processing_transition_probability(states.number_of_states, actions.number_of_actions, dic_states, dic_action, file[lines_transition[1]:end])
end
