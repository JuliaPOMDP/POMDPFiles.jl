using HTTP, Gumbo, Cascadia, CodecZlib, Tar
using POMDPs, POMDPFiles, Test

include("aux_func.jl")

regex_filename = r"/([^/]*?)\.[Pp][Oo][Mm][Dd][Pp]$"

ff_pomdp, ff_gz, ff_tar_gz = save_files(false) 
files_path = [ff_pomdp, ff_gz, ff_tar_gz...]
all_files_path = read_pomdp_dir(files_path) 
max_num = [30000,30000] # max number of states and actions of POMDPs to be tested
    
nn_individual_tests = ["mit", "hallway", "bulkhead.A", "baseball", "tiger.95"]
individual_tests = set_individual_tests(nn_individual_tests) 

problems = ["concert", "ejs1", "ejs2", "ejs4", "ejs5", "ejs6", "ejs7"]

for file_path in all_files_path
    ff_name = match(regex_filename, file_path).captures[1]

    if !isnothing(ff_name) && !(ff_name in problems) 
        @testset "Testing file: $(ff_name)" begin
            pomdp_read = SFilePOMDP(file_path)

            if ff_name in nn_individual_tests 
                for key in keys(individual_tests[ff_name])
                    if isequal(key, "T")
                        @test all([pomdp_read.pomdp.T[k...] == vv for (k,vv) in zip(keys(individual_tests[ff_name]["T"]), values(individual_tests[ff_name]["T"]))])
                    end

                    if isequal(key, "O")
                        @test all([pomdp_read.pomdp.O[k...] == vv for (k,vv) in zip(keys(individual_tests[ff_name]["O"]), values(individual_tests[ff_name]["O"]))])
                    end

                    if isequal(key, "R")
                        @test all([pomdp_read.pomdp.R[k...] == vv for (k,vv) in zip(keys(individual_tests[ff_name]["R"]), values(individual_tests[ff_name]["R"]))])
                    end
                end
            end

            if length(actions(pomdp_read)) <= max_num[1] && length(states(pomdp_read)) <= max_num[2] # change this to test all examples
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