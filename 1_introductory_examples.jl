# packages ----------------------------------------------------------------
using LinearAlgebra, Random, Statistics, Plots


# examples ----------------------------------------------------------------
# single draw from a normal distibution with mean 0 and variance 1
randn()

# set number of draws and plot white noise series
n = 100
epsilon = randn(n)
plot(1:n, epsilon)   # sequence from 1 to n (x-axis); epsilon values (y-axis)

# check the type of variable epsilon
typeof(epsilon)

# subset the array (array indices start at 1)
epsilon[1:5]
epsilon[20:30]
epsilon[end]


# other types of variables ------------------------------------------------
a = 1//2
typeof(a)

M = [1 2; 3.5 4]
typeof(M)


# for loops ---------------------------------------------------------------
# poor style
n = 100
epsilon = zeros(n)
for i = 1:n               # or i in 1:n
    epsilon[i] = randn()
end

# better style (eachindex(epsilon) returns an iterator of indices which can be used to access epsilon)
n = 100
epsilon = zeros(n)
for i in eachindex(epsilon)
    epsilon[i] = randn()
end

# you can also loop directly over arrays themselves
e_sum = 0.0
m = 5
for e_val in epsilon[1:m]
    global e_sum += e_val
end

e_mean = e_sum / m
isapprox(e_mean, mean(epsilon[1:m]))


# functions ---------------------------------------------------------------
# poor style
function generatedata(n)
    eps = zeros(n)
    for i in eachindex(eps)
        eps[i] = (randn()) ^ 2 # squaring the result
    end
    return eps
end

data = generatedata(10)
plot(data)


# better style
function generatedata(n)
    eps = randn(n)    # use vectorized function
    return eps.^2     # we can broadcast the ^2 by using .
 end

 data = generatedata(5)


# one line function
generatedata(n) = randn(n).^2
data = generatedata(5)


# we can broadcast any function
f(x) = x^2
generatedata(n) = f.(randn(n))  # uses broadcast for some function `f`
data = generatedata(5)


# we can make the generatedata function able to generically apply to a function
generatedata(n, func) = func.(randn(n))    # uses broadcast for some function `func`
f(x) = x^2
data = generatedata(5, f)    # applies f


# direct solution with broadcasting, and small user-defined function
n = 100
f(x) = x^2

x = randn(n)
plot(f.(x), label="x^2")
plot!(x, label="x")     # layer on the same plot


# more functions ----------------------------------------------------------
using Distributions

# functions in Julia can have different behavior depending on the particular arguments that they’re passed
function plothistogram(distribution, n)
    eps = rand(distribution, n)  # n draws from given distribution
    histogram(eps)
end

lp = Laplace()
plothistogram(lp, 500)


# while loops -------------------------------------------------------------
function fixedpointmap(f, iv, tolerance = 1E-7, maxiter = 1000)
    
    x_old = iv    # initial value
    normdiff = Inf
    iter = 1

    while normdiff > tolerance && iter <= maxiter
        x_new = f(x_old)    # use the passed in map
        normdiff = norm(x_new - x_old)
        x_old = x_new
        iter = iter + 1
    end

    return (value = x_old, normdiff = normdiff, iter = iter) # A named tuple
end

# define a map and parameters
p = 1.0
beta = 0.9
f(v) = p + beta * v

sol = fixedpointmap(f, 0.8)
println("Fixed point = $(sol.value), and |f(x) - x| = $(sol.normdiff) in $(sol.iter) iterations")

# try with other map
r = 2.0
f(x) = r * x * (1 - x)

sol = fixedpointmap(f, 0.8)
println("Fixed point = $(sol.value), and |f(x) - x| = $(sol.normdiff) in $(sol.iter) iterations")


# use package for solving fixed point -------------------------------------
using NLsolve

p = 1.0
beta = 0.9
f(v) = p .+ beta * v   # NLsolve library only accepts vector based inputs (.)

sol = fixedpoint(f, [0.8])
println("Fixed point = $(sol.zero), and |f(x) - x| = $(norm(f(sol.zero) - sol.zero)) in $(sol.iterations) iterations")

# or using anonymous function
sol = fixedpoint(v -> p .+ beta * v, [0.8])
println("Fixed point = $(sol.zero), and |f(x) - x| = $(norm(f(sol.zero) - sol.zero)) in $(sol.iterations) iterations")


# use arbitrary precision floating points
iv = [BigFloat(0.8)] # higher precision

sol = fixedpoint(v -> p .+ beta * v, iv)
println("Fixed point = $(sol.zero), and |f(x) - x| = $(norm(f(sol.zero) - sol.zero)) in " *
        "$(sol.iterations) iterations")


# multivariate fixed point map --------------------------------------------
p = [1.0, 2.0, 0.1]
beta = 0.9
iv =[0.8, 2.0, 51.0]
f(v) = p .+ beta * v

sol = fixedpoint(f, iv)
println("Fixed point = $(sol.zero), and |f(x) - x| = $(norm(f(sol.zero) - sol.zero)) in " *
        "$(sol.iterations) iterations")


# use StaticArrays package for an efficient implementation for small arrays and matrices
using NLsolve, StaticArrays

p = @SVector [1.0, 2.0, 0.1]    # The @SVector is a macro for turning a vector literal into a static vector
β = 0.9
iv = [0.8, 2.0, 51.0]
f(v) = p .+ β * v

sol = fixedpoint(f, iv)
println("Fixed point = $(sol.zero), and |f(x) - x| = $(norm(f(sol.zero) - sol.zero)) in " *
        "$(sol.iterations) iterations")