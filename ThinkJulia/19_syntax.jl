# Named Tuples ------------------------------------------------------------
x = (a = 1, b = 2)
x.a, x.b


# Functions ---------------------------------------------------------------
f(x,y) = x + y

### Anonymous Functions
x -> x^2 + 2x - 1

function (x)
    x^2 + 2x - 1
end

using Plots
plot(x -> x^2 + 2x - 1, 0, 10, xlabel="x", ylabel="y")

### Keyword Arguments
function myplot(x, y; style="solid", width=1, color="black")
    return
end

myplot(0:10, 0:10, style="dotted", color="blue")


# Blocks ------------------------------------------------------------------
### A block is a way to group a number of statements.

### let
x, y = 10, 20
let x = 1, y = 2
    @show x y;
end

@show x y

### do
open("output.txt", "w") do fout     
    write(fout, data)
end

#= which is equivalent to

f = fout -> begin
    write(fout, data)
end

open(f, "output.txt", "w")
=#


# Control Flow ------------------------------------------------------------

### Ternary Operator
a = 150
a % 2 == 0 ? println("even") : println("odd")


### Short-Circuit Evaluation
function fact(n::Integer)
    n >= 0 || error("n must be non-negative")
    n == 0 && return 1
    n * fact(n-1)
end


### Tasks
#= 
A task is a control structure that can pass cooperatively control without returning. 
In Julia, a task can be implemented as a function having as first argument a Channel object. 
A channel is used to pass values from the function to the callee.
=#
function fib(c::Channel)
    a = 0
    b = 1
    put!(c, a)
    while true
        put!(c, b)
        (a, b) = (b, a+b)
    end
end

fib_gen = Channel(fib)
take!(fib_gen)
take!(fib_gen)
take!(fib_gen)
take!(fib_gen)
take!(fib_gen)

#= A channel object can also be used as an iterator =#
for val in Channel(fib)
    print(val, " ")
    val > 20 && break
end


# Types -------------------------------------------------------------------

### Parametric Types
#= Julia’s type system is parametric, meaning that types can have parameters.
Type parameters are introduced after the name of the type, surrounded by curly braces =#
struct Point{T<:Real}
    x::T
    y::T
end

#= This defines a new parametric type, Point{T<:Real}, 
   holding two "coordinates" of type T, which can be any type having Real as supertype =#
Point(0.0, 0.0)

### Type Unions
#= A type union is an abstract parametric type that can act as any of its argument types =#
IntOrString = Union{Int64, String}
150 :: IntOrString
"Julia" :: IntOrString


# Methods -----------------------------------------------------------------

### Parametric Methods
#= Method definitions can also have type parameters qualifying their signature =#
isintpoint(p::Point{T}) where {T} = (T === Int64)
isintpoint(Point(1, 2))

### Function-like Objects (functors)
#= Any arbitrary Julia object can be made “callable” =#
struct Polynomial{R}
    coeff :: Vector{R}
end

function (p::Polynomial)(x)
    val = 0
    for (dg, coeff) in enumerate(p.coeff)
        val += coeff * x^(dg - 1)
    end

    return val
end

p = Polynomial([1,10,100])
p(3)


# Constructors ------------------------------------------------------------
#= Parametric types can be explicitly or implicitly constructed =#
Point(1,2)         # implicit T
Point{Int64}(1, 2) # explicit T
Point(1,2.5)       # implicit T

#= When x and y have a different type, the following outer constructor can be defined =#
Point(x::Real, y::Real) = Point(promote(x,y)...)


# Conversion and Promotion ------------------------------------------------

### Conversion
#= A value can be converted from one type to another =#
x = 12
typeof(x)

y = convert(UInt8, x)
typeof(y)

#= We can add our own convert method =#
Base.convert(::Type{Point{T}}, x::Array{T, 1}) where {T<:Real} = Point(x...)
convert(Point{Int64}, [1, 2])

### Promotion
#= Promotion is the conversion of values of mixed types to a single common type =#
promote(1, 2.5, 3)

#= Methods for the promote function are normally not directly defined, 
   but the auxiliary function promote_rule is used to specify the rules for promotion =#
promote_rule(::Type{Float64}, ::Type{Int32}) = Float64


# Metaprogramming ---------------------------------------------------------
#= Julia code can be represented as a data structure of the language itself. 
This allows a program to transform and generate its own code. =#

### Expressions
prog = "1 + 2"

#= The next step is to parse each string into an object called an expression, represented by the Julia type Expr =#
ex = Meta.parse(prog)
typeof(ex)
dump(ex)

ex = :(1+2)
eval(ex)

### Macros
#= Macros can include generated code in a program. 
A macro maps a tuple of Expr objects directly to a compiled expression =#
macro sayhello(name)
    return :( println("Hello, ", $name) )
end

@sayhello("World")
@sayhello "World"
@macroexpand @sayhello "World"


macro containervariable(container, element)
    return esc(:($(Symbol(container,element)) = $container[$element]))
end

letters = ["a", "b", "c", "d", "e"]
@containervariable letters 1    # equivalent to :(letters1 = letters[1])
@macroexpand @containervariable letters 1

@show letters1

#= 
This example illustrates how a macro can access the name of its arguments, something a function can’t do. 
The return expression needs to be “escaped” with esc because it has to be resolved in the macro call environment 
Macros generate and include fragments of customized code during parse time, thus before the full program is run. 
=#

macro assert(ex)
    return :( $ex ? nothing : throw(AssertionError($(string(ex)))) )
end

@assert 1 == 1.0
@assert 1 == 0


### Generated Functions
#= (https://docs.julialang.org/en/v1/manual/metaprogramming/)
A very special macro is @generated, which allows you to define so-called generated functions. 
These have the capability to generate specialized code depending on the types of their arguments 
with more flexibility and/or less code than what can be achieved with multiple dispatch. 
While macros work with expressions at parse time and cannot access the types of their inputs, 
a generated function gets expanded at a time when the types of the arguments are known, 
but the function is not yet compiled.
=#

@generated function foo(x)
    Core.println(x)
    return :(x * x)
end

foo(2)
foo("Bla")
foo(4)      # caching behavior of generated functions

#=
In the body of the generated function you only have access to the types of the arguments – not their values
Instead of calculating something or performing some action, you return a quoted expression which, when evaluated, does what you want
Instead of calculating something or performing some action, you return a quoted expression which, when evaluated, does what you want
=#


# Missing Values ----------------------------------------------------------
a = [1, missing]
sum(a)
sum(skipmissing(a))