require(ggplot2)

## 1. ggplot

## ggplot is designed around "aesthetics", statistics, and geometric objects, but
## it's probably easier to learn first by example and then to glean
## the principles.

## basic example
u <- seq(-10,10,by=1)
plot(u,u^2)
plot(u,u^2,type='l')
plot(u,u^2,type='o')


gg.df <- data.frame(grid.point=u,value=u^2)
ggplot(gg.df,aes(x=grid.point,y=value)) + geom_point() ## also see qplot
ggplot(gg.df,aes(x=grid.point,y=value)) + geom_line()
ggplot(gg.df,aes(x=grid.point,y=value)) + geom_point()+geom_line() ## layers

## EX: Use ggplot to plot Sepal.Length vs Petal.Width from the iris data.

## other aesthetics
plot(u,u^2,col=terrain.colors(length(u)))
legend('bottomleft',col=terrain.colors(length(u)),pch=1,legend=u^2)
plot(u,u^2,cex=log(u^2)/5)
ggplot(gg.df,aes(x=grid.point,y=value,color=value)) + geom_point()
ggplot(gg.df,aes(x=grid.point,y=value,size=value)) + geom_point()

## EX: Use ggplot to plot Sepal.Length vs. Petal.Width (iris data).

## statistics
ggplot(iris,aes(x=Petal.Width,y=Sepal.Length))+geom_point()+stat_smooth() ## long format
ggplot(iris,aes(x=Petal.Width,y=Sepal.Length))+geom_point()+stat_smooth(method='lm')
ggplot(iris,aes(x=Petal.Width,y=Sepal.Length))+geom_point()+stat_smooth(method='lm')
ggplot(iris,aes(x=Petal.Width,y=Sepal.Length))+geom_point()+stat_smooth(method='lm',se=F)

boxplot(Petal.Width ~ Species, data=iris)
ggplot(iris,aes(x=Species,y=Petal.Width))+geom_boxplot()

hist(iris$Petal.Length[iris$Species=='setosa'])
ggplot(subset(iris,Species=='setosa'),
       aes(x=Petal.Length)) + geom_histogram()
ggplot(subset(iris,Species=='setosa'),
       aes(x=Petal.Length)) + geom_histogram(bins=10,color='black',fill='white')
with(subset(iris,Species=='versicolor'),
     hist(Petal.Length)
     )
with(subset(iris,Species=='virginica'), {
     hist(Petal.Length,add=T,col='red')
     })## set xlim manually

## EX: Use ggplot to plot a histogram of Petal.Length color filled by
## species type.

## position (identity); alpha level

## grouping data
ggplot(mtcars,aes(x=wt,y=mpg,color=cyl))+geom_point()
ggplot(mtcars,aes(x=wt,y=mpg,color=factor(cyl)))+geom_point()
ggplot(mtcars,aes(x=wt,y=mpg,group=cyl))+geom_point()
ggplot(mtcars,aes(x=wt,y=mpg,group=cyl))+geom_point()+stat_smooth(method='lm')

ggplot(iris,aes(x=Petal.Width,y=Sepal.Length))+geom_point()+facet_wrap( ~ Species) ## sometimes called simpson's paradox


## -------copied from 4/7 script
alias.df <- read.csv('Aliases.csv',stringsAsFactor=F)
alias.df <- alias.df[order(alias.df$PersonId),]
emails.dat <- read.csv('Emails.csv',stringsAsFactors=F)

get.name <- function(alias) {
    alias <- tolower(alias)
    alias <- gsub(',','',alias)
    personid <- alias.df$PersonId[alias.df$Alias==alias]
    aliases <- alias.df$Alias[alias.df$PersonId==personid]
    return(aliases[1])
} ## see dplyr::mapvalues for another way to go about this
get.name.vectorized <- Vectorize(get.name)
emails.dat$MetadataTo <- get.name.vectorized(emails.dat$MetadataTo)
emails.dat$MetadataFrom <-
    get.name.vectorized(emails.dat$MetadataFrom)

to.table <- table(emails.dat$MetadataTo)
from.table <- table(emails.dat$MetadataFrom)


gg.df <- data.frame(person=c(names(to.table),names(from.table)),
                  count=c(as.numeric(to.table),as.numeric(from.table)),
                  to.from=factor(rep(c('to','from'),c(length(to.table),length(from.table))))) ## long format

gg.df <- gg.df[order(gg.df$count,decreasing=T),]
ggplot(gg.df[gg.df$person %in%
             c('hillary clinton','abedin huma','c:mills cheryl','sullivan jj@state.gov'),],aes(x=person,y=count,fill=to.from))+geom_bar(position='dodge',stat='identity')



## 2. dplyr

str(iris)
## EX: Create a new data frame consisting of columns "Sepal.Width" and
## "Sepal.Length"

iris.sepal <- select(iris,starts_with('Sepal'))
iris.sepal <- select(iris,contains('Width'))

to.df <- data.frame(name=names(to.table),to.count=as.numeric(to.table),stringsAsFactors=F)
from.df <-
    data.frame(name=names(from.table),from.count=as.numeric(from.table),stringsAsFactors=F)

## EX: Join "to.df" and "from.df" to form a data frame "to.from"
## containing the sender and recipient counts of each contact.

to.from <- left_join(to.df,from.df,by='name')

## EX: Order "to.from" to put the most frequent recipients at the top.

to.from <- arrange(to.from,from.count)
to.from <- arrange(to.from,desc(from.count))


## EX: Add a column to "to.from" consisting of the sum of the sender
## and recipient count.

to.from <- mutate(to.from,total.count=to.count+from.count)

## pipes/redirection
rm(to.from)
to.from <- left_joint(to.df,from.df,by='name') %>%
    mutate(total.count=to.count+from.count) %>% arrange(desc(total.count))

## grouping operations

## EX: Using split, compute the average word count of the emails sent
## to each recipient in emails.dat.

word.counts <- aggregate(RawText ~ MetadataTo,data=emails.dat,function(x)mean(nchar(x)))

emails.grouped <- group_by(emails.dat,MetadataTo)
f <- function(x)mean(nchar(x))
summarize(emails.grouped,wordcount=f(RawText))

## EX: Redo the last few lines using redirection, ordering the result
## in descending order of mean email word count.
