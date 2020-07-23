using LinearAlgebra, Statistics

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
x = ("foo", "bar")
y = ("foo", 2)

typeof(x), typeof(y)


