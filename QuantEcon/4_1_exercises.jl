# exercise 5 --------------------------------------------------------------
using Base: show_supertypes
using QuadGK

function trapezoidal(f::AbstractArray, x::AbstractArray)
    @assert length(f) == length(x)

    trapezoidal_sum = 0
    for n in 2:length(x)
        trapezoidal_sum += (f[n-1] + f[n]) * (x[n] - x[n-1]) / 2
    end

    return trapezoidal_sum
end 

function trapezoidal(f::AbstractArray, x::AbstractRange)
    @assert length(f) == length(x)

    trapezoidal_sum = 0
    for n in 2:length(x)
        trapezoidal_sum += (f[n-1] + f[n]) * x.step / 2
    end

    return trapezoidal_sum
end 

function trapezoidal(f::Function,  x0::Real, xN::Real, N::Real)
    x = range(x0, xN, length = N)
    
    trapezoidal_sum = trapezoidal(f.(x), x)
    return trapezoidal_sum
end 

# define function
f(x) = x^2

# test
x_array = [x for x in 0:0.0001:1]
trapezoidal(f.(x_array), x_array)

x_range = 0:0.0001:1
trapezoidal(f.(x_range), x_range)

x0, xN = 0, 1
N = 10000
trapezoidal(f, x0, xN, N)

# compare with "actual"
value, accuracy = quadgk(f, 0.0, 1.0)

