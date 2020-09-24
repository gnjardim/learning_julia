# exercise 1 --------------------------------------------------------------
### 1)
function inner_product(x_vals, y_vals)
    total = 0    
    for (x, y) in zip(x_vals, y_vals)
        total += x * y
    end

    return total
end

x_vals = [1, 2, 3]
y_vals = [4, 5, 6]

inner_product(x_vals, y_vals)
sum(x * y for (x, y) in zip(x_vals, y_vals))

### 2) 
sum(iseven, 0:99)
sum(1 for num in 0:99 if iseven(num))

## 3)
num_pairs = ((2, 5), (4, 2), (9, 8), (12, 10))
sum(1 for (a, b) in num_pairs if iseven(a) && iseven(b))
sum(xy -> all(iseven, xy), num_pairs)


# exercise 2 --------------------------------------------------------------
function p(x, coeff)
    polynm = 0
    for (n, coef) in enumerate(coeff)
        polynm += coef * x^(n - 1)
    end
    
    return polynm
end

p(1, (2, 4))


# exercise 3 --------------------------------------------------------------
function num_upper(s)
    count = 0
    for char in s
        if isletter(char) && (char == uppercase(char))
            count += 1
        end
    end

    return count
end

num_upper("Julia QuantEcon")


# exercise 4 --------------------------------------------------------------
function all_in(seq_a, seq_b)
    for a in seq_a
        if !(a in seq_b)
            return false
        end
    end
    
    return true
end

# test
all_in([1, 2], [1, 2, 3])
all_in([1, 2, 3], [1, 2])

# alternative
issubset([1, 2], [1, 2, 3])


# exercise 5 --------------------------------------------------------------
using Plots

function linapprox(f; a, b, n, x)
    @assert a <= x <= b && n > 0

    step = (b - a) / (n - 1)
    point_pre = a
    point = a + step

    while point <= x
        point_pre = point
        point += step
    end
   
    return f(point_pre) + (x - point_pre) * (f(point) - f(point_pre)) / (point - point_pre)
end

# test
f(x) = x^2
f_approx(x) = linapprox(f, a = -1, b = 1, n = 5, x = x)

x_grid = range(-1.0, 1.0, length = 100)
y_vals = f.(x_grid)
y = f_approx.(x_grid)
plot(x_grid, y_vals, label = "true")
plot!(x_grid, y, label = "approximation")


# exercise 6 --------------------------------------------------------------
function compute_total(file_path)
    total = 0    
    open(file_path, "r") do f    
        for l in eachline(f)
            line_splt = split(l, ": ")
            total += parse(Int, line_splt[2])
        end    
    end

    return total
end

total_pop = compute_total("us_cities.txt")
println("Total population = $total_pop")