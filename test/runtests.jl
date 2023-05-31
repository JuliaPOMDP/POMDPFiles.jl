using POMDPFiles
using POMDPModels
using Test

pomdp = TigerPOMDP()
write(stdout, pomdp)
f1 = tempname()
f2 = tempname()
download("http://pomdp.org/examples/1d.POMDP", f1)
m1 = read_pomdp(f1)
println(m1.discount == 0.75 && m1.O[1,1,1] == 1.0 && m1.T[1,1,1] == 1.0 && m1.R[1,1] == 1.0)
download("http://pomdp.org/examples/parr95.95.POMDP", f2)
m2 = read_pomdp(f2)
println(m2.discount == 0.95 && m2.O[1,1,1] == 1.0 && m2.T[1,1,2] == 0.5 && m2.R[6,1] == 2.0)