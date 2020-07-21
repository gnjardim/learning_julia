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
