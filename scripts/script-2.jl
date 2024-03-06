using POMDPFiles, OrderedCollections
using POMDPs, D3Trees, ARDESPOT, POMDPTools, POMCPOW  
using BenchmarkTools

# Working:  1d.noisy, 1d, mcc-example1, mcc-example2
# Problem: bulkhead, 


file_path = "./../test/sources/1d.noisy.POMDP"
    
# TODO: Have this as a constructor

pomdp_read = read_pomdp(file_path)
TT = FilePOMDP(file_path)

println(typeof(initialstate(pomdp_read)))

s0 = rand(initialstate(pomdp_read))
a0 = rand(actions(pomdp_read))

@time transition(pomdp_read, s0, a0)

# solver = DESPOTSolver(bounds=(-20.0, 0.0), tree_in_info=true)
# planner = solve(solver, pomdp_read)
# b0 = initialstate_distribution(pomdp_read)

# a, info = action_info(planner, b0)
# inchrome(D3Tree(info[:tree], init_expand=5))

# pomdp_tiger = TigerPOMDP()
# target_file = tmp[1] * "/txt-files/" * "tiger-2.text"
# write(target_file, pomdp_tiger)

# solver_tt = DESPOTSolver(bounds=(-20.0, 0.0), tree_in_info=true)
# planner_tt = solve(solver_tt, pomdp_tiger)
# b0_tt = initialstate(pomdp_tiger)

# a_tt, info_tt = action_info(planner_tt, b0_tt)
# inchrome(D3Tree(info_tt[:tree], init_expand=5))

# solver = POMCPOWSolver(criterion=MaxUCB(20.0))
# planner = solve(solver, pomdp_read)

hr = HistoryRecorder(max_steps=10000)
# hist = simulate(hr, pomdp_read, planner)
# for (s, b, a, r, sp, o) in hist
#     @show s, a, r, sp
# end

@time rhist = simulate(hr, pomdp_read, RandomPolicy(pomdp_read))
# println("""
#     Cumulative Discounted Reward (for 1 simulation)
#         Random: $(discounted_reward(rhist))
#         POMCPOW: $(discounted_reward(hist))
#     """)

nothing