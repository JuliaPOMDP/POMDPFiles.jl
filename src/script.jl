include("./reader.jl")

# file = open(readlines, "./../test/sources/mini-hall2.pomdp") |> remove_comments_and_white_space
# file = open(readlines, "../test/sources/cheng-examples/cheng.D4-1.POMDP") |> remove_comments_and_white_space
file = open(readlines,"./../test/sources/pomdp-ex.pomdp") |> remove_comments_and_white_space
# file = open(readlines, "./../test/sources/parr95.95.pomdp") |> remove_comments_and_white_space
# file = open(readlines, "./../test/sources/fourth.POMDP") |> remove_comments_and_white_space


lines_transition = get_all_occurences(file, "T")
test_preamble, ~ = check_preamble_fields(file)
discount, type_reward, actions, states, observations = processing_preamble(test_preamble)

dic_action = Dict(string(name) => index for (index, name) in enumerate(actions.names_of_actions))
dic_states = Dict(string(name) => index for (index, name) in enumerate(states.names_of_states))

# print(dic_action, "\n")
# print(dic_states, "\n")
# print(file[lines_transition], "\n")

aa = processing_transition_probability(states.number_of_states, actions.number_of_actions, dic_states, dic_action, file[lines_transition[1]:end])

# read_pomdp("./../test/sources/mini-hall2.pomdp")

line = " T : * : cold : plus1 0.5"
line = string.(strip.(split(line, ":")))

temp_str = string.(split(line[4]))
line[4] = ""
line = filter(x -> !isempty(x), line)
map(x -> push!(line, x), temp_str)

print("Finished \n")