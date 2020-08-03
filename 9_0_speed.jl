using LinearAlgebra, Statistics

# multiple dispatch -------------------------------------------------------
# Julia stores multiple, specialized versions of functions like addition, one for each data type or set of data types.
@which +(1, 1)
@which +(1.0, 1.0)
@which +(1.0 + 1.0im, 1.0 + 1.0im)

# adding methods
import Base: +  # enables adding methods to the + function

+(x::Integer, y::String) = x + parse(Int, y)

@show +(100, "100")
@show 100 + "100"  # equivalent


# Suppose we execute the function call f(a, b) where a and b are of concrete types S and T respectively.
# The Julia interpreter first queries the types of a and b to obtain the tuple (S, T).
# It then parses the list of methods belonging to f, searching for a match.
# If it finds a method matching (S, T) it calls that method.
# If not, it looks to see whether the pair (S, T) matches any method defined for immediate parent types.

# If the interpreter can’t find a match in immediate parents (supertypes) it proceeds up the tree, looking at the parents of the last type it checked at each iteration.
# - If it eventually finds a matching method, it invokes that method.
# - If not, we get an error.
@show (typeof(100.0) <: Integer) == false
100.0 + "100"

# Because the dispatch procedure starts from concrete types and works upwards, dispatch always invokes the most specific method available.
function q(x)  # or q(x::Any)
    println("Default (Any) method invoked")
end

function q(x::Number)
    println("Number method invoked")
end

function q(x::Integer)
    println("Integer method invoked")
end

q(3)
q(3.0)
q("foo")


# return types ------------------------------------------------------------
# For the most part, time spent “optimizing” Julia code to run faster is about ensuring the compiler can correctly deduce types for all functions.
# The macro @code_warntype gives us a hint
x = [1, 2, 3]
f(x) = 2x
@code_warntype f(x)

# returns Union{Nothing, Int64}
f(x) = x > 0.0 ? x : nothing
@code_warntype f(1)

# returns Union{Float64, Int64}
f(x) = x > 0.0 ? x : 0.0
@code_warntype f(1)

# solution:
f(x) = x > 0.0 ? x : zero(x)
@code_warntype f(1.0)


# machine code ------------------------------------------------------------
function f(a, b)
    y = (a + 8b)^2
    return 7y
end

# The JIT compiler now knows the types of a and b.Moreover, it can infer types for other variables inside the function
@code_native f(1, 2)        # y will also be an integer
@code_native f(1.0, 2.0)    # y will also be a float

# avoid global variables
using BenchmarkTools

b = 1.0
function g(a)
    global b
    for i ∈ 1:1_000_000
        tmp = a + b
    end
end
@btime g(1.0)

function g(a, b)
    for i ∈ 1:1_000_000
        tmp = a + b
    end
end
@btime g(1.0, 1.0)

# alternative, use const
const b_const = 1.0
function g(a)
    global b_const
    for i ∈ 1:1_000_000
        tmp = a + b_const
    end
end

@btime g(1.0)


# composite types with abstract field types -------------------------------
# untyped
struct Foo_generic
    a
end

# abstract
struct Foo_abstract
    a::Real
end

# parametrically typed
struct Foo_concrete{T <: Real}
    a::T
end

# testing
fg = Foo_generic(1.0)
fa = Foo_abstract(1.0)
fc = Foo_concrete(1.0)

function f(foo)
    for i ∈ 1:1_000_000
        tmp = i + foo.a
    end
end

@btime f(fg)
@btime f(fa)
@btime f(fc)    # much better