## Agenda
## 1. Application of text processing: How many videos are on youtube?
## 2. How does the distribution of view counts of youtube videos look?




## 1. Estimating the number of videos on youtube.

## Most data scrapes begin by inspecting and experimenting with the target
## site's structure. This can be tedious, the methods are ad hoc, and
## you may violate the site's terms of service. From playing with
## youtube's searches and looking at the results pages, it looks like
## 1) youtube appears to assign all videos an 11-character ID and 2)
## you can pull the results for all videos with IDs that have a
## given prefix "***" by doing a search for "watch?v=***" (quotes
## included in search string), which is URL encoded as
## %22watch%3Fv%3D***%22". [[UPDATE SPR '16: The search string now
## only returns videos with a hyphen following the prefix. Also no
## longer case-sensitive. Adjust estimates below.]]


## We can then use "scan" to programmatically download a page of
## hits. Suppose we want to pull videos with ID prefix beginning
## "KuO9-".

hits.url <- "http://www.youtube.com/results?search_query=%22watch%3Fv%3DKuO9%22"
hits.html <- scan(hits.url,what="",sep="\n")
hits.html[1]

## Next, we inspect the webpage and try to find some string to zoom in
## on the number of hits. It looks like "num-results" works. Then we
## can use the text processing tools we've discussed to
## programmatically pull the number of hits.

match.idx <- grep("num-results",hits.html)
match <- regexpr("num-results[^0-9]*[[:digit:]]+",hits.html[match.idx])
## get all matches
(match <-
    regexec("num-results[^0-9]*([[:digit:]]+)",hits.html[match.idx]))
num.results <-
    substr(hits.html[match.idx],match[[1]][2],match[[1]][2]+attr(match[[1]],'match.length')[2]-1)
num.results <- as.numeric(num.results)

library(stringr)
(match <-
 str_match(hits.html[match.idx],"num-results[^0-9]*([[:digit:]]+)")) # using stringr library instead
(num.results <- as.numeric(match[2]))


## Next, we have R run through all pages with initial prefix of length
## 1. First we write a utility function.

## function to get initial page of videos with id.prefix as video id
## prefix
get.hits <- function(id.prefix) {
  hits.url <-
    paste0("http://www.youtube.com/results?search_query=%22watch%3Fv%3D",
           id.prefix,"%22")
  hits.html <- scan(hits.url,what="",sep="\n")
  return(hits.html)
}

id.alphabet <- c(letters,0:9)
sum <- 0
for (prefix in id.alphabet[1:5]) {
  hits.html <- get.hits(prefix)

  ## extract number of results
  match <-
   str_match(hits.html[match.idx],"num-results[^0-9]*(\\d+)")
  num.results <- as.numeric(match[2])
  ## match.idx <- grep("num-results",hits.html)
  ## match <- str_extract(hits.html[match.idx],"[[:digit:]]+")
  ## num.results <- as.numeric(match)
  cat("prefix: ",prefix,"-: ",num.results," videos\n",sep='')

  sum <- sum+num.results

  Sys.sleep(1)
}

print(sum)

## Look suspicious?

sum <- 0
for (prefix in id.alphabet[1:5]) {
  hits.html <- get.hits(prefix)

  ## extract number of results
  ## EX: Use an appropriate regex to extract the number of hits.
  match <-
      str_match(hits.html[match.idx],"num-results[^0-9]*((\\d)+)")
  num.results <- match[2]
  ## EX: Process the regex so that it maybe converted to a number.
  num.results <- as.numeric(num.results)
  cat("prefix: ",prefix,": ",num.results," videos\n")

  sum <- sum+num.results

  Sys.sleep(1)
}

print(sum) # does this look right?
## ***non uniformity re initial underscore, diff bw initial/
## non-initial char
## ** test for uniformity

## More generally: have R pull the number of results
## repeatedly, on a number N.searches of pages with a number
## prefix.length of initial video ID characters.


N.searches <- 5
max.prefix.length <- 5 ## [[SPR '16: add 1 for effective length]]

results <- matrix(nrow=N.searches,ncol=max.prefix.length)
id.prefixes <- matrix(nrow=N.searches,ncol=max.prefix.length)

for (prefix.length in 1:max.prefix.length)
  for (i in 1:N.searches) {
    ## generate a prefix
    id.prefix <- sample(id.alphabet,size=prefix.length,replace=T)
    id.prefix <- paste(id.prefix,collapse="")
    hits.html <- get.hits(id.prefix)
    id.prefixes[i,prefix.length] <- id.prefix

    ## extract number of results
    match <-
        str_match(hits.html[match.idx],"num-results[^0-9]*([\\d,]+)")
    ## match.idx <- grep("num-results",hits.html)
    ## match <- str_extract(hits.html[match.idx],"([[:digit:]]|,)+")
    num.results <- match[2]
    num.results <- as.numeric(gsub(",","",num.results))

    ## store result
    results[i,prefix.length] <- num.results

    Sys.sleep(1)
  }

results
id.prefixes

## EX: Save the column means in a vector "means".
means*length(id.alphabet)^(1:max.prefix.length+1)

## We can increase N.searches for a longer scrape and less variable
## figures. Compare number of results returned with empty search.





## 3. How does the distribution of view counts look? We can also use
## the ID prefixes to randomly sample youtube videos, assuming as
## before that youtube assigns videos uniformly over the space of all
## IDs. Again, this assumption is just a guess.

## From inspecting a page of results, it looks like
## "yt-lockup-meta-info" tags the view counts of the videos but it
## shows up elsewhere as well.

hits.html <- get.hits("kuO9")
vid.counts <- grep('[[:digit:]|,]+ views',hits.html) ## right number?
## EX: Replace the previous line to handle videos with a single view count.
match <- hits.html[vid.counts[1]]
match <- str_extract(match,"([[:digit:]]|,)+ views?")
match <- str_extract(match,"([[:digit:]]|,)+")
match <- gsub(",","",match)
match

## EX: Write a more specific regex--use "yt-lockup-meta-info".



## Next we have R repeat the same many times. Again we use a loop with
## a body substantially the same as the preceding block.

library(stringr)

get.hits <- function(id.prefix) {
  hits.url <-
    paste0("http://www.youtube.com/results?search_query=%22watch%3Fv%3D",
           id.prefix,"%22")
  hits.html <- scan(hits.url,what="",sep="\n")
  return(hits.html)
}


id.alphabet <- c(letters,0:9)
N.searches <- 2e2
prefix.length <- 4
counts <- numeric(0)

for (i in 1:N.searches) {
  if (i%%10==0) cat("search ",i,"...\n")
  ## generate a prefix, get hits html
  id.prefix <- sample(id.alphabet,size=prefix.length,replace=T)
  id.prefix <- paste(id.prefix,collapse="")
  hits.html <- get.hits(id.prefix)
  print(paste0("prefix: ",id.prefix,"-"))

  ## check that number of hits matches number of view counts grepped
  match <-
      str_match(hits.html[match.idx],"num-results[^0-9]*([\\d,]+)")
    ## match.idx <- grep("num-results",hits.html)
    ## match <- str_extract(hits.html[match.idx],"([[:digit:]]|,)+")
  num.results <- match[2]
  num.results <- as.numeric(gsub(",","",num.results))
  if (num.results==0) next
  print(paste0(num.results," results..."))

  ## vid.counts <- grep('[[:digit:]|,]+ views?',hits.html)
  ## if (num.results != length(vid.counts)) {
  ##   print("result count different from number of results")
  ##   next # discard results for this search - list order may not be random
  ## }

  for (j in 1:length(vid.counts)) {
    match <- hits.html[vid.counts[j]]
    match <- str_extract(match,"([[:digit:]]|,)* views?")
    match <- str_extract(match,"([[:digit:]]|,)*")
    match <- gsub(",","",match)
    if (is.na(match)) match <- 0
    counts <- c(counts,as.numeric(match))
  }

  Sys.sleep(1)
}



## write(counts,file="/gdrive/stanford/stats195/counts.txt")
counts <- scan(file="counts.txt")



summary(counts)
hist(counts)
boxplot(counts)



## try log transform
counts.log <- log(1+counts)
table(counts.log[counts.log<=3])
boxplot(counts.log)
hist(counts.log,prob=T)
hist(counts.log,prob=T,breaks=50)


mle <- mean(counts.log)
u <- seq(0,max(counts.log),by=1)
v <- dpois(u,lambda=mle)
points(u,v,type="l",col="red")

hist(counts.log,prob=T,breaks=50)
mle <- mean(counts.log)
u <- seq(0,max(counts.log),by=1)
v <- dpois(u-1,lambda=mle)*(1-mean(counts.log==0))
points(u,v,type="l",col="red")





## [[SKIPPED 2016]]
## mle <- mean(counts.log)
## u <- seq(0,max(counts.log),by=1)
## v <- dpois(u,lambda=mle)
## plot(u,v,type="l")

## counts.tab <- table(counts.log)
## counts.tab
## names(counts.tab)
## total <- sum(counts.log)
## points(as.numeric(names(counts.tab)),counts.tab/total,col="red")





## ## kernel density estimate
## bins <- seq(from=min(counts)-0.5,to=max(counts),length.out=1e3)
## binned <- cut(counts,breaks=bins)

## ## get midpoint of each bin
## levs <- levels(binned)[binned]
## head(levs)
## levs <- lapply(levs,strsplit,split=",")
## head(levs)
## lower <- lapply(levs,function(x){x[[1]][1]})
## head(lower)
## upper <- lapply(levs,function(x){x[[1]][2]})
## ## lower <- sub("(","",lower) # bug - escape sequence
## lower <- sub("\\(","",lower)
## upper <- sub("]","",upper)
## lower <- as.numeric(lower)
## upper <- as.numeric(upper)
## midpoints <- (upper+lower)/2

## glm0 <- glm(counts ~ poly(midpoints,8), family=poisson)












