# Variable-length Argument Tuples -----------------------------------------

### Functions can take a variable number of arguments. A parameter name that ends with `...` gathers arguments into a tuple
function printall(args...)
    println(args)
end

printall(1, 2.0, '3')

### The complement of gather is scatter
t = (7, 3)
divrem(t...)


# Arrays and Tuples -------------------------------------------------------
s = "abc"
t = [1, 2, 3]

for pair in zip(s, t)
    println(pair)
end

arr_tuples = collect(zip(s, t))

### You can use tuple assignment in a for loop to traverse an array of tuples
for (s, t) in arr_tuples
    println("$s --- $t")
end

### If you need to traverse the elements of a sequence and their indices, you can use enumerate
for (index, element) in enumerate("abc")
    println(index, " ", element)
end


# Dictionaries and Tuples -------------------------------------------------
d = Dict('a'=>1, 'b'=>2, 'c'=>3)

for (key, value) in d
    println(key, " ", value)
end


# Exercises ---------------------------------------------------------------
# Exercise 12-1
function sumall(args...)
    sum(args)
end
sumall(1, 2, 3)