using POMDPFiles, POMDPModels, OrderedCollections

using POMDPs

regex_filename = r"^(.*)\.[Pp][Oo][Mm][Dd][Pp]$"
file_path = "./../test/sources/bridge-repair.POMDP"
    
ff_name = match(regex_filename, file_path)

target_file = ff_name.captures[1] * ".txt"
tmp = splitdir(target_file)
target_file = tmp[1] * "/txt-files/" * tmp[2]

pomdp_read=  read_pomdp(file_path)

numericprint(target_file, pomdp_read)

print("POMDP read! \n\n\n")

