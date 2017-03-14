## Agenda:
## 1. Continue email dataset example
## 2. Loose ends--factors and lists
## 3. Text processing without regexs


## 1. Dataset manipulation--continued


## Use "write.csv" and "read.csv" to save and retrieve two-dimensional
## data using the CSV format. When writing you want to pay attention
## to escape any commas in your data. When reading things you want to pay
## attention to include whether columns are labeled and whether string
## entries should be interpreted as factors. Note that you can
## pass these routines various URLs, not just a file (the default).

## You can use "write" and "scan" to save and retrieve one or two
## dimensional data in a not quite standard text format using whitespace.

dat <- rnorm(100)
write(dat,"text.txt")
scan("text.txt")

## Use "save" and "load" to save and load any R objects in binary
## format. You can also save/retrieve your entire workspace using
## "save.image" and "load.image".

emails.dat <- read.csv('Emails.csv')
str(emails.dat) ## all strings interpreted as factors
emails.dat <- read.csv('Emails.csv',stringsAsFactors=F)
str(emails.dat)

## would like to get most common recipients

to.table <- table(emails.dat$MetadataTo)
head(to.table)

## sorting data
(x <- sample(1:10,10))
order(x)
order(x,decreasing=T)
mtcars
mtcars[order(mtcars$cyl),]
mtcars[order(mtcars$cyl,mtcars$mpg),]

## EX: sort "to.table" to put the most common recipients first


## get list of most common senders and sort
from.table <- table(emails.dat$MetadataFrom)
from.table <- from.table[order(from.table,decreasing=T)]



barplot(to.table[c(2,3,4,6,7)],col='blue')


## ggplot preview

## convert to data frames and join
names(to.table)
to.df <- data.frame(name=names(to.table),to.count=as.numeric(to.table))
from.df <- data.frame(name=names(from.table),from.count=as.numeric(from.table))

## to.from <- merge(to.df,from.df,by='name')
## to.from <- to.from[order(to.from$to.count,decreasing=T),]

require(ggplot2)
gg.df <- data.frame(person=c(names(to.table),names(from.table)),
                  count=c(as.numeric(to.table),as.numeric(from.table)),
                  to.from=factor(rep(c('to','from'),c(length(to.table),length(from.table)))))

head(gg.df) ## "long format"

4 %in% 1:4
1:10 %in% 1:4

gg.df <- gg.df[order(gg.df$count,decreasing=T),]
ggplot(gg.df[gg.df$person %in% c('H','Abedin, Huma','Mills, Cheryl D', 'Sullivan, Jacob J'),],aes(x=person,y=count,fill=to.from))+geom_bar(position='dodge',stat='identity')


## EX: Clean up data a bit--combine some Huma Abedin, Cheryl Mills,
## and Jake Sullivan rows to account for some of the aliases, then
## replot


## Whenever you find yourself doing something repetitive tedious with
## a computer, try to find a way to automate it. We will do so to
## handle the aliases but first we need some more tools.


## 2. Factors and lists

## Use factors to represent categorical data. Just as numerics
## are used for continuous, real numbers, and integers represent whole
## numbers, factors are a basic data type in R used to represent data
## that assume a fixed, finite number of values. Eg,
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
## more efficiently. Also many R routines will treat factors in a
## special way. The levels are the distinct values your variable can
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

unlist(list(a=1:5,b=6:10))
unlist(list(a=1:5,b=letters[1:5]))

lapply(my.list,function(v)length(v)) ## anonymous function

## EX: Use lapply to get a vector of booleans indicating whether the
## length of each element of "my.list" has length 0 ("true") or >0
## ("false")


## [[SKIPPED 2016]]
## ## What if we want to perform some task on each year of data? Eg, we
## ## might want to see the most popular name in a year. Or we might want
## ## to see the proportion of the names that begin or end in a vowel
## ## over the years. Use 'aggregate'.
## mtcars
## aggregate(mtcars,by=list(cyl=mtcars$cyl),mean)
## aggregate(mtcars,by=list(cyl=mtcars$cyl,am=mtcars$am),mean)
## aggregate(mtcars,by=list(am=mtcars$am,cyl=mtcars$cyl),mean)



## 3. Text processing

## R represents strings as type "character". This may seem strange if
## you are used to a "character" data type representing a single
## character, and a string being an array of such characters.

## basic string operations--print,cat,paste,strsplit,nchar

s1 <- "this is"
s2 <- "a string"
print(s1)
cat(s1)
cat(s1,s2,'\n')
(s <- paste(s1,s2)) # paste to concatenate
(s <- strsplit(s,split=" ")) # returns list of vector of character
                             # type
(s <- paste(s1,s2))
strsplit(s,split="")
s <- s[[1]]
length(s)

paste('a','b','c')
paste(s[1:3],collapse="") # paste to convert list to string
paste(s,collapse=" ")

## EX: Print the string "s" but with hyphens between all
## characters of the words. You might need to use lapply.


## wordcloud on email bodies
emails.dat <- read.csv('Emails.csv',stringsAsFactors=F)
words <- strsplit(emails.dat$ExtractedBodyText,' ')
words <- unlist(words)
require(wordcloud)
word.table <- table(words)
wordcloud(names(word.table),freq=word.table,max.words=200)
## for stemming and stop words look into nlp packages
require(tm)
emails.dat <- read.csv('Emails.csv',stringsAsFactors=F)
corpus <- Corpus(DataframeSource(data.frame(emails.dat$ExtractedBodyText)))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removeWords, stopwords('english'))
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, stemDocument)
wordcloud(corpus,max.words=200)

## EX: Check whether the word "will" is in the English stopwords list.


bn <- read.csv('http://www.ontario.ca/sites/default/files/opendata/ontariotopbabynames_female_1917-2010_english.csv',header=T,skip=1,stringsAsFactors=F)
str(bn)

## EX: Would you say this data frame is in long or in wide format?

bn$Frequency <- as.numeric(bn$Frequency)

bn.list <- split(bn,bn$Year)
bn.list[[1]]
dorothy <- lapply(bn.list,function(df) {
    df$Frequency[which(df$Name=='DOROTHY')]
}
                  )
dorothy <- as.matrix(dorothy)
plot(rownames(dorothy),dorothy,type='o',
     main='frequency of the name dorothy among Ontario births',
     xlab='year',ylab='frequency per 100k births')

plot(Frequency ~ Year,dat=bn[bn$Name=='DOROTHY',],type='o')


## letter frequencies in names
bn.1917 <- bn.list[[1]]
names.1917 <- bn.1917$Name
## EX: Create a character vector "chars.1917" with an entry for each
## letter occurring in the 1917 names (ie, with multiplicities).

table.1917 <- table(chars.1917)
plot(table.1917)

bn.2010 <- bn.list[[length(bn.list)]]
names.2010 <- bn.2010$Name
## EX repeated for 2010 data
table.2010 <- table(chars.2010)
par(mfrow=c(1,2))
plot(table.1917,main='letter counts, 1917 birth names')
plot(table.2010,main='letter counts, 2010 birth names')
par(mfrow=c(1,1))
#plot(table.2010-table.1917,main='letter count differences, (2010)-(1917)')


## Since strings aren't vectors, you can't use 'length' to get their
## length; use nchar.
nchar(s1)
nchar(s2)
## Earlier I mentioned one benefit of factors is they store long
## strings internally as single integers. Does natural language show
## this kind of efficiency, where frequency is inversely related to
## space requirements?
dq.text <- scan('http://www.gutenberg.org/cache/epub/2000/pg2000.txt',what='',sep=' ',quote=NULL)
dq.text <- dq.text[!(dq.text=='')]
dq.table <- table(nchar(dq.text))
plot(dq.table,main='word count vs. word length, Don Quixote')
plot(dq.table/length(dq.text),main='word freq. vs. word length, Don Quixote')


## [[SKIPPED 2016]]
## mtcars
## plot(mpg ~ disp, data=mtcars,xlab='displacement',ylab='mpg')
## ## might want to highlight relationship to # cylinders
## plot(mpg ~ disp, data=mtcars,xlab='displacement',ylab='mpg',
##      col=cyl) # now need a legend
## ## can use labels
## text(x=mtcars$disp[1],y=mtcars$mpg[1],labels='a label')
## plot(mpg ~ disp, data=mtcars,xlab='displacement',ylab='mpg')
## text(mtcars$disp,mtcars$mpg,labels=mtcars$cyl)
## plot(mpg ~ disp, data=mtcars,xlab='displacement',ylab='mpg',pch='.')
## text(mtcars$disp,mtcars$mpg,labels=mtcars$cyl)


## grep,sub,substr

## Use grep to find matches in a vector of strings.
grep("i",c('a','e','i','o','u'))


mtcars
grep('Merc',rownames(mtcars))
## EX: Print a sub-dataframe of the motor trend cars data consisting only
## of Mercedes.

dorothy <- bn[grep('DOROTHY',bn$Name),]
plot(dorothy$Year,dorothy$Frequency,type='o')


## Use sub and gsub to make substitutions
sub(pattern='i',replacement='*','this is')
sub(pattern='i',replacement='*','this is a string')
gsub(pattern='is',replacement='*','this is a string')

mtcars
## EX: Rename the rows of "mtcars" beginning with "Merc" to begin with "Mercedes".

## Use substr to extract a substring from a string
substr('the',1,2)
substr('the',3,3)

## Do female baby names tend to end in 'a'? Let's look at 1917.

## first get male names and process as female names were
bn.male <- read.csv('http://www.ontario.ca/sites/default/files/opendata/ontariotopbabynames_male_1917-2010_english.csv',header=T,skip=1,stringsAsFactors=F)
bn.male$Frequency <- as.numeric(bn.male$Frequency)
## EX: Order the male baby names data first by Year then by Frequency. Can
## you do so in increasing Year order but decreasing Frequency?


## rownames(bn.male) <- NULL
bn.male.list <- split(bn.male,bn.male$Year)

male.1917 <- bn.male.list[['1917']]$Name
female.1917 <- bn.list[['1917']]$Name

## How to extract the final character? With the tools we have, we need
## to know the length of the names
male.lengths <- nchar(male.1917)
female.lengths <- nchar(female.1917)
## EX: Create a vector "male.last" consisting of the last letter of
## each of the 1917 baby names. Analogously for "female.last".
mean(male.last=='A')
mean(female.last=='A')
t.test(male.last=='A',female.last=='A')




## returning to the emails data set
alias.df <- read.csv('Aliases.csv',stringsAsFactor=F)
alias.df <- alias.df[order(alias.df$PersonId),]

get.name <- function(alias) {
    alias <- tolower(alias)
    alias <- gsub(',','',alias)
    ## get person id corresponding to this alias
    personid <- alias.df$PersonId[alias.df$Alias==alias]
    ## get rows of alias df corresponding to this person id
    aliases <- alias.df$Alias[alias.df$PersonId==personid]
    ## return first row of selected rows
    return(aliases[1]) ## error handling?
} ## assumes emails.dat is static, is this a problem?
get.name(emails.dat$MetadataTo[31])
get.name.vectorized <- Vectorize(get.name)
get.name.vectorized <- Vectorize(get.name,'alias')
get.name.vectorized(emails.dat$MetadataTo[1:50])
mean(is.na(get.name.vectorized(emails.dat$MetadataTo)))


emails.dat$MetadataTo <- get.name.vectorized(emails.dat$MetadataTo)

emails.dat$MetadataFrom <-
    get.name.vectorized(emails.dat$MetadataFrom)


## ----copied from above----
to.table <- table(emails.dat$MetadataTo)
from.table <- table(emails.dat$MetadataFrom)
to.df <- data.frame(name=names(to.table),to.count=as.numeric(to.table))
from.df <- data.frame(name=names(from.table),from.count=as.numeric(from.table))
to.from <- merge(to.df,from.df,by='name')
to.from <- to.from[order(to.from$to.count,decreasing=T),]

gg.df <- data.frame(person=c(names(to.table),names(from.table)),
                  count=c(as.numeric(to.table),as.numeric(from.table)),
                  to.from=factor(rep(c('to','from'),c(length(to.table),length(from.table)))))

gg.df <- gg.df[order(gg.df$count,decreasing=T),]
ggplot(gg.df[gg.df$person %in%
             c('hillary clinton','abedin huma','c:mills cheryl','sullivan jj@state.gov'),],aes(x=person,y=count,fill=to.from))+geom_bar(position='dodge',stat='identity')


## EX: fix names in plot to match the CNBC article
