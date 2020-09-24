using Base: show_supertypes
using LinearAlgebra, Statistics
using Distributions, Plots, QuadGK, Polynomials, Interpolations

# exploring type trees ----------------------------------------------------
x = 1
y = Normal()
z = "foo"
x, y, z
typeof(x), typeof(y), typeof(z)
supertype(typeof(x))

# pipe operator, |>, is is equivalent
typeof(x) |> supertype
supertype(typeof(y))
typeof(z) |> supertype
typeof(x) <: Any

# subtype tree
function subtypetree(t, level=1, indent=4)
    if level == 1
        println(t)
    end
    for s in subtypes(t)
        println(join(fill(" ", level * indent)) * string(s))  # print type
        subtypetree(s, level+1, indent)  # recursively print the next type, indenting
    end
end

subtypetree(Number)


# unlearning oop ----------------------------------------------------------
# Distributions
d1 = Normal(1.0, 2.0) # an example type to explore
d1
show_supertypes(typeof(d1))

# The Sampleable{Univariate,Continuous} type has a limited number of functions, 
# like the ability to draw a random number. The purpose of that abstract type is 
# to provide an interface for drawing from a variety of distributions, 
# some of which may not have a well-defined predefined pdf.
rand(d1)

function simulateprocess(x₀; a = 1.0, b = 1.0, N = 5, d::Sampleable{Univariate,Continuous})
    x = zeros(typeof(x₀), N+1) # preallocate vector, careful on the type
    x[1] = x₀
    for t in 2:N+1
        x[t] = a * x[t-1] + b * rand(d) # draw
    end
    return x
end

simulateprocess(0.0, d=Normal(0.2, 2.0))

# Moving down the tree, the Distributions{Univariate, Continuous} abstract type 
# has other functions we can use for generic algorithms operating on distributions.
# These match the mathematics, such as pdf, cdf, quantile, support, minimum, maximum, etc.
d1 = Normal(1.0, 2.0)
d2 = Exponential(0.1)
d1, d2
supertype(typeof(d1))
supertype(typeof(d2))

pdf(d1, 0.1), pdf(d2, 0.1)
cdf(d1, 0.1), cdf(d2, 0.1)
support(d1), support(d2)
minimum(d1), minimum(d2)
maximum(d1), maximum(d2)

# You could create your own Distributions{Univariate, Continuous} type by implementing those functions. 
# If you fulfill all of the conditions of a particular interface, you can use algorithms from the 
# present, past, and future that are written for the abstract Distributions{Univariate, Continuous} type.
# As an example, consider the StatsPlots package.
using StatsPlots
d = Normal(2.0, 1.0)
plot(d) # note no other arguments!

# Calling plot on any subtype of Distributions{Univariate, Continuous} displays the pdf
# and uses minimum and maximum to determine the range


# creating our own distribution type --------------------------------------
struct OurTruncatedExponential <: Distribution{Univariate,Continuous}
    α::Float64
    xmax::Float64
end

Distributions.pdf(d::OurTruncatedExponential, x) = d.α * exp(-d.α * x)/exp(-d.α * d.xmax)
Distributions.minimum(d::OurTruncatedExponential) = 0
Distributions.maximum(d::OurTruncatedExponential) = d.xmax
# ... more to have a complete type

# Curiously, you will note that the support function works, even though we did not provide one.
# This is another example of the power of multiple dispatch and generic programming.
d = OurTruncatedExponential(1.0,2.0)
minimum(d), maximum(d)
support(d) # why does this work?
plot(d) # uses the generic code!

# Even if it worked for StatsPlots, our implementation is incomplete, as we haven’t fulfilled 
# all of the requirements of a Distribution. We also did not implement the rand function, 
# which means we are breaking the implicit contract of the Sampleable abstract type.
d = Truncated(Exponential(0.1), 0.0, 2.0)
typeof(d)
plot(d)

