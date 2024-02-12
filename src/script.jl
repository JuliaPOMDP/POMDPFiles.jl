using Base.Filesystem
using Test

include("./reader.jl")

dir_path = "./../test/sources/"
all_files_path = reading_pomdp_dir(dir_path)

# print(all_files_path, "\n\n\n")

for file_path in all_files_path
    print("\n\n\n", file_path, "\n\n\n")

    read_pomdp(file_path)
end








