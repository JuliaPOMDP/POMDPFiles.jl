using POMDPFiles, POMDPModels, OrderedCollections
using POMDPs

############# Setting-up a test dataset ####################
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

dir_path = "./../test/sources/"
all_files_path = read_pomdp_dir(dir_path)

regex_filename = r"^(.*)\.[Pp][Oo][Mm][Dd][Pp]$"

for file_path in all_files_path
    ff_name = match(regex_filename, file_path)

    if !isnothing(ff_name)
        print("\n\n\n", ff_name.captures[1], "\n\n\n")
        target_file = ff_name.captures[1] * ".txt"
        pomdp_read = read_pomdp(file_path)

        tmp = splitdir(target_file)
        target_file = tmp[1] * "/txt-files/" * tmp[2]
        # numericprint(target_file, pomdp_read)
    end
end
