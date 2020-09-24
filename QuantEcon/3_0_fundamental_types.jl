using LinearAlgebra, Statistics

# arrays ------------------------------------------------------------------
a = [1.0, 2.0, 3.0]
typeof(a)
ndims(a)
size(a)

# Vector and Matrix are just aliases for one- and two-dimensional arrays respectively
Array{Int64, 1} == Vector{Int64}
Array{Int64, 2} == Matrix{Int64}

[1, 2, 3] == [1; 2; 3]  # both column vectors
[1 2 3]  # a row vector is 2-dimensional

# creating arrays
zeros(3)
zeros(2, 2)
fill(5.0, 2, 2)    # To return an array filled with a single value, use fill

# empty array
x = Array{Float64}(undef, 2, 2)

# if you need more control over the types, fill with a non-floating point
fill(0, 2, 2)
fill(false, 2, 2)

# note that assignment in Julia binds a name to a value, but does not make a copy of that type
x = [1, 2, 3]
y = x
y[1] = 2
x

# to copy the data, you need to be more explicit
x = [1, 2, 3]
y = copy(x)
y[1] = 2
x

# rather than making a copy of x, you may want to just have a similarly sized array
x = [1, 2, 3]
y = similar(x)
y

# manual definitions
a = [10 20; 30 40]  # 2 x 2
a = [10 20 30 40]'  # transpose


# array indexing ----------------------------------------------------------
a = [10 20 30 40]
a[end-1]

# 2d arrays
a = randn(2, 2)
a[1, 1]
a[1, :]  # first row
a[:, 1]  # first column

# Booleans can be used to extract elements
b = [true false; false true]
a[b]

# some elements of an array can be set equal to one number using slice notation
a = zeros(4)
a[2:end] .= 42
a


# special arrays ----------------------------------------------------------
d = [1.0, 2.0]
a = Diagonal(d)

typeof(a)    # not a 2-dimensional array.

# acts as a normal matrix
2a
b = rand(2,2)
b * a

# identity matrix
I
b * I
typeof(I)


# assignment and passing arrays -------------------------------------------
function f(x)
    return [1 2; 3 4] * x # matrix * column vector
end

val = [1, 2]
y = similar(val)

function f!(out, x)
    out .= [1 2; 3 4] * x
end

f!(y, val)
y

### Note: functions which modify any of the arguments (in-place) have the name ending with !


# operations on arrays ----------------------------------------------------
a = [-1, 0, 1]

@show length(a)
@show sum(a)
@show mean(a)
@show std(a)      # standard deviation
@show var(a)      # variance
@show maximum(a)
@show minimum(a)
@show extrema(a)  # (mimimum(a), maximum(a))


b = sort(a, rev = true)  # returns new array, original not modified

a
sort!(a, rev = true)  # returns *modified original* array
a

# matrix algebra
a = ones(1, 2)
b = ones(2, 2)

a * b
b * a'

# to solve the linear system AX=B for X use A \ B
A = [1 2; 2 3]
B = ones(2, 2)

# the first one is numerically more stable and should be preferred in most cases.
A \ B
inv(A) * B

# for inner product
dot(ones(2), ones(2))
ones(2) ⋅ ones(2)


# element-wise operations -------------------------------------------------
ones(2, 2) .* ones(2, 2)   # element by element multiplication
A .^ 2                     # square every element

x = [1, 2]
x .+ 1     # not x + 1
x .- 1     # not x - 1

# comparisons
a = [10, 20, 30]
b = [-100, 0, 100]

b .> a
a .== b
b .> 1

# useful for conditional extraction
a = randn(4)
a[a .< 0]


# changing dimensions -----------------------------------------------------
a = [10, 20, 30, 40]
b = reshape(a, 2, 2)

# CAUTION: changing the data in the new array will modify the data in the old one
b[1, 2] = 0
a

# to collapse an array along one dimension you can use dropdims()
a = [1 2 3 4]  # two dimensional
dropdims(a, dims = 1)


# broadcasting functions --------------------------------------------------
log.(1:4) == [ log(x) for x in 1:4 ]


# linear algebra ----------------------------------------------------------
A = [1 2; 3 4]

det(A)
tr(A)
eigvals(A)
rank(A)


# ranges ------------------------------------------------------------------
a = 10:12        # a range, equivalent to 10:1:12

# ranges act as vectors
b = Diagonal([1.0, 2.0, 3.0])
b * a .- [1.0; 2.0; 3.0]

# ranges can also be created with floating point numbers using the same notation.
a = 0.0:0.1:1.0  # 0.0, 0.1, 0.2, ... 1.0

# evenly space points where the maximum value is important
maxval = 1.0
minval = 0.0
numpoints = 10
a = range(minval, maxval, length = numpoints)
maximum(a) == maxval


# tuples and named tuples -------------------------------------------------
t = (1.0, "test")
t[1]            # access by index
a, b = t        # unpack
println("a = $a and b = $b")

# named tuples
t = (val1 = 1.0, val2 = "test")
t[1]
println("val1 = $(t.val1) and val2 = $(t.val2)")

# manipulate tuples
t2 = (val3 = 4, val4 = "test!!")
t3 = merge(t, t2)  # new tuple

# named tuples are a convenient and high-performance way to manage and unpack sets of parameters
using Parameters

function f(parameters)
    @unpack α, β = parameters   # better than α, β = parameters.α, parameters.β
    return α + β
end

parameters = (α = 0.1, β = 0.2)
f(parameters)

# in order to manage default values, use the @with_kw macro
paramgen = @with_kw (α = 0.1, β = 0.2)

# creates named tuples, replacing defaults
paramgen()         # calling without arguments gives all defaults
paramgen(α = 0.2)
paramgen(α = 0.2, β = 0.5)


# nothing, missing, and unions --------------------------------------------
typeof(nothing)

# you can return a nothing from a function to indicate that it did not calculate as expected
function f(x)
    x > 0.0 ? sqrt(x) : nothing     # if x > 0.0, yes = sqrt(x), no = nothing
end

# the return type is an example of a union, where the result could be one of an explicit set of types
f(1.0), f(-2.0)

# nothing is a good way to indicate an optional parameter in a function
function f(x; z = nothing)

    if isnothing(z)
        println("No z given with $x")
    else
        println("z = $z given with $x")
    end
end

f(1.0)
f(1.0, z=3.0)


# exceptions --------------------------------------------------------------
try sqrt(-1.0); catch err; err end

# try block
function f(x)
    try
        sqrt(x)
    catch err                # enters if exception thrown
        sqrt(complex(x, 0))  # convert to complex number
    end
end

f(0.0)
f(-1.0)


# missing -----------------------------------------------------------------
# missing propagates through other function calls 
@show missing + 1.0
@show missing * 2
@show missing * "test"
@show mean(x);

@show x == missing

# if you want to calculate a value without the missing values, you can use skipmissing.
x = [1.0, missing, 2.0, missing, missing, 5.0]

mean(x)
mean(skipmissing(x))
coalesce.(x, 0.0)  # replace missing with 0.0

