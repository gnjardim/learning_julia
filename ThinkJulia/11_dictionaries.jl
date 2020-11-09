# Dictionary as a Collection of Counters
function histogram(s)
    d = Dict()
    for c in s
        if c ∉ keys(d)
            d[c] = 1
        else
            d[c] += 1
        end
    end

    return d
end

h = histogram("brontosaurus")
h['o']
keys(h)
values(h)
length(h)

get(h, 'a', 0)
get(h, 'z', 0)


# Looping and Dictionaries
function printhist(h)
    for c in keys(h)
        println(c, " ", h[c])
    end
end

printhist(h)


# Reverse Lookup
function reverselookup(d, v)
    for k in keys(d)
        if d[k] == v
            return k
        end
    end
    error("LookupError")
end

findall(isequal(2), h)


# Memos

### For performance reasons, you should declare a global variable constant. 
### You can no longer reassign the variable but if it refers to a mutable value, you can modify the value
const known = Dict(0=>0, 1=>1)

function fibonacci(n)
    if n ∈ keys(known)
        return known[n]
    end
    res = fibonacci(n-1) + fibonacci(n-2)
    
    ### If a global variable refers to a mutable value, you can modify the value without declaring the variable global
    known[n] = res 
    return res
end

fibonacci(100)