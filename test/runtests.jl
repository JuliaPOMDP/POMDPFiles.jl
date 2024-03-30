using HTTP, Gumbo, Cascadia, CodecZlib, Tar
using POMDPs, POMDPFiles, Test

include("aux_finc.jl")

regex_filename = r"/([^/]*?)\.[Pp][Oo][Mm][Dd][Pp]$"

ff_pomdp, ff_gz, ff_tar_gz = save_files(false) 
files_path = [ff_pomdp, ff_gz, ff_tar_gz...]
all_files_path = read_pomdp_dir(files_path) 
max_num = [30,30]

problems = ["concert", "ejs1", "ejs2", "ejs4", "ejs5", "ejs6", "ejs7"]

for file_path in all_files_path
    ff_name = match(regex_filename, file_path)

    if !isnothing(ff_name) && !(ff_name.captures[1] in problems) 
        @testset "Testing file: $ff_name" begin
            pomdp_read = SFilePOMDP(file_path)

            if length(actions(pomdp_read)) <= max_num[1] && length(states(pomdp_read)) <= max_num[2]
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