# Composite Types
struct Point
    x
    y
end

p = Point(2.0, 3.0)
p.x, p.y

typeof(p)
p isa Point

fieldnames(Point)
isdefined(p, :x)
isdefined(p, :z)

distance = sqrt(p.x^2 + p.y^2)


# Mutable Structs
mutable struct MPoint
    x
    y
end

blank = MPoint(0.0, 0.0)
blank.x = 3.0
blank.y = 4.0


# Instances as Arguments
function movepoint!(p, dx, dy) # works for mutable structs
    p.x += dx
    p.y += dy
    nothing
end

movepoint!(blank, 1, 1)
@show blank


# Exercise 15-1
function distancebetweenpoints(p1, p2)
    dx = p1.x - p2.x
    dy = p1.y - p2.y
    distance = sqrt(dx^2 + dy^2)
end

p1 = Point(0, 0)
p2 = Point(3, 4)
distancebetweenpoints(p1, p2)


# Exercise 15-3
struct Circle
    center
    radius
end

c1 = Circle(Point(150, 100), 75)

function pointincircle(c, p)
    dist = distancebetweenpoints(c.center, p)
    return dist <= c.radius
end