## Agenda:
## 0. Clarificatoins from last class
## 1. Conditionals
## 2. Iteration

## 0a. Student question about overlaying plots -- line and point
## 0b. abline overloading on lm

## Up until now we have mainly been using R interactively, something
## like a very elaborate calculator. R is also a full featured
## programming language. Today we look at some of these aspects of R,
## which will allow you to create more structured scripts.

## 1. You can use "if" statements if you want code to be executed only
## when a condition is met, and "if-else" statements to further
## specify an alternative.

x <- 1

if (x==1) print ("equal 1") # parentheses around the test condition is obligatory

if (x==1) print("equal 1") else print("not equal 1")

if (x==1)
  print("equal 1")
else print("not equal 1") # error - because of the line break R
                          # thinks the "else" is being used without a
                          # leading "if"

if (x==1) {
  print("equal 1")
} else { # fine - the closing brace connects the "else" to the "if"
  print ("not equal 1")
}

## EX: Print "yes" if 395868382 is divisible by 7, "no" otherwise


## if-else, and most other programming structures we use today, expect
## to work with a single expression. So if you have multiple
## statements you should put them in braces so as to be interpreted as
## a single expression.

y <- 4
x <- y^2

(x <- 0)

x <- {y <- 4
      y^2}


if (1==2)
  print("conditionally run")
print("unconditionally run")

if (x==1) {
  print("first statement")
  print("equals 1")
  print("third statement")
}

## EX: Print "yes" if 395868382 is a multiple of 7, "no" otherwise. If
## it is not, print out the nonzero remainder.



## R also has an if-else statement "ifelse" that operates on a vector,
## which we will use if needed.


## 2. Three ways to run commands iteratively in R are "for", "while"
## and "repeat" loops. "for" loops appear most frequently.

for (i in 1:10) print(i)

for (i in 1:10) {
  j <- i^2
  print(i)
} # as with if-else, use braces for multiple statements

for (x in c("a","d","j")) print(x)

## Use "next" (corresponding to "continue" in other languages) to jump
## to the next iteration of the loop, ignoring what follows in the
## body of the loop.
for (i in 1:10) {
  if (i %% 2 == 0) next else print(i)
}

## EX: print out every other letter of the alphabet


## Whereas "for" iterates through the body of the loop for each
## element in a vector ("for i in 1 to 10 ...") "while" iterates
## through the body of the loop as long as a condition is meet.

i <- 1
ans <- 1
while (i <= 5) {
  ans <- ans*i
  i <- i+1
}
ans

## print the character "x" for 3 seconds
t <- Sys.time()
while(Sys.time() <= t+3) print("x")

## R also has a repeat command. Iteration is ended with the "break"
## command ("break" can be used in "for" and "while" loops, as
## well). One usually uses repeat loops over while loops in situations
## where one expects the loop to run for at least one iteration
## (although in R this need not be the case since you can break the
## loop at any point in its body including the first line).

i <- 1
ans <- 1
repeat {
    ans <- ans*i
    i <- i+1
    if (i>5) break
}
print(ans)


## In general you can always use a "for" loop in lieu of a "while" loop (and vice
## versa) and in R you can use a "for" loop in lieu of a "repeat"
## loop. And R generally discourages iterative structures, anyway. So
## you can probably get away with just learning "for" loops.

## Note, there is a strong preference among many R users to avoid looping over
## smaller sub-objects in favor of code treating the entire object
## simultaneously.  E.g., to print out the squares of 1...10, rather than:

x <- 1:10
for (i in 1:10) print(x[i]^2)

## to prefer:

print(x^2)

## Or, to compute a factorial, rather than:

x <- 1:5
ans <- 1
for (i in 1:5) ans <- ans*x[i]
ans

## to prefer:

prod(x)

## R provides many functions that are meant to operate over
## larger objects like vectors or matrices (like "prod" above) and
## most package designers follow this convention.

## In this connection, let us introduce "apply". Use "apply" to apply
## a function along a particular dimension of a matrix (more
## generally, any array). Take for example the trees matrix,

trees

## and suppose you would like to print the sum of each row. You could do this
## with a loop:

## EX: Print the row sums for the tree data. You can use "sum" or you
## can use a nested loop.


## but you could also use "apply" along the 1st dimension of the
## matrix, which is the rows:

apply(trees,1,sum)

## and similarly, if one wanted to compute the mean of the columns:

apply(trees,2,mean)
apply(trees,2,sd)

## There are other routines in R that, like "apply" permit you to
## avoid iterative structures, e.g., "lapply", "Reduce", etc., which
## we will discuss as needed.


## R is optimized to operate in this way, treating data structures
## being treated as units (rather than, say, looping over small
## structures).
n <- 1e+5

start <- Sys.time()
sum <- 0
for (i in 1:n) sum <- sum + rnorm(1)^2
end <- Sys.time()
print(end - start) ## could also use "system.time()"

start <- Sys.time()
x <- rnorm(n)
sum <- sum(x^2)
end <- Sys.time()
print(end - start)

## Why wouldn't R's compiler simply produce the same code in both
## instances, to let users use whatever style they prefer? The
## semantics are different. E.g., vectorized operations require data
## to be pre-allocated. You might have to use a loop if not all your
## data can be stored in memory at once. But the difference is mostly
## stylistic. Under the hood it's all a for loop. If we were more
## careful in the for loop above (e.g., not allocating a new block of
## memory on each rnorm call) we could bring down the speed difference.










## Help in R: R has features that may seem unstandard coming from
## other languages, and error messages are often opaque. But
## there are many sources of clarification.

## If a particular R function is giving you difficulty, you can use
## "?"  to pull up its help screen. This contains information like its
## formal parameters, their default values, return value, and similar
## functions. If you are first learning about a function, the help
## page for certain functions can be so detailed as to be overwhelming
## -- it is designed as a reference mainly. To learn about a function,
## though, there are often helpful examples at the end of the page,
## which I have often zoomed right down to, ignoring the rest.

## If you don't know the name of a function in R but want to know if R
## has some functionality, you can try "??". This string searches
## through the reference header information (whereas "?" requires the
## actual name of R object). For example, if I want to know how to
## compute a logistic regression, I could do "??logistic", and then I
## would read up on the "glm" function that is mentioned.

## Next, for a more involved questions ("Why does R^2 increase when I
## tell lm to remove the intercept?") you can search the R mailing
## archive at:

## http://tolstoy.newcastle.edu.au/R/

## This is a mailing list monitored by a number of experts and
## language contributors. The above query led to an explanation in
## this thread:

## https://stat.ethz.ch/pipermail/r-help/2012-June/316751.html

## Finally, these days it is usually helpful to just throw your
## question into google, putting "R" at the beginning of the
## search. Stackexchange or the R mailing list will often have a
## hit. E.g., if I get a cryptic error message, I usually put it in
## google.



