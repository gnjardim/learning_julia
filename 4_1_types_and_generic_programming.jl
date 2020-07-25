using LinearAlgebra, Statistics

# parametric types --------------------------------------------------------
typeof(1), typeof(1.0)

typeof(1.0 + 1im)    # curly braces indicate they are parametric
typeof(ones(2, 2))
typeof((1, 2.0, "test"))
typeof((a = 1, b = 2.0, c = "test"))


# abstract vs concrete types ----------------------------------------------
### Concrete types are types that we can instantiate (e.g., Int64, Float64)
### Abstract types cannot be instantiated (e.g., Real, AbstractFloat)

# subtypes and supertypes
Float64 <: Real             # is subtype of Real
Int64 <: Real               # is subtype of Real
Complex{Float64} <: Real    
Array <: Real

# all subtypes of Number
Real <: Number
Float64 <: Number
Int64 <: Number
Complex{Float64} <: Number

# Any is a parent of all types
Number <: Any

# we can check all supertypes or subtypes
using Base: show_supertypes
show_supertypes(Int64)

subtypes(Real)
subtypes(AbstractFloat)


# deducing and declaring types --------------------------------------------
f(x) = 2x

x = [1, 2, 3]
z = f(x) # call with an integer array - compiler deduces type

# an example of bad practice is to use an array to hold unrelated types
x = [1.0, "test", 1]

# type stability -- ensure that functions return the same types
function f(x)
    if x > 0
        return 1.0    # Float64
    else
        return 0.0    # Float64
    end
end

f(1)
f(-1)


# manually declaring function and variable types --------------------------
function f(x, A)
    b = [5.0, 6.0]
    return A * x .+ b
end

# equivalent function with argument and return types
function f2(x::Vector{Float64}, A::Matrix{Float64})::Vector{Float64}
    b::Vector{Float64} = [5.0, 6.0]
    return A * x .+ b
end

# almost never generates faster code and it can lead to confusion and inefficiencies
f2([0.1; 2.0], [1 2; 3 4])              # not a `Float64`
f2([0.1; 2.0], Diagonal([1.0, 2.0]))    # not a `Matrix{Float64}`


# creating new types ------------------------------------------------------
struct FooNotTyped  # immutable by default, use `mutable struct` otherwise
    a # BAD! not typed
    b
    c
end

# better
struct Foo
    a::Float64
    b::Int64
    c::Vector{Float64}
end

# creating instances
foo_nt = FooNotTyped(2.0, 3, [1.0, 2.0, 3.0])  # new `FooNotTyped`
foo = Foo(2.0, 3, [1.0, 2.0, 3.0])             # creates a new `Foo`

typeof(foo)

# get the value for a field
foo.a       
foo.b
foo.c
# foo.a = 2.0     # fails since it is immutable

### -- two differences above for the struct compared to our use of NamedTuple
# + types are declared for the fields, rather than inferred by the compiler.
# + no named parameters to prevent accidental misuse if the wrong order is chosen.

# bad practices -- using abstract types
struct Foo2
    a::Float64
    b::Integer       # BAD! Not a concrete type
    c::Vector{Real}  # BAD! Not a concrete type
end


# declaring parametric types ----------------------------------------------
struct Foo3{T1, T2, T3}
    a::T1   # could be any type
    b::T2
    c::T3
end

# less flexible
struct Foo4{T1 <: Real, T2 <: Real, T3 <: AbstractVecOrMat{<:Real}}
    a::T1
    b::T2
    c::T3  # should check dimensions as well
end

### -- This ensures that
# a and b are a subtype of Real, and + in the definition of f works
# c is a one dimensional abstract array of Real values


# multiple dispatch -------------------------------------------------------
abs(-1)            # `Int64`
abs(-1.0)          # `Float64`
abs(0.0 - 1.0im)   # `Complex{Float64}`

# use type annotation
function ourabs(x::Real)
    if x > zero(x)   # note, not 0!
        return x
    else
        return -x
    end
end

function ourabs(x::Complex)
    sqrt(real(x)^2 + imag(x)^2)
end

ourabs(-1)            # `Int64`
ourabs(-1.0)          # `Float64`
ourabs(1.0 - 2.0im)   # `Complex{Float64}`

