struct LicioStruct 
    name_of_person::String
end

get_name(var::LicioStruct) = println(var.name_of_person)

