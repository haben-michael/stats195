## 1
my.mean <- function(x) {
    n <- length(x)
    return(sum(x)/n)
}


## 2
my.var <- function(x) {
    n <- length(x)
    return(sum((x-my.mean(x))^2)/(n-1))
}

## 3
my.cor <- function(x,y) {
    n <- length(x)
    numer <- sum((x-my.mean(x))*(y-my.mean(y)))
    denom <- (n-1)*sqrt(my.var(x)*my.var(y))
    return(numer/denom)
}

## 4

collatz <- function(n) {
    stopifnot(n>0)
    print(n)
    while(n>1) {
        if(n%%2==0) {
            n <- n/2
        } else {
            n <- 3*n+1
        }
        print(n)
    }
}

collatz <- function(n) {
    print(n)
    if(n==1) return()
    if(n%%2==0) {
        collatz(n/2)
    } else {
        collatz(3*n+1)
    }
}

## EC
set.seed(100) ## for reproducibility

x0 <- rnorm(50)
y0 <- rnorm(50)
my.cor(x0,y0)
## I get .35. You might expect correlation to be closer to 0.


## with loop

results <- numeric(100)
for (i in 1:100) {
    x0 <- rnorm(50)
    y0 <- rnorm(50)
    results[i] <- my.cor(x0,y0)
}

print(mean(abs(results)>.3)) # just 1%

## without loop
dat <- matrix(rnorm(100*100),nrow=100,ncol=100)
results <- apply(dat,1,function(x){my.cor(x[1:50],x[51:100])})

print(mean(abs(results>.3))) # 2%



## 2.

