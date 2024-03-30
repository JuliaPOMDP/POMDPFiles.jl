function save_files(cleanup::Bool=true)
    url_source = "http://pomdp.org/examples/"
    data_source = HTTP.get(url_source)
    parsed_web = data_source.body |> String

    parsed_html = parsehtml(parsed_web)
    ss = Selector("a")
    links = eachmatch(ss, parsed_html.root)

    tmp_dir_tar_gz = mktempdir(tempdir(); prefix="POMDPtargz_", cleanup=cleanup)
    tmp_dir_gz = mktempdir(tempdir(); prefix="POMDPgz_", cleanup=cleanup)

    vec_dir_tar_gz = Vector{String}()
    tmp_dir_pomdp = mktempdir(tempdir(); prefix="POMDPfiles_pomdp_", cleanup=cleanup)
    tmp_dir_files_gz = mktempdir(tempdir(); prefix="POMDPfiles_gz_", cleanup=cleanup)

    for link in links
        href = link.attributes["href"]
        if occursin(r".tar.gz$", href)
            complete_url = startswith(href, "http") ? href : url_source * href
        
            println(complete_url)
            regex_getnames = r"/([^/]*?)\.tar\.gz$"

            tmp_file_name = tmp_dir_tar_gz * "/" * match(regex_getnames, complete_url).captures[1] * ".tar.gz"

            HTTP.download(complete_url, tmp_file_name)
            println("Saved tar.gz files in ", tmp_file_name, "\n\n\n")

            tmp_files_tar_gz = mktempdir(tempdir(); prefix="POMDPfiles_tar_gz_", cleanup=cleanup)
            push!(vec_dir_tar_gz, tmp_files_tar_gz)
            println("Extracting files in ", tmp_files_tar_gz, "\n\n\n")

            open(tmp_file_name, "r") do gz_file
                decomp_gz_file = GzipDecompressorStream(gz_file)

                Tar.extract(decomp_gz_file, tmp_files_tar_gz) 
                close(decomp_gz_file)
            end
        end

        if occursin(r".POMDP$", href)
            complete_url = startswith(href, "http") ? href : url_source * href

            regex_getnames = r"/([^/]*?)\.[Pp][Oo][Mm][Dd][Pp]$"
            temp_file_name = tmp_dir_pomdp * "/" * match(regex_getnames, complete_url).captures[1] * ".POMDP"
            HTTP.download(complete_url, temp_file_name)

            println("Saved file: ", temp_file_name, " in ", tmp_dir_pomdp, "\n\n\n")

        end

        if occursin(r"(?<!.tar).gz$", href)
            complete_url = startswith(href, "http") ? href : url_source * href
            println(complete_url)

            regex_getnames = r"/([^/]*?)\.[Pp][Oo][Mm][Dd][Pp]\.gz$"
            tmp_file_name_gz = tmp_dir_gz * "/" * match(regex_getnames, complete_url).captures[1] * ".gz"
            # println(temp_file_name_gz)
            HTTP.download(complete_url, tmp_file_name_gz)

            tmp_file_name = match(regex_getnames, complete_url).captures[1] 
            tmp_file_name = tmp_dir_files_gz * "/" * tmp_file_name * ".POMDP"
            println("Saving in ", tmp_file_name, "\n\n\n")

            open(tmp_file_name_gz, "r") do tmp_file
                # println(tmp_file, "\n\n\n\n")
                decomp_file = GzipDecompressorStream(tmp_file)

                open(tmp_file_name, "w") do tmp_name
                    write(tmp_name, read(decomp_file))
                end
                close(decomp_file)
            end
        end
    end

    return tmp_dir_pomdp, tmp_dir_files_gz, vec_dir_tar_gz

end

function read_pomdp_dir(dir_path::Vector{String})
    file_dir = []

    for dir in dir_path
        temp_file = walkdir(dir)

        for general_struc in temp_file
            for file_names in general_struc[3]
                push!(file_dir,joinpath(general_struc[1],file_names))
            end
        end
    end

    return file_dir
end

function set_individual_tests(nn_individual_tests::Vector{String})
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
    T_tuple_baseball = [(2,7301,7681), (6,7681,7681)]
    T_values_baseball = [0.9, 1]
    T_dict_baseball = Dict(T_tuple_baseball[i] => T_values_baseball[i] for i in eachindex(T_tuple_baseball))

    O_tuple_baseball = [(1,218,4), (3,4017,5)] 
    O_values_baseball = [1, 0]
    O_dict_baseball = Dict(O_tuple_baseball[i] => O_values_baseball[i] for i in eachindex(O_tuple_baseball))

    R_tuple_baseball = [(6,6144,1,1), (6,6145,4,5), (6,6145,1,1)]
    R_values_baseball = [3,4,4]
    R_dict_baseball = Dict(R_tuple_baseball[i] => R_values_baseball[i] for i in eachindex(R_tuple_baseball))
    baseball_dict = Dict("T" => T_dict_baseball, "O" => O_dict_baseball, "R" => R_dict_baseball)

# tiger_95.POMDP: testing all transitions, observations and rewards
    T_tuple_tiger_95 = [(1,1,1), (1,1,2), (1,2,1),(1,2,2), (2,1,1), (2,1,2), (2,2,1), (2,2,2), (3,1,1), (3,1,2), (3,2,1), (3,2,2)]
    T_values_tiger_95 = [1,0,0,1,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5]
    T_dict_tiger_95 = Dict(T_tuple_tiger_95[i] => T_values_tiger_95[i] for i in eachindex(T_tuple_tiger_95))

    O_tuple_tiger_95 = [(1,1,1), (1,1,2), (1,2,1),(1,2,2), (2,1,1), (2,1,2), (2,2,1), (2,2,2), (3,1,1), (3,1,2), (3,2,1), (3,2,2)]
    O_values_tiger_95 = [0.85,0.15,0.15,0.85,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5]
    O_dict_tiger_95 = Dict(O_tuple_tiger_95[i] => O_values_tiger_95[i] for i in eachindex(O_tuple_tiger_95))


    R_tuple_tiger_95 = [(1,1,1,1),(1,2,1,1),(2,1,1,1),(2,2,1,1),(3,1,1,1),(3,2,1,1), (1,1,2,1)]
    R_values_tiger_95 = [-1,-1,-100,10,10,-100,-1]
    R_dict_tiger_95 = Dict(R_tuple_tiger_95[i] => R_values_tiger_95[i] for i in eachindex(R_tuple_tiger_95))
    tiger_95_dict = Dict("T" => T_dict_tiger_95, "O" => O_dict_tiger_95, "R" => R_dict_tiger_95)


    name_to_dic = Dict("mit" => mit_dict, "baseball" => baseball_dict, 
    "tiger.95" => tiger_95_dict, "hallway" => hallway_dict, "bulkhead.A" => bulkhead_A_dict)

    return Dict(name => name_to_dic[name] for name in nn_individual_tests)
end

