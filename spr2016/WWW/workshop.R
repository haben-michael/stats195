## Intro to R Workshop I -- July 2, 2015
## Haben Michael
## Sponsored by Lane Medical Library


## Let’s first look at "things" or "nouns" in R: constants, variables,
## types.

## R has a few built-in constants. In R you can think of a constant as
## a pre-defined name-value pair.

pi # constant of numeric type
letters # constant of character/string type
cos

## A variable can be thought of as a user-defined name-value pair.

x=3.14
x <- 3.14
x <- "a"

## A constant or variable has a type. First, languages have primitive/simple
## types. Common examples in R are a real number/double/numeric,
## character, or booleans/logicals. In R, the type of the value
## associated to a variable (name) may be changed.

pi
str(pi)
type(pi)
str(pi+3)
str("a")
str("haben") ## strings are basic
TRUE
str(TRUE & FALSE)
str(TRUE | FALSE)

## Factors are another basic type. They are used to represent data
## that assumes a finite number of values, whether in some order
## (e.g., income bracket) or not (e.g., gender). We will see examples
## in a moment.


## Languages also have complex data types, "complex" in the sense of being
## built up from the simple types. Common examples in R are vectors
## and matrices.

v <- c("a","b","c","def") # vector of type character (cf "abcdef")
v
v <- 1:10 # vector of type integer
v
m <- matrix(TRUE,nrow=3,ncol=3) # repeat
m
m <- matrix(1:9,nrow=3,ncol=3)
m

## EX: Create a numeric matrix X and a numeric vector b and print the
## product Xb. The operator for matrix multiplication in R is %*%. It
## requires that the dimensions of the operands be compatible. What
## happens if you use the regular multiplication operator * ? (Aside
## on repeating/recycling.)

## We pick out elements of a vector using bracket notation, usually in one of two ways.
## We can supply which indices we want or don't want, by number or (if
## available) by name. This corresponds to subscripts in usual math
## notation for sequences:

v[c(1,3)]
u <- -2
v[u]

## Or we can supply a vector of boolean values, T if you want to pick out that element and F otherwise.

v[c(TRUE,FALSE,TRUE,FALSE)]
v[c(TRUE,FALSE)]
v[v^2 > 49]
v^2 > 49

## For a matrix, we have two dimensions to consider, but otherwise we access elements in
## the same way for each dimension separately.

m[c(1,2),c(TRUE,FALSE,TRUE)]
x <- 1:3
m[c(1,2),x!=2]

## Back to factors:
gender <- c(0,1,1,0,1)
factor(gender,levels=c(0,1),labels=c('M','F'))
bracket <- c(5,1,9,2,4)
factor(bracket,levels=1:9,labels=c('A','B','C','D','E','F','G','H','I'))

## Now we introduce another complex data type: data frames. A data frame is 2-dimensional
## like a matrix, but whereas a matrix's elements must be of the same data type, a data frame
## may have columns of different simple types. For example:

bools <- c(TRUE,TRUE,FALSE,TRUE)
nums <- 1:4
df <- data.frame(bool.column=bools,num.column=nums)
df # could even have a column of type matrix
str(df)
c(bools,nums) # R will coerce the data to a single type if you try to use a vector or matrix

## We can pick out elements of a data frame in the same manner as a matrix.

df1 <- df[1:2,1]
df1
str(df1) # don't range over columns and result is a matrix/vector
df2 <- df[c(1,3),1:2]
df2
str(df2) # range over columns and result is a dataframe



## For data frames and list in general ([[to be discussed]]) we can also pick out
## elements using the "$" operator. Yet another method is the "subset"  method.

df$bool.column

mtcars
## EX: Print a data frame consisting of the 4-cyl cars that get <25
## mpg.
## Answer: ***


## Other complex data types are lists (1-D
## like a vector, but allowing heterogeneous, complex data types as
## elements) and arrays (generalizations of matrices to arbitrary
## dimensions).


## The final type of object we will discuss before moving on is
## functions. A function, as in mathematics, takes some input
## ("parameters" or "arguments") and returns some value. The main
## difference from a mathematical function are so-called "side
## effects" (e.g. graphics). "matrix" and "factor" above are examples
## of functions.

matrix(1:15,nrow=3,ncol=5)
matrix(1:15,3,5)
matrix(1:15,3)
matrix(1:15,ncol=3)
sigma2 <- var(mtcars$mpg)

## Some parameters are optional others required; see help for details.

## EX. Try to
## compute the variance yourself. The unbiased sample variance of observations
## x_1,...,x_n is (1/(n-1)) sum{i=1...n} (x_i - x.ave)^2, where x.ave
## is the average of x_1,...,x_n. [[Recall from last class the length()
## and sum() functions for vectors.]]

## answer:
## ***

## In R a function is just another object (a
## "noun") like integers etc. This idea will be useful to keep in mind
## in the second workshop. We will also learn how to define your own
## functions at that time.



## 2. Some built-in functions for exploring data

## Next, let's look at a few of R's tools for analyzing data. First, let's pull up a data set.
## Use "data" to pull up a list of data sets available to us based on our R and package
## installations. We will discuss reading data from a local or remote
## files in a later lecture.

data()
str(trees) # all numeric but customary to still package data in a df

## "attach" puts a data frame's columns in the name space. We can
## access them directly. (Detach to remove.)

attach(trees)
str(Girth)

## R has functions to compute the usual enumerations and statistics
## you might need.

table(Height)
mean(Volume)
var(Volume)
sd(Volume)
max(Height)
range(Height)
median(Height)
summary(Height) ## overloaded; try summary(mtcars)

## Our first graphical routine: a scatterplot matrix.
plot(trees)


## We can also visualize a data frame using a boxplot.

boxplot(trees)
boxplot(trees,main="trees dataframe",col="blue") ## more params later

## For 1-dimensional data we may like to see the histogram.

hist(Height)
hist(Height,breaks=10)
hist(Height,prob=T)


## Next, R provides a series of four functions for each common random
## variable distribution: random generation, quantile, tail, and
## density.

x <- rnorm(1000)
summary(x)
hist(x)

dnorm(0)
curve(dnorm,from=-3,to=3)
abline(h=dnorm(0),col="red")
hist(x,prob=T)
curve(dnorm,add=T)

qnorm(.05)
qnorm(.95)
qnorm(.5)

max(x)
pnorm(max(x))
pnorm(qnorm(.05))
abline(v=c(qnorm(.05),qnorm(.95)),col="red")

## Analogously, there is rt, pt, qt, dt for the t distribution, runif,
## punif, qunif, dunif for the uniform distribution, etc.

## The "lm" function is used for linear regression. The chief parameter
## is a model formula. A model formula has a form like "[[some
## response]] ~ [[some predictors]]. The tilde may be read as
## something like, "as a function of".

lm(Volume ~ Girth)
lm(Volume ~ Girth + Height)
lm(Volume ~ Girth + Height + Girth:Height)
lm(Volume ~ Girth - 1) # by default, lm includes intercept term
lm(scale(Volume,scale=F) ~ scale(Girth,scale=F))

lm0 <- lm(Volume ~ Girth)
str(lm0) # type "list" mentioned earlier, access components via "$"
summary(lm0) # overloading again - often worth checking out how an
             # object instantiates "summary" and "plot" methods

plot(lm0) ## more overloading

plot(Volume ~ Girth)
abline(lm0) # overloading


## Use "t.test" to compare means of normal data using tests based on
## t-statistics (paired or not, equal variance or not)
head(iris)
plot(Petal.Length ~ Species, data = iris) ## categorical predictor

versicolor.petal.len <- iris$Petal.Length[iris$Species=='versicolor']
virginica.petal.len <- iris$Petal.Length[iris$Species=='virginica']
t.test(setosa.petal.len,virginica.petal.len,var.equal=F)

lm1 <- lm(Petal.Width ~ Species, data = iris)
summary(lm1)
anova(lm1)
bartlett.test(Petal.Width ~ Species, data=iris) ## check model assumptions


## 3. More graphics


## We usually plot two-dimensional data using "plot". There are two ways to tell
## "plot" what to plot. One is a list of the x values and y values.

x <- 1:100
y <- x^2

plot(x,y)

## The second way is to specify a model formula.

plot(y ~ x)
plot(y ~ sqrt(x))

## You can set the # of plots appearing in a window by setting mfrow
par(mfrow=c(1,2))
plot(x,y)
plot(x,y)
## Some basic optional parameters we can supply to plot are:

## type
plot(x,y) ## plot again for comparison
plot(x,y,type="l")
## titles
plot(x,y)
plot(x,y,main="parabola",sub="an example")
## axis labels
plot(x,y)
plot(x,y,xlab="independent variable",ylab="dependent variable")
## graphical parameters like the plotting character, color, or size
plot(x,y)
plot(x,y,type="l",lty=2) # just google for the numbering scheme
plot(x,y)
plot(x,y,col="red")
plot(x,y)
plot(x,y,col=2) # google for the numbering scheme
plot(x,y)
plot(x,y,pch="*")
plot(x,y)
plot(x,y,cex=4)

## It is common to supply a vector for a graphical parameter, the elements of which
## correspond to elements of the x/y vectors:
plot(x,y)
plot(x,y,cex=x/100)
plot(x,y)
plot(x,y,col=x)
plot(x,y,col=c(1,3)) ## recycle the shorter vector



## If we already have a plot window open, we can use "abline" to add a line within its
## range. The parameters are either slope and intercept:
plot(x,y,type="l")
abline(a=0,b=100,col="red")

## or a the intercept if we want to plot a horizontal or vertical line:

plot(x,y,type="l")
abline(h=1000)

## R has a number of plotting commands that, like "abline", require a
## plotting window to already be open. Common examples are "points"
## and "lines" for overlaying plots of points and lines. We will see
## an example later.

## The third and final plotting command we will look at today is "curve". "curve"
## takes as a paramter a function to be plotted.

curve(sin)
curve(sin(x))
curve(sin,from=0,to=6*pi)
plot(x,y)
curve(x^2,add=T,col='red')





## 4. Getting data in and out of R

## A csv ("comma-seprated values") file is probably the most commonly
## used format for sharing 2-dimensional/tabular data. The rows are
## go into lines, and fields/column values within a row are separated
## by commas.

## Save a matrix to file using R's "write.csv" function, and read it
## back in using "read.csv".

write.csv(file="mtcars.csv",mtcars)

my.mtcars <-
  read.csv(file=[[***]]) ## look out for header flag

## If you need to move data to/from R and another program, csv files
## are usually an easy option. E.g., excel can read/write csv
## files. Or if you want to download govt data from the census bureau
## or SSA, you can get it in csv format. "write.table"/"read.table"
## are more general functions, e.g., for delimiters other than comma.

## save/load can be used to save and retrieve any R objects, but the
## format used is not standard.

x <- runif(40)
y <- letters
save(x,y,file='dat.RData')
rm(x); rm(y)
load('dat.RData')


## Use save.image() to store session.






## what if we want to plot a 3-D surface?

install.packages("car")
library(car)
scatter3d(Volume ~ Girth + Height, data=trees)
?scatter3d
install.packages()
scatter3d(Volume ~ Girth + Height, data=trees)

