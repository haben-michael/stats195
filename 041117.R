## Agenda:
## 1. User-defined functions
## 2. Example (numerical integration)
## 4. Dataset manipulation

## I would think of a function as a section of code packaged off as a unit.

## One might one to section off code in this way for a number of
## reasons, including: to reduce a large problem into smaller
## sub-problems, to avoid duplicating code in different parts of a
## program, to allow code to be packaged and reused in different
## programs or by different people.

## Let's start with an example and some terminology.

my.factorial <- function(n) { # "n" is the "parameter" or "argument"
  res <- 1 # the "body" of the function starts here
  for (i in 1:n)
    res <- res*i
  return(res) ## return value; by default returns last result in body
}

my.factorial(6)

## EX: Write a function "print.lm" that, given a 1-dimensional vector
## of predictors and another of responses, generates a scatterplot
## along with the regression line in red.


print.lm(1:10,(1:10)^2)
print.lm((1:10)^2,1:10)
print.lm(y=(1:10)^2,x=1:10) # can tag parameters rather than using the
                            # order of the formal parameters

print.lm() # error

## We can set default values to the parameters, which will allow the
## user to leave them unspecified.

print.lm <- function(x=1:10,y=(1:10)^2) {
## ...
}

print.lm()


## What if we want to pass along some unspecified set of arguments?
## E.g., in "print.lm", we might want to let the user set the
## graphical parameters of the plot.

print.lm <- function(x,y,...) { # add the formal parameter "..."
  lm0 <- lm(y ~ x)
  plot(x,y,...) # passed along here
  abline(lm0,col="red")
}

print.lm(1:10,(1:10)^2)
print.lm(1:10,(1:10)^2,type="l",col="green")

## Some details on scope.

## What method does R use to pass values to a function?

my.factorial <- function(n) {
  res <- 1
  for (i in 1:n)
    res <- res*i
  n <- 0
  return(res)
}

n <- 6
my.factorial(n)
n # R passes arguments by value

## Since R passes by value, you may be tempted to use a global
## variable to avoid passing a large data structure. However, R does
## not in the usual circumstances allow you to modify the scope
## outside of a function.

x <- 10

my.fn <- function() {
  x <- 20
}

x
my.fn()
x # R discourages side effects

## You can use "<<-" for assignment if you need to modify a variable
## in a parent scope. You might need to do this if you don't want to
## make copies of some large object by passing it as an argument.

my.fn <- function() {
  x <<- 20
}

x
my.fn()
x


## Functions in R are "first-class", i.e., can be treated like any
## other object (e.g.,  passed as parameters, created in any
## scope). Argument evaluation is lazy, i.e., R will not copy or
## process an argument inside a function unless it needs to. We will
## discuss these topics further if and as they come up in later examples.


## 2. Examples


##################################################
## Monte Carlo integration. Given f:[0,1]->R, U ~ Unif(0,1], then
## E[f(U)] is the integral of f(x). LLN says the running average of
## f(U_n), U_n iid Unif[0,1], converges to this integral.

## First, we outline the body of the function. Second, we implement
## this body. Third, we enclose the body as a function. Fourth, we
## use plot and other tools to visualize the convergence. Fifth, we
## save the results to file (and visulize the results for previously
## saved data).

## topics - looping, functions/abstraction/encapsulation, functions as
## arguments, random variable routines, saving and loading 2-d data

## (a) outline function body

## for each of N interations,
## get a new sample uniform variable
## update the running average


## (b) implement - you may find it helpful to implement a function by
## starting with the body in a concrete situation

f <- sin # function to approximate
N <- 20 # number of iterations/quality of approximation
running.sum <- 0

## for each of N interations,
for (i in 1:N) {
## get a new sample uniform variable
## EX: supply code
## update the running average
## EX: supply code
}

print(running.sum / N)
print(integrate(f,0,1))


## (c) abstract to a function

mc.integrate <- function(f,N=20) {
  running.sum <- 0

  ## for each of N interations,
  for (i in 1:N) {
      ## get a new sample uniform variable
      ## (EX)
      ## update the running average
      ## (EX)
  }

  return(running.sum / N)
}

## EX: Redo "mc.integrate" more efficiently by avoiding loops. Assume
## the parameter "f" is vectorized (could also use apply-type routines).


integrate(tan,0,1)
mc.integrate(tan,20)
mc.integrate(tan,200)


## (d) visualize convergence by examining the approximation for a
## number of iteration sizes

set.seed(1) # set seed to remove "randomness" in rng
f <- tan

Ns <- seq(from=1,to=501,by=5)
n.samples <- 20 # samples per N

samples <- matrix(nrow=n.samples,ncol=length(Ns))
colnames(samples) <- Ns
head(samples)

for (i in 1:ncol(samples)) {
  for (j in 1:nrow(samples)) {
    samples[j,i] <- mc.integrate(f,N=Ns[i])
  }
}


matplot(samples)

## would prefer to see at each N on x-axis, distribution of samples
matplot(t(samples)) # OK

matplot(t(samples),xlab="sample size",ylab="MC estimate",
     main="MC estimate as a function of sample size",pch=".",col="black",cex=2)

## EX: add a line for R's numerical integration

## Computing pi came up during the first class
total <- 3e6
num.inside <- 0
for(i in 1:total) {
    x <- runif(1)
    y <- runif(1)
    if(sqrt(x^2+y^2)<=1) num.inside <- num.inside+1
}

print(4*num.inside/total)

## EX: vectorize the pi approximation

## Reassigning assignment -- student question about warning when overwriting a constant or variable

`<-`  ## backtick to reference an operator
`=`
`+`
`+`(3,5)

`+` <- function(e1,e2)e1*e2
3+5
`+` <- `/`
5+2

ls() ## list named objects in the environment
yy <- 3
ls()
deparse(substitute(yy))
deparse(substitute(yy)) %in% ls()

old.assign <- `<-`
new.assign <- function(e1,e2) {
    string.name <- deparse(substitute(e1))
    if(e1=='pi') warning(paste0(e1,'already assigned'))
    ## if(e1 %in% ls()) ...
    ## call original function
    ## ...
}

################################################
## 2. Dataset manipulation


## Use "write.csv" and "read.csv" to save and retrieve two-dimensional
## data using the CSV format. When writing you want to pay attention
## to escape any commas in your data. When reading things you want to pay
## attention to include whether columns are labeled and whether string
## entries should be interpreted as factors. Note that you can
## pass these routines various URLs, not just a file (the default).

## FERC site:
## http://www.ferc.gov/docs-filing/eqr/soft-tools/sample-csv.asp

dat <-
  read.csv("http://www.ferc.gov/docs-filing/eqr/soft-tools/sample-csv/contract.txt",header=T)
str(dat)

## You can use "write" and "scan" to save and retrieve one or two
## dimensional data in a not quite standard text format using whitespace.

dat <- rnorm(100)
write(dat,"text.txt")
scan("text.txt")

## Use "save" and "load" to save and load any R objects in binary
## format. You can also save/retrieve your entire workspace using
## "save.image" and "load.image".



food <- read.csv('food-world-cup-data.csv')


US.idx <- which('Please.rate.how.much.you.like.the.traditional.cuisine.of.United.States.'==colnames(food))
MX.idx <- which('Please.rate.how.much.you.like.the.traditional.cuisine.of.Mexico.'==colnames(food))
knowledge.idx <- 2
interest.idx <- 3
## once we lookat text processing, we will learn the more common way to carry out the previous lines
food <- food[,c(knowledge.idx,interest.idx,US.idx,MX.idx)]
colnames(food) <- c('knowledge','interest','US','MX')

levels(food$knowledge)
table(food$knowledge)
food$knowledge <- as.integer(food$knowledge)
table(food$knowledge)
food$knowledge <- 4 - food$knowledge + 1

levels(food$interest)
food$interest <- factor(food$interest, levels=levels(food$interest)[c(2,3,4,1)])

## EX: "These questions were on a four-point scale, where a four indicated
## the greatest amount of interest and knowledge and a one the least
## amount. The weight given to a voter was calculated as the sum of
## these two scores, minus two." Convert the "interest" column also,
## then create the weight column.

food$interest <- as.integer(food$interest)
table(food$interest)
food$weight <- food$interest + food$knowledge - 2

## EX: "The results we'll show you are solely among people who had an opinion
## about both cuisines in a particular matchup. We call this the "turnout
## rate," and it varied anywhere from 7 percent to 65 percent depending
## on the matchup." Remove the rows with NAs from "food" after saving them in a dataframe "food.NA"

food.NA <- food[(food$US=='N/A') | (food$MX=='N/A'),]
food <- food[(food$US != 'N/A') & (food$MX != 'N/A'),] ## see "na.omit","drop.levels"
food$US <- as.integer(food$US)
food$MX <- as.integer(food$MX)
table(food$MX)
table(food.NA$weight)

food$MX.greater <- food$MX > food$US
str(food$MX.greater)
food$MX.greater <- food$MX.greater * food$weight
food$US.greater <-  (food$MX < food$US) * food$weight
food$equal <- (food$MX==food$US) * food$weight
str(food)
counts <- as.matrix(food[,c('US.greater','MX.greater','equal')])
xtabs(counts ~ food$weight)
str(xtabs(counts ~ food$weight))

xtabs0 <- xtabs(counts ~ food$weight)
rowSums(xtabs0)
table(food.NA$weight)
rowSums(xtabs0) + table(food.NA$weight)
NAs <- table(food.NA$weight)
str(NAs)
NAs[7] <- 0
names(NAs) <- 0:6
NAs
denom <- rowSums(xtabs0) + NAs
xtabs0 <- xtabs0 / denom

plot(rownames(xtabs0), xtabs0[,'US.greater'], type='l',col='blue')
lines(rownames(xtabs0), xtabs0[,'MX.greater'], type='l',col='green')

## SKIP 2017
## emails.dat <- read.csv('Emails.csv')
## str(emails.dat) ## all strings interpreted as factors
## emails.dat <- read.csv('Emails.csv',stringsAsFactors=F)
## str(emails.dat)

## ## would like to get most common recipients

## to.table <- table(emails.dat$MetadataTo)
## head(to.table)

## ## sorting data
## (x <- sample(1:10,10))
## order(x)
## order(x,decreasing=T)
## mtcars
## mtcars[order(mtcars$cyl),]
## mtcars[order(mtcars$cyl,mtcars$mpg),]

## ## EX: sort "to.table" to put the most common recipients first


## ## get list of most common senders and sort
## from.table <- table(emails.dat$MetadataFrom)
## from.table <- from.table[order(from.table,decreasing=T)]



## barplot(to.table[c(2,3,4,6,7)],col='blue')
## require(wordcloud)
## wordcloud(names(to.table))

## ## convert to data frames and join
## names(to.table)
## to.df <- data.frame(name=names(to.table),to.count=as.numeric(to.table))
## from.df <- data.frame(name=names(from.table),from.count=as.numeric(from.table))

## to.from <- merge(to.df,from.df,by='name')

## to.from <- to.from[order(to.from$to.count,decreasing=T),]









## 1. Factors and lists

## Use factors to represent categorical data. Just as numerics
## are used for continuous, real numbers, and integers represent whole
## numbers, factors are a basic data type in R used to represent data
## that assumes a fixed, finite number of values. Eg,
str(attenu)
## Factors may also be ordered:
str(esoph)

str(mtcars)
factor(mtcars$am,levels=c('1','0'),labels=c('auto','manual'))
factor(mtcars$am,levels=c('0','1'),labels=c('auto','manual'))
factor(mtcars$am,levels=c(1,0),labels=c('auto','manual'))
## Factors are simple to handle superficially but get messy when you
## need to do more with them. The idea is you can represent
## observations 'auto' or 'manual' internally with numbers like 0,1
## more efficiently. The levels are the distinct values your variable can
## assume, in character format. You can change how the internal
## representation of (0,1,...) appears using "labels".
factor(mtcars$cyl,levels=c(4,6,8),ordered=T)

## Lists are 1-dimensional like vectors, but each element may have a
## distinct data type, like a dataframe's columns. In fact a dataframe
## is essentially a list with elements that are vectors required to
## have the same length.
my.list <- list(a=1,b=5:9,c=c('asef','kjsd'))
## Access elements of a list using cash operator (like dataframes),
my.list$c
## or a variant of bracket notation
my.list[[3]]
my.list[3]
