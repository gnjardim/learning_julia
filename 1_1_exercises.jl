# 1) function for n factorial ---------------------------------------------
function factorial2(n)
    fact = 1
    for i = 1:n
        fact *= i
    end

    return fact
end

n = 1:10
factorial.(n) == factorial2.(n)
    
# using recursion
function factorial_recursive(n)
    if n == 1
        return 1
    end

    return n * factorial_recursive(n-1)
    
end

n = 1:10
factorial.(n) == factorial_recursive.(n)


# 2) function for binomial distribution -----------------------------------
using Distributions

function binomial_rv(n, p)
    U = rand(n)    # uniform(0, 1)

    success = sum(U .< p)    # number of successes with prob p
    return success
end

# testing
n_draws = 1000
draws = zeros(n_draws)
for i in eachindex(draws)
    draws[i] = binomial_rv(100, 0.5)
end

mean(draws)


# 3) approximation of pi using monte carlo --------------------------------
function pi_monte_carlo(n_sims)
    count = 0

    for i in 1:n
        x, y = rand(2)
        d = sqrt((x - 0.5)^2 + (y - 0.5)^2)  # distance from middle of square

        count += d < 0.5
    end

    area_estimate = count / n
    pi = area_estimate / (0.5 ^ 2)
    return pi
end

# testing
pi_monte_carlo(100000000)

# 4) flip coins -----------------------------------------------------------
function flip_coins()
    U = rand(10)
    heads = U .< 0.5

    return heads
end

U = flip_coins()
consec_heads = 0
for i in eachindex(U)
    if U[i] == 1
        global consec_heads += 1
    else 
        global consec_heads = 0
    end

    if consec_heads == 3
        print("Pay one dollar!")
    end
end


# 5) simulate and plot time series ----------------------------------------
using Plots

function simulate_ts(alpha, n)
    x = zeros(n + 1)

    for t in 1:n
        x[t + 1] = alpha * x[t] + randn()
    end

    return x
end

n = 200
X = simulate_ts(0.9, n)
plot(0:n, X)


# 6) simulate and plot time series ----------------------------------------
using LaTeXStrings

n = 200
T = 0:n
alphas = [0, 0.8, 0.98]

X, Y, Z = simulate_ts.(alphas, n)
plot(T, X, title = "Time Series", size = (900, 600), label = L"\alpha = 0")
plot!(T, Y, label = L"\alpha = 0.8")
plot!(T, Z, label = L"\alpha = 0.98")
xlabel!("Time")

savefig("output/1_1_Plot.pdf")


# 7) simulate and plot time series ----------------------------------------
function first_passage_rw(alpha, sigma, t_max)
    x = ones(n + 1)

    for t in 1:t_max
        x[t + 1] = alpha * x[t] + sigma * randn()

        if x[t + 1] < 0
            return t
        end
    end

    return Inf
end

t_max = 200
sims = 100
T0 = zeros(sims)

for sim in eachindex(T0)
    T0[sim] = first_passage_rw(1.0, 0.2, t_max)
end

histogram(T0, bins = 10)
