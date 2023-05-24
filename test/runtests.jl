using POMDPFiles
using POMDPModels
using Test

pomdp = TigerPOMDP()
# write("new.pomdp", pomdp)
m = read_pomdp("new1.pomdp")
