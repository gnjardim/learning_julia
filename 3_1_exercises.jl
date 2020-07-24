# exercise 1 --------------------------------------------------------------
function asymptoticvar(A, Σ; tol = 1e-10)
    St = similar(A)
    
    diff = Inf
    tol_matrix = fill(tol, size(A))

    while all(diff .> tol_matrix)
        St_1 = A*St*A' + Σ*Σ'

        diff = abs.(St_1 .- St)
        St = St_1
    end

    return St 
end

# test
using QuantEcon

A = [0.8 -0.2; -0.1 0.7]
Σ = [0.5 0.4; 0.4 0.6]
asymptoticvar(A, Σ)
solve_discrete_lyapunov(A, Σ * Σ')


# exercise 2 --------------------------------------------------------------
using LaTeXStrings, Plots

function simulatets(theta, T)
    gamma, sigma = 1, 1
    y = zeros(T + 1)
    rolling_mean = zeros(T)

    for t in 1:T
        y[t + 1] = gamma + theta * y[t] + sigma * randn()
        rolling_mean[t] = sum(y) / t
    end    

    return rolling_mean
end


function final_yt(theta, T, N)
    y_final = zeros(N)
    
    for sim in 1:N
        y_final[sim] = simulatets(theta, T)[end]
    end

    return y_final
end

# parameters
Theta = [0.8, 0.9, 0.98]
T = 150
y1, y2, y3 = simulatets.(Theta, T)

plot(1:T, y1, size = (1200, 900), label = L"\theta = 0.8")
plot!(1:T, y2, label = L"\theta = 0.9")
plot!(1:T, y3, label = L"\theta = 0.98")
xlabel!("Time")


# histogram
N = 200
yf_1, yf_2, yf_3 = final_yt.(Theta, T, N)

histogram(yf_1, alpha = 0.5, label = L"\theta = 0.8")
histogram!(yf_2, alpha = 0.5, label = L"\theta = 0.9")
histogram!(yf_3, alpha = 0.5, label = L"\theta = 0.98")


# exercise 3 --------------------------------------------------------------
function simulate_data(a, b, c, d, sigma = 0.1; N)
    x1, x2 = randn(N), randn(N)
    w = randn(N)

    y = a*x1 .+ b*(x2.^2) .+ c*x2 .+ d .+ sigma*w 

    return (y, x1, x2)    
end

function OLS(y, x1, x2)
    constant = ones(size(x1))
    X = [x1 x2.^2 x2 constant]

    # estimate beta
    beta = (X'* X) \ (X' * y)

    # estimate sigma
    epsilon = X * beta - y
    sigma = sqrt((epsilon' * epsilon) / length(y))
    return vcat(beta, sigma)
end

# simulate
M = 100000
a, b, c, d, sigma = [zeros(M) for _ in 1:5]

for i in 1:M
    y, x1, x2 = simulate_data(0.1, 0.2, 0.5, 1.0; N = 50)
    a[i], b[i], c[i], d[i], sigma[i] = OLS(y, x1, x2)
end

# plots
parameters = [a, b, c, d, sigma]
labels = ["a", "b", "c", "d", L"\sigma"]

gr()
for (param, lab) in zip(parameters, labels)
    display(histogram(param, label = lab))
end
