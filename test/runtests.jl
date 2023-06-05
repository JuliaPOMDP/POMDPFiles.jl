using POMDPFiles
using POMDPModels
using Test

pomdp = TigerPOMDP()
write(stdout, pomdp)
write(stdout, pomdp; pretty=true)