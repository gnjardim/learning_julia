# exercise 1a -------------------------------------------------------------
using LinearAlgebra

struct UniformTrapezoidal
    count::Int
    delta::Float64
end

function Base.iterate(S::UniformTrapezoidal, state=1)
    if state == 1 || state == S.count
        w = 0.5
    elseif 1 < state < S.count
        w = 1
    else
        return nothing
    end

    iter = S.delta * w
    return (iter, state + 1)
end

function integrate(f, S)
    total = 0
    for (i, w) in enumerate(S)
        total += f[i] * w
    end

    return total
end

# equivalently
function trap_weights(x)
    return step(x) * [0.5; ones(length(x) - 2); 0.5]
end

x = range(0.0, 1.0, length = 100)
ω = trap_weights(x)
f(x) = x^2
dot(f.(x), ω)

# test
S = UniformTrapezoidal(length(x), x.step)
f(x) = x^2
integrate(f.(x), S)


# exercise 1b -------------------------------------------------------------
using Base: size, length, getindex

function Base.size(S::UniformTrapezoidal)
    return (S.count, )
end

function Base.length(S::UniformTrapezoidal)
    return prod(size(S))
end

function Base.getindex(S::UniformTrapezoidal, i::Int)
    return iterate(S, i)[1]
end

# test
size(S)
length(S)
S[2]
