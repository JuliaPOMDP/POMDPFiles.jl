include("./reader.jl")

# NEED TO PARSE THESE FILES...

# trans_prob, obs_prob, reward_func, init_state = read_pomdp("./../test/sources/web-mall.POMDP") 
# trans_prob, obs_prob, reward_func, init_state = read_pomdp("./../test/sources/paint.95.POMDP") 
# trans_prob, obs_prob, reward_func, init_state = read_pomdp("./../test/sources/ejs/ejs4.POMDP") 
# trans_prob, obs_prob, reward_func, init_state = read_pomdp("./../test/sources/web-ad.POMDP") 
# trans_prob, obs_prob, reward_func, init_state = read_pomdp("./../test/sources/network.POMDP") 
# trans_prob, obs_prob, reward_func, init_state = read_pomdp("./../test/sources/milos-aaai97.POMDP") 
# trans_prob, obs_prob, reward_func, init_state = read_pomdp("./../test/sources/mcc-example2.POMDP") 
trans_prob, obs_prob, reward_func, init_state = read_pomdp("./../test/sources/mcc-example1.POMDP") 

print("POMDP read! \n\n\n")

