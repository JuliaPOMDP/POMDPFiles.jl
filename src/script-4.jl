name_of_variable = "LicioStruct"

julia_code = """struct $name_of_variable 
    name_of_person::String
end

get_name(var::$name_of_variable) = println(var.name_of_person)
"""

file_name = "printing_name_"*"$name_of_variable"*".jl"
open(file_name, "w") do io
    println(io, julia_code)
end