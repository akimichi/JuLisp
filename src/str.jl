struct Str <: Object
    content::String
end

function str(content::String)
  Str(content)
end

function show(io::IO, str::Str)
  print(io, "\'$(str.content)\'")
end

value(str::Str) = str.content


