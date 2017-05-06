## Agenda
## 1. Basic text processing
## 2. Regular expressions


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

paste('a','b','c')

## EX: Split the string "s" on the character 's'
paste(s,collapse="")
s <- paste(s[1:4],collapse="s") # paste to convert list to string

## EX: Print the string "s" but with hyphens between all
## characters of the words.


bn <- read.csv('http://www.ontario.ca/sites/default/files/opendata/ontariotopbabynames_female_1917-2010_english.csv',header=T,skip=1,stringsAsFactors=F)
str(bn)

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


## [[SKIPPED 2017]]
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


## 2. Regular expressions. We saw a situation
## where we wanted to pick out a pattern in a string, checking for a
## vowel at the end of a string. Regular expressions allow you
## to match a pattern to a string. They are used in some search engines and
## word processors and almost any programming language supports
## them. We will cover a few of the basic pattern tools.

## Regular expressions can be used in the tools we saw yesterday
## (grep, sub, substr) but we will introduce them using 'regexpr',
## which just tests for the pattern anywhere in a string.

## '.' to match any single character
regexpr('t.e','the')
regexpr('t.e','tee')
regexpr('t.','tho')
regexpr('t.e','tho')

## use a pipe '|' or brackets for disjunction
regexpr('(a|e)ileen','aileen') # parens for grouping
regexpr('(a|e)ileen','eileen')
regexpr('(a|e)ileen','ileen')
regexpr('a|eileen','aileen') # note match length
regexpr('[aeiou]ileen','iileen')
regexpr('[aeiou]ileen','ileen')
## use brackets with '^' to negate disjunction (exclusion list)
regexpr('[^t]he','the')
regexpr('[^t]he','dhe')
regexpr('[^td]he','dhe')


## '?' to test for the presence of an character (or expression generally)
regexpr('willi?ard','willard')
regexpr('willi?ard','williard')
regexpr('will[aeiou]?ard','willoard')

## '*' to test for 0 or more instances of the previous expression (vs
## '?', which tests for 0 or 1)
regexpr('th*e','the')
regexpr('th*e','te')
regexpr('th*e','thhhhhhe')

## similarly, '+' to test for 1 or more
regexpr('th+e','the')
regexpr('th+e','te')
regexpr('th+e','thhhhhhe')

## finally, '^' and '$' for the beginning or end of a string
## (note this "anchor" use of '$' differs from its use in brackets
regexpr('he','the')
regexpr('^he','the')
regexpr('he$','the')
regexpr('^t','the')



bn.male <- read.csv('http://www.ontario.ca/sites/default/files/opendata/ontariotopbabynames_male_1917-2010_english.csv',header=T,skip=1)
bn.male$Name <- as.character(bn.male$Name)
bn.male.list <- split(bn.male,bn.male$Year)
male.1917 <- bn.male.list[[1]]$Name

bn.female <- read.csv('http://www.ontario.ca/sites/default/files/opendata/ontariotopbabynames_female_1917-2010_english.csv',header=T,skip=1)
bn.female$Name <- as.character(bn.female$Name)
bn.female.list <- split(bn.female,bn.female$Year)
female.1917 <- bn.list[[1]]$Name

head(male.1917)
head(female.1917)

## re-check 'A' at the end of names
## EX: What proportion of male names in 197 end in the vowel 'A', and what proportion of female names?


## EX: What proportion of male names in 197 end in any vowel, and what proportion of female names?



