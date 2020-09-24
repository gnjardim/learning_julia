using LinearAlgebra, Statistics, Random

# primitive data types ----------------------------------------------------
# Bool
typeof(false)

# Numerics
x, y = 2, 1.0

typeof(x), typeof(y)
@show 2x + y

x = 1 + 2im
typeof(x)

# String
x = "foobar"
typeof(x)

println("x = $x")


# working with strings ----------------------------------------------------
s = "Charlie don't surf"
split(s)
replace(s, "surf" => "ski")

strip(" foobar ")  # remove trailing whitespace
match(r"(\d+)", "Top 10")  # find digits in string through regex


# containers --------------------------------------------------------------
# tuples (immutable)
x = ("foo", "bar") 
y = ("foo", 2)

typeof(x), typeof(y)

word, val = y
println("word = $word, val = $val")

# sequences
x = [10, 20, 30, 40]
x[end]
x[end - 1]
x[1:3]
x[2:end]

# slicing also works with strings
"foobar"[3:end]

# dictionaries
## unlike in Python, dictionaries are rarely the right approach
d = Dict("name" => "Frodo", "age" => 33)
d["age"]

keys(d), values(d) 


# iterating --------------------------------------------------------------
actions = ["surf", "ski"]
for action in actions
    println("Charlie doesn't $action")
end

x_values = 1:5
for x in x_values
    println(x * x)
end

# functional-style
countries = ("Japan", "Korea", "China")
cities = ("Tokyo", "Seoul", "Beijing")

for (country, city) in zip(countries, cities)   # zip is used for stepping through pairs from two sequences
    println("The capital of $country is $city")
end

# enumerate
for (i, country) in enumerate(countries)
    city = cities[i]
    println("The capital of $country is $city")
end

# comprehensions
doubles = [ 2i for i in 1:4 ]

animals = ["dog", "cat", "bird"]
plurals = [ animal * "s" for animal in animals ]

array = [ i + j for i in 1:3, j in 4:6 ]

named_tuple = [ (num = i, animal = j) for i in 1:2, j in animals]

# generators
xs = 1:10000
f(x) = x^2

sum(f.(xs))
sum(f(x) for x in xs)    # compute sum without temporary arrays


# comparisons -------------------------------------------------------------
1 != 3
1 == 2

true && false
true || false


# functions ---------------------------------------------------------------
f(x) = sin(1 / x)
x -> sin(1 / x)

map(x -> sin(1 / x), randn(3))  # apply function to each element


# optional arguments
f(x, a = 1) = exp(cos(a * x))   # default values

# keyword arguments
f(x; a = 1) = exp(cos(a * x))  # note the ; in the definition
f(pi, a = 2)


# broadcasting ------------------------------------------------------------
function chisq(k)
    @assert k > 0
    z = randn(k)
    return sum(z -> z^2, z)  # same as `sum(x^2 for x in z)`
end

chisq.([2, 4, 6])

x = 1.0:1.0:5.0
y = [2.0, 4.0, 5.0, 6.0, 8.0]
z = similar(y)
z .= x .+ y .- sin.(x)

# equivalently
@. z = x + y - sin(x)

# with scalars
f(x, y) = x + y

a = [1 2 3]
b = [4 5 6]
@show f.(a, b) # across both
@show f.(a, 2); # fix scalar for second

# you may use Ref to fix a function parameter you do not want to broadcast over
f(x, y) = dot([1, 2, 3], x) + y 
f([3, 4, 5], 2)              # uses vector as first parameter
f.(Ref([3, 4, 5]), [2, 3])   # broadcasting over 2nd parameter, fixing first


# scoping and closures ----------------------------------------------------
a = 0.2
f(x) = a * x^2     # refers to the `a` in the outer scope
f(1)               # univariate function

# higher-order functions
twice(f, x) = f(f(x))  # applies f to itself twice

f(x) = x^2
@show twice(f, 2.0)

a = 5
g(x) = a * x
@show twice(g, 2.0);

# example of other higher-order functions
using Expectations, Distributions

f(x) = x^2

d = Exponential(2.0)
@show expectation(f, d);  # E(f(x))

d = Normal()
@show expectation(f, d);  # E(f(x))

# function that returns a closure
function multiplyit(a, g)
    return x -> a * g(x)  # function with `g` used in the closure
end

f(x) = x^2
h = multiplyit(2.0, f)    # h is a function 2 * (x^2)
h(2)


# loop scoping ------------------------------------------------------------
dval2 = 0  # introduces variables
for i in 1:2   # introduces local i
    dval2 = i  # refers to outer variable
end

dval2 # still can't refer to `i`