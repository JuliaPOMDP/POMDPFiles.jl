using POMDPFiles
using POMDPModels
using Test

pomdp = TigerPOMDP()
write(stdout, pomdp)
m1 = read_pomdp("1d.pomdp")
m2 = read_pomdp("parr95.95.pomdp")
