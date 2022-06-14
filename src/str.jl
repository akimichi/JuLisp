struct Str <: Object
    content::String
end

function str(content::String)
  Str(content)
end

show(io::IO, str::Str) = print(io, str.content)
value(str::Str) = str.content


