using Printf, POMDPs
using  POMDPXFiles 

include("./reader.jl")
include("./writer.jl")

# NEED TO PARSE THESE FILES...

dd, s, a, o, trans_prob, obs_prob, reward_func, init_state = read_pomdp("./../test/sources/mcc-example1.POMDP") 

name_POMDP = "MCCExFirst"

generate_julia_pomdp_struct("./../pomdp-files/mmc-example1.jl", name_POMDP)

include("../pomdp-files/mmc-example1.jl")

aa = MCCExFirst(s, a, o, init_state, dd, trans_prob, obs_prob, reward_func)

print("POMDP read! \n\n\n")

