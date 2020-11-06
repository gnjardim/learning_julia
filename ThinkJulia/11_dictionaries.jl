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
known = Dict(0=>0, 1=>1)

function fibonacci(n)
    if n ∈ keys(known)
        return known[n]
    end
    res = fibonacci(n-1) + fibonacci(n-2)
    known[n] = res # global known[n] = res
    res
end

fibonacci(100)