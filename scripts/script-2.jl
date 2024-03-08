using POMDPFiles, OrderedCollections
using POMDPs, D3Trees, ARDESPOT, POMDPTools, POMCPOW  
using BenchmarkTools


function read_pomdp_dir(dir_path::String)
    temp_file = walkdir(dir_path)
    file_dir = []

    for general_struc in temp_file
        for file_names in general_struc[3]
            push!(file_dir,joinpath(general_struc[1],file_names))
        end
    end

    return file_dir
end

# Working:  1d.noisy, 1d, mcc-example1, mcc-example2
# Problem: bulkhead, 


file_path = "./../test/sources/1d.noisy.POMDP"
    
pomdp_read = FilePOMDP(file_path)

s0 = rand(initialstate(pomdp_read))
a0 = rand(actions(pomdp_read))

@time transition(pomdp_read, s0, a0)

hr = HistoryRecorder(max_steps=10000)

@time rhist = simulate(hr, pomdp_read, RandomPolicy(pomdp_read))

nothing