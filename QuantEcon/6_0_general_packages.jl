using LinearAlgebra, Statistics
using QuantEcon, QuadGK, FastGaussQuadrature, Distributions, Expectations
using Interpolations, Plots, LaTeXStrings, ProgressMeter


# numerical integration ---------------------------------------------------
# QuadGK
value, tol = quadgk(cos, -2π, 2π)

# FastGaussQuadrature
x, w = gausslegendre( 100_000 ) # i.e. find 100,000 nodes

f(x) = x^2
w ⋅ f.(x) # integrates f(x) = x^2 from -1 to 1

# QuantEcon has routines for Gaussian quadrature that translate the domains
x, w = qnwlege(65, -2π, 2π)
w ⋅ cos.(x) # i.e. on [-2π, 2π] domain


# expectation -------------------------------------------------------------
using Distributions, Expectations
dist = Normal()
E = expectation(dist)
f(x) = x
E(f) #i.e. identity

# Or using as a linear operator
f(x) = x^2
x = nodes(E)
w = weights(E)
E * f.(x) == f.(x) ⋅ w


# interpolation -----------------------------------------------------------
# Univariate with a Regular Grid
using Plots
gr(fmt=:png)

x = -7:7 # x points, coase grid
y = sin.(x) # corresponding y points

xf = -7:0.1:7        # fine grid
plot(xf, sin.(xf), label = "sin function")
scatter!(x, y, label = "sampled data", markersize = 4)

# linear and cubic spline
li = LinearInterpolation(x, y)
li_spline = CubicSplineInterpolation(x, y)

li(0.3) # evaluate at a single point

scatter(x, y, label = "sampled data", markersize = 4)
plot!(xf, li.(xf), label = "linear")
plot!(xf, li_spline.(xf), label = "spline")


# Univariate with Irregular Grid
x = log.(range(1, exp(4), length = 10)) .+ 1  # uneven grid
y = log.(x) # corresponding y points

interp = LinearInterpolation(x, y)

xf = log.(range(1,  exp(4), length = 100)) .+ 1 # finer grid

plot(xf, interp.(xf), label = "linear")
scatter!(x, y, label = "sampled data", markersize = 4, size = (800, 400))


# Multivariate Interpolation
f(x,y) = log(x+y)
xs = 1:0.2:5
ys = 2:0.1:5
A = [f(x,y) for x in xs, y in ys]

# linear interpolation
interp_linear = LinearInterpolation((xs, ys), A)
interp_linear(3, 2) # exactly log(3 + 2)
interp_linear(3.1, 2.1) # approximately log(3.1 + 2.1)

# cubic spline interpolation
interp_cubic = CubicSplineInterpolation((xs, ys), A)
interp_cubic(3, 2) # exactly log(3 + 2)
interp_cubic(3.1, 2.1) # approximately log(3.1 + 2.1)


# linear algebra ----------------------------------------------------------
# See https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/


# general tools -----------------------------------------------------------
# properly escape latex code
using LaTeXStrings
L"an equation: $1 + \alpha^2$"

# progress meter
using ProgressMeter

@showprogress 1 "Computing..." for i in 1:50
    sleep(0.1) # some computation....
end
