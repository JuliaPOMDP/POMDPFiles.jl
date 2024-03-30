using HTTP, Gumbo, Cascadia, CodecZlib, Tar
using POMDPs, POMDPFiles, Test

include("aux_func.jl")

regex_filename = r"/([^/]*?)\.[Pp][Oo][Mm][Dd][Pp]$"

ff_pomdp, ff_gz, ff_tar_gz = save_files(false) 
files_path = [ff_pomdp, ff_gz, ff_tar_gz...]
all_files_path = read_pomdp_dir(files_path) 
max_num = [50,50]

# nn_indivual_test = ["mit", "baseball", "tiger.95", "hallway", "bulkhead"]
nn_indivual_test = ["mit", "hallway", "bulkhead.A", "baseball"]

## mit.pomdp tests set-up
    #   3 semicolon 
    T_tuple_mit = [(1,52,92), (2, 55, 54), (4,  161, 161), (3, 66, 68)]  
    T_values_mit = [0.01, 0.9, 1, 0.05]
    T_dict_mit = Dict(T_tuple_mit[i] => T_values_mit[i] for i in eachindex(T_tuple_mit))

    O_tuple_mit = [(1,7,5), (2, 75, 17), (4, 203, 8)] 
    O_values_mit = [0.121500, 0.056700, 0.002250] 
    O_dict_mit = Dict(O_tuple_mit[i] => O_values_mit[i] for i in eachindex(O_tuple_mit))

    # 4 semicolon with wildcards
    R_tuple_mit = [(4, 185, 2, 3), (4, 185, 1, 1), (4, 169, 1, 1)] 
    R_values_mit = [-1, -1,  1] 
    R_dict_mit = Dict(R_tuple_mit[i] => R_values_mit[i] for i in eachindex(R_tuple_mit))

    mit_dict = Dict("T" => T_dict_mit, "O" => O_dict_mit, "R" => R_dict_mit)

# hallway.POMDP tests set-up
    T_tuple_hallway = [(1,1,1), (3, 1, 2)] 
    T_values_hallway = [1, 0.7]   
    T_dict_hallway = Dict(T_tuple_hallway[i] => T_values_hallway[i] for i in eachindex(T_tuple_hallway))

    # 3 semicolon with vector of probabilities
    O_tuple_hallway = [(3,1,4), (5,28,1), (4, 57, 21), (2, 60, 1)] 
    O_values_hallway = [0.076949, 0.085737, 1, 0] 
    O_dict_hallway = Dict(O_tuple_hallway[i] => O_values_hallway[i] for i in eachindex(O_tuple_hallway))

    # 4 semicolon with wildcards
    R_tuple_hallway = [(1,1,1,1), (4, 30, 57, 20)] 
    R_values_hallway = [0, 1] 
    R_dict_hallway = Dict(R_tuple_hallway[i] => R_values_hallway[i] for i in eachindex(R_tuple_hallway))
    hallway_dict = Dict("T" => T_dict_hallway, "O" => O_dict_hallway, "R" => R_dict_hallway)

# bulkhead_A.POMDP tests set-up
    # Values given by transition probabilities and wild cards 
    T_tuple_bulkhead_A = [(4,1,4), (4, 4, 1), (4,5,8), (6,1,10), (1,2,2), (1,3,3), (2,1,2)] 
    T_values_bulkhead_A = [0.97, 0, 0.98, 1, 1, 1, 0]   
    T_dict_bulkhead_A = Dict(T_tuple_bulkhead_A[i] => T_values_bulkhead_A[i] for i in eachindex(T_tuple_bulkhead_A))

    # Values given by transition probabilities and wild cards 
    O_tuple_bulkhead_A = [(3,1,1), (3,9,4), (3,9,6), (5,1,1)] 
    O_values_bulkhead_A = [0,0.25,0.75, 1]
    O_dict_bulkhead_A = Dict(O_tuple_bulkhead_A[i] => O_values_bulkhead_A[i] for i in eachindex(O_tuple_bulkhead_A))

    # 4 semicolon with wildcards
    R_tuple_bulkhead_A = [(5,7,2,1), (5,1,4,5)]
    R_values_bulkhead_A = [45000, -15000]
    R_dict_bulkhead_A = Dict(R_tuple_bulkhead_A[i] => R_values_bulkhead_A[i] for i in eachindex(R_tuple_bulkhead_A))
    bulkhead_A_dict = Dict("T" => T_dict_bulkhead_A, "O" => O_dict_bulkhead_A, "R" => R_dict_bulkhead_A)

# baseball.POMDP: only due to ir being a large file. The way transitions are specified are "boring" and have been extensively tested with the previous examples
    # Values given by transition probabilities and wild cards 
    T_tuple_baseball = [(2,7301,7681), (6,7681,7681)]
    T_values_baseball = [0.9, 1]
    T_dict_baseball = Dict(T_tuple_baseball[i] => T_values_baseball[i] for i in eachindex(T_tuple_baseball))

    # Values given by transition probabilities and wild cards 
    O_tuple_baseball = [(1,218,4), (3,4017,5)] 
    O_values_baseball = [1, 0]
    O_dict_baseball = Dict(O_tuple_baseball[i] => O_values_baseball[i] for i in eachindex(O_tuple_baseball))

    # 4 semicolon with wildcards
    R_tuple_baseball = [(6,6144,1,1), (6,6145,4,5), (6,6145,1,1)]
    R_values_baseball = [3,4,4]
    R_dict_baseball = Dict(R_tuple_baseball[i] => R_values_baseball[i] for i in eachindex(R_tuple_baseball))
    baseball_dict = Dict("T" => T_dict_baseball, "O" => O_dict_baseball, "R" => R_dict_baseball)

# tiger_95.POMDP
    # Values given by transition probabilities and wild cards 
    T_tuple_tiger_95 = []
    T_values_tiger_95 = []
    T_dict_tiger_95 = Dict(T_tuple_tiger_95[i] => T_values_tiger_95[i] for i in eachindex(T_tuple_tiger_95))

    # Values given by transition probabilities and wild cards 
    O_tuple_tiger_95 = []
    O_values_tiger_95 = []
    O_dict_tiger_95 = Dict(O_tuple_tiger_95[i] => O_values_tiger_95[i] for i in eachindex(O_tuple_tiger_95))

    # 4 semicolon with wildcards
    R_tuple_tiger_95 = []
    R_values_tiger_95 = []
    R_dict_tiger_95 = Dict(R_tuple_tiger_95[i] => R_values_tiger_95[i] for i in eachindex(R_tuple_tiger_95))
    tiger_95_dict = Dict("T" => T_dict_tiger_95, "O" => O_dict_tiger_95, "R" => R_dict_tiger_95)


name_to_dic = Dict("mit" => mit_dict, "baseball" => baseball_dict, 
    "tiger.95" => "tiger95_dict", "hallway" => hallway_dict, "bulkhead.A" => bulkhead_A_dict)
individual_test = Dict(name => eval(name_to_dic[name]) for name in nn_indivual_test) 

problems = ["concert", "ejs1", "ejs2", "ejs4", "ejs5", "ejs6", "ejs7"]

for file_path in all_files_path
    ff_name = match(regex_filename, file_path).captures[1]

    if !isnothing(ff_name) && !(ff_name in problems) 
        @testset "Testing file: $(ff_name)" begin
            pomdp_read = SFilePOMDP(file_path)

            if ff_name in nn_indivual_test
                for key in keys(individual_test[ff_name])
                    if isequal(key, "T")
                        println(ff_name)
                        println(individual_test[ff_name]["T"])
                        @test all([pomdp_read.pomdp.T[k...] == vv for (k,vv) in zip(keys(individual_test[ff_name]["T"]), values(individual_test[ff_name]["T"]))])
                    end

                    if isequal(key, "O")
                        println(ff_name)
                        println(individual_test[ff_name]["O"])
                        @test all([pomdp_read.pomdp.O[k...] == vv for (k,vv) in zip(keys(individual_test[ff_name]["O"]), values(individual_test[ff_name]["O"]))])
                    end

                    if isequal(key, "R")
                        println(ff_name)
                        println(individual_test[ff_name]["R"])
                        @test all([pomdp_read.pomdp.R[k...] == vv for (k,vv) in zip(keys(individual_test[ff_name]["R"]), values(individual_test[ff_name]["R"]))])
                    end
                end
            end

            if length(actions(pomdp_read)) <= max_num[1] && length(states(pomdp_read)) <= max_num[2]
                if !isempty(pomdp_read.pomdp.support_initialstate)
                    prob = [val.second for val in initialstate(pomdp_read)]
                    @test POMDPFiles.test_if_probability(prob)
                end
                
                for s in states(pomdp_read) 
                    for a in actions(pomdp_read)
                        prob = [pomdp_read.pomdp.T[a,s, sp] for sp in states(pomdp_read)]
                        @test POMDPFiles.test_if_probability(prob)
                        
                        prob = [pomdp_read.pomdp.O[a,s, o] for o in observations(pomdp_read)]
                        @test POMDPFiles.test_if_probability(prob)  
                    end
                end
            end
        end
    end
end