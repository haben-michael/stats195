## Problem 1

## (a)

full.data <- read.csv("http://vincentarelbundock.github.io/Rdatasets/csv/Ecdat/Hedonic.csv")
head(full.data) # Looks OK. There is an extra column of row names "X"
                # that was added, which we can delete, but not a big issue.
full.data$X <- NULL


## (b)

dat <- subset(full.data,select=c("mv","age"))


## (c)

cuts <- cut(1:nrow(dat),2,labels=F)

lm0 <- lm(mv ~ age, data=dat, subset=(cuts==1))
summary(lm0)
plot(mv ~ age, data=dat, subset=(cuts==1), main =
     "Median home value versus home age, Boston area",
     xlab="home age", ylab="median home value",sub =
     "with linear regression line")
abline(lm0,col="red")


## (d)

sum(lm0$residuals^2)/length(lm0$residuals)

## (e)

new.data <- subset(dat,cuts==2,select="age")

predictions <- predict(lm0, newdata=new.data)


## (f)

new.responses <- subset(dat,cuts==2,select="mv")

sum((new.responses-predictions)^2)/length(predictions)


## Problem 2


sms <- scan('/gdrive/stanford/stats195/authsms.txt',what='',sep='\n')
auth.lines <- grep('Stanford Authentication Code',sms)
sms <- sms[auth.lines]
codes <- substr(sms,start=31,stop=37)
table(strsplit(paste0(codes,collapse=''),split=''))

##EC
chisq.test(table(strsplit(paste0(codes,collapse=''),split='')))

