include("./reader.jl")

# ff = open(readlines, "./../test/sources/bridge-repair.POMDP") |> remove_comments_and_white_space
# ff = open(readlines, "./../test/sources/1d.pomdp") |> remove_comments_and_white_space
trans_prob, obs_prob, reward_func = read_pomdp("./../test/sources/pomdp-ex.pomdp") 
# trans_prob, obs_prob, reward_func = read_pomdp("./../test/sources/fourth.POMDP") 

print("POMDP read! \n\n\n")

