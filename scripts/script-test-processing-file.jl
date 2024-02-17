
include("../src/reader.jl")

filename = "../test/sources/bridge-repair.POMDP"
    
lines = open(readlines, filename) |> remove_comments_and_white_space

discount_regex = r"\s*discount\s*:"

indices_disc = findfirst(startswith.(lines, discount_regex))

trans_expr =  r"\s*T\s*:"
obs_expr =  r"\s*O\s*:"
values_expr = r"\s*R\s*:"

indices_T = findall(startswith.(lines, trans_expr))
indices_O = findall(startswith.(lines, obs_expr))
indices_R = findall(startswith.(lines, values_expr))

# println(lines[indices_T])
# println(lines[indices_O])
# println(lines[indices_R])

aa = check_preamble_fields(lines[1:end])
