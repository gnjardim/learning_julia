# Type Declarations -------------------------------------------------------
(1 + 2) :: Int64

function returnfloat()
    x::Float64 = 100
    x
end

function sinc(x)::Float64
    if x == 0
        return 1
    end
    sin(x)/(x)
end

# Methods -----------------------------------------------------------------

### Type declarations can and should be added for performance reasons to the fields in a struct definition.
struct MyTime
    hour :: Int64
    minute :: Int64
    second :: Int64
end

### A method is a function definition with a specific signature
using Printf
function printtime(time::MyTime)
    @printf("%02d:%02d:%02d", time.hour, time.minute, time.second)
end

printtime(MyTime(14, 30, 42))

### We can now redefine the first method without the :: type annotation allowing an argument of any type
function printtime(time)
    println("I don't know how to print the argument time.")
end

printtime(2)


# Constructors ------------------------------------------------------------
### A constructor is a special function that is called to create an object

### The default constructor methods of MyTime have the following signatures
MyTime(hour::Int64, minute::Int64, second::Int64)

### Outer Constructor (in this case, a copy constructor)
function MyTime(time::MyTime)
    MyTime(time.hour, time.minute, time.second)
end

### Inner Constructor to enforce invariants
struct MyTime
    hour :: Int64
    minute :: Int64
    second :: Int64
    function MyTime(hour::Int64=0, minute::Int64=0, second::Int64=0)
        @assert(0 ≤ minute < 60, "Minute is not between 0 and 60.")
        @assert(0 ≤ second < 60, "Second is not between 0 and 60.")
        new(hour, minute, second)
    end
end

### An inner constructor method is always defined inside the block of a type declaration and it has access to a special function called new that creates objects of the newly declared type
### The default constructor is not available if any inner constructor is defined. You have to write explicitly all the inner constructors you need.


# show --------------------------------------------------------------------
### show is a special function that returns a string representation of an object.

function Base.show(io::IO, time::MyTime)
    @printf(io, "%02d:%02d:%02d", time.hour, time.minute, time.second)
end

### When you print an object, Julia invokes the show function
time = MyTime(9, 45)


# Operator Overload -------------------------------------------------------
import Base.+

function +(t1::MyTime, t2::MyTime)
    seconds = timetoint(t1) + timetoint(t2)
    inttotime(seconds)
end


# Multiple Dispatch -------------------------------------------------------
### The choice of which method to execute when a function is applied is called dispatch. 
### Julia allows the dispatch process to choose which of a function’s methods to call based on
### the number of arguments given, and on the types of all of the function’s arguments. 
### Using all of a function’s arguments to choose which method should be invoked is known as multiple dispatch.

function +(time::MyTime, seconds::Int64)
    increment(time, seconds)
end

function +(seconds::Int64, time::MyTime)
    time + seconds
end

methods(+)

# Generic Programming -----------------------------------------------------
### Multiple dispatch is useful when it is necessary, but (fortunately) it is not always necessary. 
### Often you can avoid it by writing functions that work correctly for arguments with different types.


# Exercise 17-5 -----------------------------------------------------------
struct Kangaroo
    pouchcontents :: Array
    function Kangaroo(pouchcontents::Array = [])
        new(pouchcontents)
    end
end

function putinpouch!(k::Kangaroo, object)
    push!(k.pouchcontents, object)
end

function Base.show(io::IO, k::Kangaroo)
    print(io, "Kangaroo's pouch: ", k.pouchcontents)
end

kanga = Kangaroo()
roo = Kangaroo()

putinpouch!(kanga, roo)
kanga
