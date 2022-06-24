using Dates

export date, today

struct DateType <: Object
    value::Date
end

function date(string::String)::DateType
  date = Date(string, DateFormat("y-m-d"))
  DateType(date)
end

function show(io::IO, date::DateType) 
  print(io,Dates.format(date.value, "@yyyy-mm-dd"))
end

value(date::DateType) = date.value
today() = DateType(Dates.today())


