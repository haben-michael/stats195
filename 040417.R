## Haben Michael
## Stats195, Spr '17


## Agenda:
## 1. Data structures
## 2. Basic graphics
## 3. Basic data analysis
## 4. Worked example

## 1. Let’s first look at "things" or "nouns" in R: constants, variables, types.

## R has a few built-in constants. In R you can think of a constant as
## a pre-defined name-value pair.

pi # constant of numeric type
letters # constant of character/string type
cos
2+2 # operations on constants, R as a calculator
pi/2

## A variable can be thought of as a user-defined name-value pair.

x=3.14
x <- 3.14
x <- "a"
x

## EX: Create a variable called "myname" with value your name. Inspect "myname" at the prompt.


## A constant or variable has a type. First, languages have primitive/simple
## types. Common examples in R are a real number/double/numeric,
## character, or booleans/logicals. In R, the type of the value
## associated to a variable (name) may change.

pi
str(pi)
typeof(pi)
class(pi)
str(pi+3)
str("a")
TRUE
str(TRUE & FALSE)
str(TRUE | FALSE)

## Languages also have complex data types, "complex" in the sense of being
## built up from the simple types. Common examples in R are vectors
## and matrices.

v <- c("a","b","c","d") # vector of type character
v
v <- 1:10 # vector of type integer
v
m <- matrix(TRUE,nrow=3,ncol=3) # repeat
m
m <- matrix(1:9,nrow=3,ncol=3)
m

## We pick out elements of a vector using bracket notation, usually in one of two ways.
## We can supply which indices we want or don't want, by number or (if
## available) by name. This corresponds to subscripts in usual math
## notation for sequences:

v[c(1,3)]
u <- -2
v[u]
sum(v) # operations on vectors
length(v)
v+v # element-wise operation
v^2

## Or we can supply boolean values, T if you want to pick out that element and F otherwise.

v[c(TRUE,FALSE,TRUE,FALSE)]
v[c(TRUE,FALSE)]
v[v^2 > 49]
v^2 > 49

## EX: Replace the even elements in v with 0. The modulo/remainder operator is called "%%" e.g. "10 %% 3" returns 1.

## For a matrix, we have two dimensions to consider, but otherwise we access elements in
## the same way for each dimension separately.

m[c(1,2),c(TRUE,FALSE,TRUE)]
x <- 1:3
m[c(1,2),x!=2]
m[c(1,2),] # leave dimension blank to range over all values

## EX: Replace the bottom right element of m with the number 1. Replace the top row with the numbers 1,2,3.



## Now we introduce another complex data type: data frames. A data frame is 2-dimensional
## like a matrix, but whereas a matrix's elements must be of the same data type, a data frame
## may have columns of different simple types. For example:

bools <- c(TRUE,TRUE,FALSE,TRUE)
nums <- 1:4
df <- data.frame(bool.column=bools,num.column=nums)
df
str(df)
c(bools,nums) # R will coerce the data to a single type if you try to use a vector or matrix

## We can pick out elements of a data frame in the same manner as a matrix.

df1 <- df[1:2,1]
df1
str(df1) # don't range over columns and result is a matrix/vector
df2 <- df[c(1,3),1:2]
df2
str(df2) # range over columns and result is a dataframe

## For data frames and more generally lists (to be discussed) we can also pick out
## elements using the "$" operator. Yet another method is the "subset"  method (to
## be discussed as needed).

df$bool.column

## Other complex data types, to be discussed as needed, are lists (1-D
## like a vector, but allowing heterogeneous, complex data types as
## elements), arrays (generalizations of matrices to arbitrary
## dimensions), and factors (used for storing categorical data).

## EX: Create a new data.frame consisting of those rows of df where "bool.column" is TRUE.


## 2. Basic graphics

## We usually plot two-dimensional data using "plot". There are two ways to tell
## "plot" what to plot. One is a list of the x values and y values.

x <- 1:100
y <- x^2

plot(x,y)

## As usual if the lengths of the two parameters differ R will try to "recycle" the
## shorter (complaining if the longer one is not a multiple of the shorter).

## The second way is to specify a model formula.

plot(y ~ x)
plot(y ~ sqrt(x))

## I read the tilde as something like, "as a function of". We will encounter them
## again later.

## EX: plot the function y=sin(x) on the interval [0,8pi]


## Some basic optional parameters we can supply to plot are:

## type
plot(x,y,type="l")
## titles
plot(x,y,main="parabola",sub="an example")
## axis labels
plot(x,y,xlab="independent variable",ylab="dependent variable")
## graphical parameters like the plotting character, color, or size
plot(x,y,type="l",lty=2) # just google for the numbering scheme
plot(x,y,col="red")
plot(x,y,col=2) # google for the numbering scheme
plot(x,y,pch="*")
plot(x,y,cex=4)

## It is common to supply a vector for a graphical parameter, the elements of which
## correspond to elements of the x/y vectors:
plot(x,y,cex=x/100)
plot(x,y,col=x)


## If we already have a plot window open, we can use "abline" to add a line within its
## range. The parameters are either slope and intercept:
plot(x,y,type="l")
abline(a=0,b=100,col="red")

## or the intercept if we want to plot a horizontal or vertical line:

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
curve(x^2,add=T)

## EX: Plot the arc tangent function ("atan" in R) with dashed horizontal lines indicating the asymptotes at +/- pi/2



## 3. Some Statistical tools

## Next, let's look at a few of R's tools for analyzing data. First, let's pull up a data set.
## Use "data" to pull up a list of data sets available to us based on our R and package
## installations. We will discuss reading data from a local or remote
## files in a later lecture.

data()
str(trees) # all numeric but customary to still package data in a df
plot(trees) # overloading

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
summary(Height)


## EX: Manually verify the variance of "Volume". The unbiased sample variance of observations
## x_1,...,x_n is (1/(n-1)) sum{i=1...n} (x_i - x.ave)^2, where x.ave
## is the average of x_1,...,x_n.


## We saw that "plot", when supplied with a data frame, generates a
## scatter plot matrix. We can also visualize a data frame using a
## boxplot.

boxplot(trees)
boxplot(trees,main="trees dataframe",col="blue")

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

## The "lm" function is used for linear regression. The main parameter
## is a model formula. We saw a basic model formula of the form y ~ x
## as a parameter to "plot".

lm(Volume ~ Girth)
lm(Volume ~ Girth + Height)
lm(Volume ~ Girth + Height + Girth*Height)
lm(Volume ~ Girth - 1) # by default, lm includes intercept term
lm(scale(Volume,scale=F) ~ scale(Girth,scale=F))

lm0 <- lm(Volume ~ Girth)
str(lm0) # type "list" mentioned earlier, access components via "$"
summary(lm0) # overloading again - often worth checking out how an
             # object instantiates "summary" and "plot" methods

plot(lm0)

plot(Volume ~ Girth)
abline(lm0) # more overloading











## 4. Let's use some of these tools to perform a linear
## regression. We first use R to compute the regression, using "lm",
## to check our following computations against.

trees.lm <- lm(Volume ~ Height - 1)
summary(trees.lm)
plot(trees.lm$residuals ~ Height)
abline(h=0) # doesn't look like it satisfies model assumptions

plot(Volume ~ Height)
abline(trees.lm,col="red")


## Call:
## lm(formula = Volume ~ Height - 1)

## Residuals:
##     Min      1Q  Median      3Q     Max
## -18.031 -11.184  -7.407   7.755  41.788

## Coefficients:
##        Estimate Std. Error t value Pr(>|t|)
## Height  0.40473    0.03545   11.42 1.91e-12 ***
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

## Residual standard error: 15.05 on 30 degrees of freedom
## Multiple R-squared: 0.8129,	Adjusted R-squared: 0.8067
## F-statistic: 130.4 on 1 and 30 DF,  p-value: 1.91e-12


## Regress Volume on Girth. What is the multiple of Girth, beta*Girth
## for some real number beta, that minimizes the length of (Volume -
## beta*Girth)? You can think of univariate regression as
## simply projecting one vector on another.

y <- trees$Volume
x <- trees$Height
mod.x <- sqrt(sum(x^2))
beta <- (x %*% y) / mod.x^2 # matches lm output

plot(y ~ x, xlab='Height', ylab='Volume', main='Tree Regression', type='p')
abline(a=0,b=beta,col='red')

y.fitted <- beta*x
trees.lm$fitted.values # matches lm output


## What if we want to see the regression line passing through the origin?
abline(h=0,lty=2)
## plots with type='n', setting the axis ranges
plot(0,xlim=c(0,max(x)),ylim=c(0,max(y)),type='n')
points(x,y)
## with annotations
plot(0,xlim=c(0,max(x)),ylim=c(0,max(y)),type='n', xlab='Height',
     ylab='Volume', main='Tree Regression')
points(x,y)
abline(a=0,b=beta,col='red')
abline(h=0,v=0,lty=2)
## adding legends
legend("topleft",legend=c("regression line","cartesian axes"),col=c('red','black'),lty=c(1,2))


## residuals
residuals <- y-y.fitted
residuals
trees.lm$residuals # matches lm output

## Computing the standard error estimate and coefficient inference. Some statistics:
## under standard assumptions, an unbiased estimate of the error variance
## is the sum of squares of the residuals divided by the degrees of
## freedom. The degrees of freedom are the number of observations
## less the number of independent variables.

## An estimate of the variance of beta is obtained by dividing this
## error variance by the squared length of x.

## Again under standard assumptions on the error terms, under the
## hypothesis of no effect (beta=0), beta divided
## by its standard deviation has Student's t distribution with the
## degrees of freedom given above.

SSE <- sum(residuals^2)
n <- length(x)
p <- 1
df <- n-p
var.est <- SSE/df
sd.est <- sqrt(var.est)

var.beta <- var.est/(x%*%x)
sd.beta <- sqrt(var.beta)
sd.beta ## matches lm output
t.val <- beta/sd.beta
t.val ## matches lm output
pt(t.val,df=df)
p.val <- 1-pt(t.val,df=df)
p.val <- pt(t.val,df=df,lower.tail=F)
p.val*2 ## matches lm output

## plot p-value
curve(dt(x,df=df),-20,20)
abline(v=c(t.val,-t.val),col="red")

## model fit
SST <- sum(y^2)
R.sqr <- 1 - SSE/SST

df.e <- n-p-1 #df of SSE
df.t <- n-1 #df of SST
R.sqr.adj <- 1 - (SSE/df.e)/(SST/df.t)

df.1 <- n - (n-1)
df.2 <- n-1
F.stat <- ((SST-SSE)/df.1) / (SSE/df.2)
pf(F.stat,df1=df.1,df2=df.2,lower.tail=T)











## multivariate example
tree.lm <- lm(trees$Volume ~ trees$Girth + trees$Height)
tree.lm <- lm(Volume ~ Girth + Height, data=trees)

summary(tree.lm)
## Call:
## lm(formula = Volume ~ Girth + Height, data = trees)

## Residuals:
##     Min      1Q  Median      3Q     Max
## -6.4065 -2.6493 -0.2876  2.2003  8.4847

## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)
## (Intercept) -57.9877     8.6382  -6.713 2.75e-07 ***
## Girth         4.7082     0.2643  17.816  < 2e-16 ***
## Height        0.3393     0.1302   2.607   0.0145 *
## ---
## Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1

## Residual standard error: 3.882 on 28 degrees of freedom
## Multiple R-squared: 0.948,	Adjusted R-squared: 0.9442
## F-statistic:   255 on 2 and 28 DF,  p-value: < 2.2e-16

## build X matrix (i.e., independent variables)
***

## coefficient estimates

***

## errors and inferences

***

## model fit

***

## plot f-statistic
***

## what if we want to plot a 3-D surface?

install.packages()
library(car)
scatter3d(Volume ~ Girth + Height, data=trees)
?scatter3d
install.packages()
scatter3d(Volume ~ Girth + Height, data=trees)

