using HTTP, POMDPs, POMDPFiles

mktempdir() do tmp_dir 
    url = "https://www.pomdp.org/examples/mini-hall2.POMDP"
    tmp_file_name = joinpath(tmp_dir, "paint.95.POMDP")
    HTTP.download(url, tmp_file_name)

    pomdp = SWildcardArrayPOMDP(tmp_file_name)
    states(pomdp)
end

