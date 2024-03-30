using HTTP, Gumbo, Cascadia, CodecZlib, Tar
using POMDPs, POMDPFiles

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


regex_filename = r"/([^/]*?)\.[Pp][Oo][Mm][Dd][Pp]$"

ff_pomdp, ff_gz, ff_tar_gz = save_files(false) 
files_path = [ff_pomdp, ff_gz, ff_tar_gz...]
all_files_path = read_pomdp_dir(files_path) 

problems = ["concert", "ejs1", "ejs2", "ejs4", "ejs5", "ejs6", "ejs7"]

for file_path in all_files_path
    ff_name = match(regex_filename, file_path)
    # println(ff_name)

    # println(ff_name.captures[0])

    if !isnothing(ff_name) && !(ff_name.captures[1] in problems) 
        print("\n\n\n", ff_name.captures[1], "\n\n\n")
        target_file = ff_name.captures[1] * ".txt"
        pomdp_read = read_pomdp(file_path)
    end
end

nothing