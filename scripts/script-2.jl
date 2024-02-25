using POMDPFiles, POMDPModels, OrderedCollections
using POMDPs, D3Trees, ARDESPOT, POMDPTools, POMCPOW  

# regex_filename = r"^(.*)\.[Pp][Oo][Mm][Dd][Pp]$"
file_path = "./../test/sources/1d.noisy.POMDP"
    
# ff_name = match(regex_filename, file_path)

# target_file = ff_name.captures[1] * ".txt"
# tmp = splitdir(target_file)
# target_file = tmp[1] * "/txt-files/" * tmp[2]

pomdp_read = read_pomdp(file_path)

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

solver = POMCPOWSolver(criterion=MaxUCB(20.0))
planner = solve(solver, pomdp_read)

hr = HistoryRecorder(max_steps=30)
hist = simulate(hr, pomdp_read, planner)
for (s, b, a, r, sp, o) in hist
    @show s, a, r, sp
end

rhist = simulate(hr, pomdp_read, RandomPolicy(pomdp_read))
println("""
    Cumulative Discounted Reward (for 1 simulation)
        Random: $(discounted_reward(rhist))
        POMCPOW: $(discounted_reward(hist))
    """)

