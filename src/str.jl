struct Str <: Object
    content::String
end

function string(content::String)
  Str(content)
end
show(io::IO, str::Str) = print(io, str.content)


evaluate(str, env::Env) = str
