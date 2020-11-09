# Catching Exceptions
try
    fin = open("bad_file.txt")
catch exc
    println("Something went wrong: $exc")
end

f = open("output.txt")
try
    line = readline(f)
    println(line)
finally
    close(f)
end
