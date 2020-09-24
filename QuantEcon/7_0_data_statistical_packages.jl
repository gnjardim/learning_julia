using LinearAlgebra, Statistics
using DataFrames, RDatasets, DataFramesMeta, CategoricalArrays, Query, VegaLite, DataVoyager
using GLM


# DataFrames --------------------------------------------------------------
using DataFrames, RDatasets  # RDatasets provides good standard data examples from R

# note use of missing
commodities = ["crude", "gas", "gold", "silver"]
last_price = [4.2, 11.3, 12.1, missing]
df = DataFrame(commod = commodities, price = last_price)

# accessing columns
df.price
df.commod

# describe
DataFrames.describe(df)
first(df, 2)

# add row
nt = (commod = "nickel", price= 5.1)
push!(df, nt)

# build DataFrame with named tuples
nt = (t = 1, col1 = 3.0)
df2 = DataFrame([nt])
push!(df2, (t=2, col1 = 4.0))

# modifying columns
df[!, :price]   # mutating version
df[!, :price] *= 2.0  # double prices

# dealing with missing
mean(df.price)
mean(skipmissing(df.price))

df.price .= coalesce.(df.price, 0.0) # replace all missing with 0.0


# manipulating and transforming DataFrames --------------------------------
using DataFramesMeta

f(x) = x^2
df = @transform(df, price2 = f.(:price))

# categorical data
using CategoricalArrays

id = [1, 2, 3, 4]
y = ["old", "young", "young", "old"]
y = CategoricalArray(y)
df = DataFrame(id=id, y=y)


# visualization, querying, and plots --------------------------------------
using Query

df = DataFrame(name=["John", "Sally", "Kirk"], age=[23., 42., 59.], children=[3,5,2])

x = df |>
    @filter(_.age>50) |>
    @map({_.name, _.children}) |>
    DataFrame

# alternatively
x = @from i in df begin
    @where i.age>50
    @select {i.name, i.children}
    @collect DataFrame
end

# plots
using RDatasets, VegaLite
iris = dataset("datasets", "iris")

iris |> @vlplot(
    :point,
    x=:PetalLength,
    y=:PetalWidth,
    color=:Species
)


# statistics and econometrics ---------------------------------------------
# See https://juliastats.org/

# generalized linear models 
using GLM

x = randn(100)
y = 0.9 .* x + 0.5 * rand(100)
df = DataFrame(x=x, y=y)
ols = lm(@formula(y ~ x), df) # R-style notation

# displaying results
using RegressionTables
regtable(ols)
# regtable(ols,  renderSettings = latexOutput()) # for LaTex output

# fixed effects
using FixedEffectModels

cigar = dataset("plm", "Cigar")
cigar.StateCategorical =  categorical(cigar.State)
cigar.YearCategorical =  categorical(cigar.Year)
fixedeffectresults = reg(cigar, @formula(Sales ~ NDI + fe(StateCategorical) + fe(YearCategorical)),
                            weights = :Pop, Vcov.cluster(:State))
regtable(fixedeffectresults)