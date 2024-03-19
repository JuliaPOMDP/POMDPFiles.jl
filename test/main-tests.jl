using HTTP, Gumbo, Cascadia, CodecZlib, Tar

url_source = "http://pomdp.org/examples/"
data_source = HTTP.get(url_source)
parsed_web = data_source.body |> String

parsed_html = parsehtml(parsed_web)
ss = Selector("a")
links = eachmatch(ss, parsed_html.root)

temp_dir = mktempdir(tempdir(); prefix="POMDPfiles_", cleanup=false)
temp_dir_tar_gz = mktempdir(tempdir(); prefix="POMDPtargz_", cleanup=false)
temp_dir_gz = mktempdir(tempdir(); prefix="POMDPgz_", cleanup=false)

for link in links
    href = link.attributes["href"]

    # if occursin(r".POMDP$", href)
    #     complete_url = startswith(href, "http") ? href : url_source * href
        
    #     temp_file_name = tempname(temp_dir; cleanup=false)
    #     temp_file_name = temp_file_name * ".POMDP"
        
    #     HTTP.download(complete_url, temp_file_name)
    #     println(temp_file_name)
    # end

    # if occursin(r"(?<!.tar).gz$", href)
    #     complete_url = startswith(href, "http") ? href : url_source * href

    #     temp_file_name_gz = tempname(temp_dir_gz; cleanup=false)
    #     temp_file_name_gz = temp_file_name_gz * ".gz"

    #     HTTP.download(complete_url, temp_file_name_gz)

    #     println(complete_url)

    #     open(temp_file_name_gz, "r") do tmp_file
    #         decomp_file = GzipDecompressorStream(tmp_file)

    #         temp_file_name = tempname(temp_dir; cleanup=false)
    #         temp_file_name = temp_file_name * ".POMDP"

    #         open(temp_file_name, "w") do tmp_name
    #             write(tmp_name, read(decomp_file))
    #         end
    #         close(decomp_file)
    #     end
    # end

    if occursin(r".tar.gz$", href)
        complete_url = startswith(href, "http") ? href : url_source * href

        temp_file_name_targz = tempname(temp_dir_tar_gz; cleanup=false)
        temp_file_name_targz = temp_file_name_targz * ".tar.gz"

        HTTP.download(complete_url, temp_file_name_targz)

        open(temp_file_name_targz, "r") do gz_file
            decomp_gz_file = GzipDecompressorStream(gz_file)

            Tar.extract(decomp_gz_file, temp_dir) do header, src
                if occursin(r".POMDP$", header.path)
                    println(header.path)
                end
                return true 
            end

            close(decomp_gz_file)
        end
    end
end