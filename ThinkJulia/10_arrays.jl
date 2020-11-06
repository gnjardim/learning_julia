# Exercise 10-1
function nestedsum(arr)
    return sum(sum.(arr))
end

t = [[1, 2], [3], [4, 5, 6]]
nestedsum(t)


# Exercise 10-2
function cumulsum(arr)
    res = zeros(length(arr))
    for i in eachindex(arr)
        res[i] = sum(arr[1:i])
    end

    return res
end

cumulsum([1, 2, 3, 4])


# Exercise 10-3
function interior(arr)
    return arr[2:(end - 1)]   
end

interior([1, 2, 3, 4, 5, 6])


# Exercise 10-4
function interior!(arr)
    pop!(arr)
    popfirst!(arr)

    return nothing
end

x = [1, 2, 3, 4, 5, 6]
interior!(x)
println(x)


# Exercise 10-5
function issort(arr)
    sorted = sort(arr)
    return arr == sorted
end

issort([1, 2, 2])
issort([1, 4, 3, 2])
issort(['a', 'b'])
issort(['b', 'a'])


# Exercise 10-10
function inbisect(array, value)
    if length(array) == 0
        return false
    end
    
    mid = cld(length(array), 2)
    if value == array[mid]
        return true
    elseif value > array[mid]
        return inbisect(array[(mid + 1):end], value)
    elseif value < array[mid]
        return inbisect(array[1:(mid - 1)], value)     
    end
end

arr = [2, 3, 4, 10, 20, 40] 
x = 30
inbisect(arr, x)