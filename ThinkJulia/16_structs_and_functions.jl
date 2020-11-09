# Time
"""
Represents the time of day.

fields: hour, minute, second
"""
struct MyTime
    hour
    minute
    second
end





# Exercise 16-1
using Printf
function printtime(mtime)
    @printf("%02d:%02d:%02d\n", mtime.hour, mtime.minute, mtime.second)
end

printtime(MyTime(18, 30, 42))


# Exercise 16-2
function isafter(t1, t2)
    hour_after = (t1.hour > t2.hour)
    min_after = (t1.minute > t2.minute)
    sec_after = (t1.second > t2.second)

    return hour_after || (t1.hour == t2.hour && min_after) || 
           (t1.hour == t2.hour && t1.minute == t2.minute && sec_after) 
end


# Exercise 16-3
mutable struct MMyTime
    hour
    minute
    second
end

function increment!(time, seconds)
    time.second += seconds

    time.minute += time.second ÷ 60
    time.second = time.second % 60
    
    time.hour += time.minute ÷ 60
    time.minute = time.minute % 60

    return
end

t1 = MMyTime(18, 30, 42)
increment!(t1, 3600)
@show t1


# Exercise 16-4
function increment(time, seconds)
    hours = time.hour
    mins = time.minute
    secs = time.second

    secs += seconds

    mins += secs ÷ 60
    secs = secs % 60
    
    hours += mins ÷ 60
    mins = mins % 60

    return MyTime(hours, mins, secs)
end

t2 = MyTime(18, 30, 42)
increment(t2, 1)
increment(t2, 60)
increment(t2, 3600)