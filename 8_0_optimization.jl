# optim -------------------------------------------------------------------
using Optim
using Optim: converged, maximum, maximizer, minimizer, iterations #some extra functions

result = optimize(x-> x^2, -2.0, 1.0)

# check if results converged
converged(result) || error("Failed to converge in $(iterations(result)) iterations")
xmin = result.minimizer
result.minimum

# alternatively
f(x) = -x^2
result = maximize(f, -2.0, 1.0)
converged(result) || error("Failed to converge in $(iterations(result)) iterations")
xmin = maximizer(result)
fmax = maximum(result)


# unconstrained multivariate optimization ---------------------------------
# simplest version
f(x) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
x_iv = [0.0, 0.0]
results = optimize(f, x_iv) # i.e. optimize(f, x_iv, NelderMead())

# other algorithms
results = optimize(f, x_iv, LBFGS())
println("minimum = $(results.minimum) with argmin = $(results.minimizer) in $(results.iterations) iterations")

# using auto differentiation
f(x) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
x_iv = [0.0, 0.0]
results = optimize(f, x_iv, LBFGS(), autodiff=:forward) # i.e. use ForwardDiff.jl
println("minimum = $(results.minimum) with argmin = $(results.minimizer) in $(results.iterations) iterations")

# with analytical gradient
f(x) = (1.0 - x[1])^2 + 100.0 * (x[2] - x[1]^2)^2
x_iv = [0.0, 0.0]
function g!(G, x)
    G[1] = -2.0 * (1.0 - x[1]) - 400.0 * (x[2] - x[1]^2) * x[1]
    G[2] = 200.0 * (x[2] - x[1]^2)
end

results = optimize(f, g!, x_iv, LBFGS()) # or ConjugateGradient()
println("minimum = $(results.minimum) with argmin = $(results.minimizer) in $(results.iterations) iterations")


# JuMP --------------------------------------------------------------------
using JuMP, Ipopt

# solve
# max( x[1] + x[2] )
# st sqrt(x[1]^2 + x[2]^2) <= 1

function squareroot(x) # pretending we don't know sqrt()
    z = x # Initial starting point for Newton’s method
    while abs(z*z - x) > 1e-13
        z = z - (z*z-x)/(2z)
    end
    return z
end

m = Model(Ipopt.Optimizer)
# need to register user defined functions for AD
JuMP.register(m,:squareroot, 1, squareroot, autodiff=true)

@variable(m, x[1:2], start=0.5) # start is the initial condition
@objective(m, Max, sum(x))
@NLconstraint(m, squareroot(x[1]^2+x[2]^2) <= 1)
JuMP.optimize!(m)


# solve
# min (1-x)^2 + 100(y-x^2)^2)
# st x + y >= 10

m = Model(Ipopt.Optimizer) # settings for the solver
@variable(m, x, start = 0.0)
@variable(m, y, start = 0.0)

@NLobjective(m, Min, (1-x)^2 + 100(y-x^2)^2)

JuMP.optimize!(m)
println("x = ", value(x), " y = ", value(y))

# adding a (linear) constraint
@constraint(m, x + y == 10)
JuMP.optimize!(m)
println("x = ", value(x), " y = ", value(y))


# Roots -------------------------------------------------------------------
using Roots
f(x) = sin(4 * (x - 1/4)) + x + x^20 - 1
fzero(f, 0, 1)


# NLsolve -----------------------------------------------------------------
using NLsolve

f(x) = [(x[1] + 3) * (x[2]^3 - 7) + 18
        sin(x[2] * exp(x[1]) - 1)] # returns an array

results = nlsolve(f, [0.1; 1.2])


# LeastSquaresOptim -------------------------------------------------------
using LeastSquaresOptim

function rosenbrock(x)
    [1 - x[1], 100 * (x[2]-x[1]^2)]
end

LeastSquaresOptim.optimize(rosenbrock, zeros(2), Dogleg())