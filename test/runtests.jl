using HTTP, Gumbo, Cascadia, CodecZlib, Tar
using POMDPs, POMDPFiles, Test

include("aux_func.jl")

regex_filename = r"/([^/]*?)\.[Pp][Oo][Mm][Dd][Pp]$"

ff_pomdp, ff_gz, ff_tar_gz = save_files(false) 
files_path = [ff_pomdp, ff_gz, ff_tar_gz...]
all_files_path = read_pomdp_dir(files_path) 
max_num = [50,50]

# nn_indivual_test = ["mit", "aloha.30", "baseball", "tiger.95", "hallway", "bulkhead"]
nn_indivual_test = ["mit", "hallway"]

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

name_to_dic = Dict("mit" => mit_dict, "aloha.30" => "aloha30_dict", "baseball" => "baseball_dict", 
    "tiger.95" => "tiger95_dict", "hallway" => hallway_dict, "bulkhead" => "bulkhead_dict")
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