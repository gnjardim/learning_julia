# Exercise 6-5
function ack(m, n)
    if m == 0
        return n + 1
    elseif m > 0 && n == 0
        return ack(m - 1, 1)
    elseif m > 0 && n > 0 
        return ack(m - 1, ack(m, n - 1))
    end
end

ack(3, 4)


# Exercise 6-6
function first(word)
    first = firstindex(word)
    word[first]
end

function last(word)
    last = lastindex(word)
    word[last]
end

function middle(word)
    first = firstindex(word)
    last = lastindex(word)
    word[nextind(word, first) : prevind(word, last)]
end

function ispalindrome(word)
    if length(word) == 0
        return true
    else
        return first(word) == last(word) && ispalindrome(middle(word))
    end
end

ispalindrome("abba")
ispalindrome("not abba")


# Exercise 6-7
function ispower(a, b)
    if a < b
        return false
    elseif a == b
        return true
    else
        return a % b == 0 && ispower(a/b, b)
    end
end

ispower(8^2, 8)


# Exercise 6-8
function gcd(a, b)
    if b == 0
        return a
    else 
        return gcd(b, a % b)
    end
end

gcd(54, 24)