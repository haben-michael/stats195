## Agenda
## 1. Regular expressions

## Regular expressions. We saw a situation in the last script
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

