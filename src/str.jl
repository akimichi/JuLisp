struct Str <: Object
    content::String
end

function str(content::String)
  Str(content)
end

mkString(n::Str) = n.content
show(io::IO, str::Str) = print(io, str.content)
value(str::Str) = str.content


