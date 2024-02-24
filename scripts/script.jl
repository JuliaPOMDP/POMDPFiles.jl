
using POMDPFiles, POMDPModels, OrderedCollections
using POMDPs

dir_path = "./../test/sources/"
all_files_path = read_pomdp_dir(dir_path)

regex_filename = r"^(.*)\.[Pp][Oo][Mm][Dd][Pp]$"

for file_path in all_files_path[1:end]
    ff_name = match(regex_filename, file_path)

    if !isnothing(ff_name)
        print("\n\n\n", ff_name.captures[1], "\n\n\n")
        target_file = ff_name.captures[1] * ".txt"
        pomdp_read = read_pomdp(file_path)
        # println(pomdp_read)
        tmp = splitdir(target_file)
        target_file = tmp[1] * "/txt-files/" * tmp[2]

        # numericprint(target_file, pomdp_read)
    end

end









