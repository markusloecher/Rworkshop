## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, warning = FALSE, message = FALSE)

source("SetupI.R")
baseR = FALSE

## ------------------------------------------------------------------------
x = 2
y = 3
x+y

## ------------------------------------------------------------------------
x = c(1,2,3)
y = 10:12
#or 
y = seq(10,12,by=1)
#operations on x
x[2]
x[-2]
2*x
x^2
#built-in functions
mean(x)
sum(x)
#vectorized operations
x+y
#bare bones graphics
plot(x,y); grid()
barplot(x); grid()

## ------------------------------------------------------------------------
x = matrix(1:9, ncol=3)
colnames(x) = c("var1","var2","var3")
x
dim(x)
x[2,3]
x[2,"var1"]
colMeans(x)

## ------------------------------------------------------------------------
x = data.frame(a = 1:3, l = LETTERS[1:3], r = runif(3))
x
x$l


## ------------------------------------------------------------------------
y = list(x = matrix(1:9, ncol=3), l = LETTERS[1:3], r = NA)
y


## ------------------------------------------------------------------------
x = "chevrolet"
class(x)

## ----echo=TRUE-----------------------------------------------------------
library(ISLR)
data(Auto)

class(Auto$name)

## ----echo=TRUE-----------------------------------------------------------
Auto$cylinders = as.factor(Auto$cylinders)

## ------------------------------------------------------------------------
x = Sys.Date()
#or
as.Date("2017-03-20")
y = Sys.time()
x
y
class(x)
class(y)

as.numeric(x)
as.numeric(y)

#or
unclass(x)
unclass(y)

## ------------------------------------------------------------------------
library(ISLR)
data(Smarket)

head(Smarket)

mean(Smarket$Lag1)

## ------------------------------------------------------------------------
dim(Smarket)
class(Smarket)
class(Smarket$Lag1)


## ------------------------------------------------------------------------
Smarket$day = as.Date("2001-01-01") + 1:1250

## ------------------------------------------------------------------------
#initialize
Smarket$day = NA

for (i in 1:1250) Smarket$day[i] = as.Date("2001-01-01") + i

#or with multiple statements
for (i in 1:1250) {
  Smarket$day[i] = as.Date("2001-01-01") + i
  if (Smarket$day[i] == "2001-07-04") cat("The return on July 4th was ", Smarket$Today[i], "\n")
}


## ---- message=FALSE------------------------------------------------------
library(tseries)
 # sp500 = get.hist.quote(instrument = "^gspc", "2001-01-02", "2005-12-30",
 #                 quote = c("Open", "Volume"))
 #  save(sp500, file="sp500.rda")
load("data/sp500.rda")
n=nrow(sp500)
#can we compute percent returns?
sp500$Today = round(100*diff(sp500[,"Open"])/sp500[-n,"Open"],3)
colnames(sp500)[1]= "Open"

## ------------------------------------------------------------------------
sp500$Lag1 = stats::lag(sp500$Today,1)
sp500$Lag2 = stats::lag(sp500$Today,2)
sp500$Lag3 = stats::lag(sp500$Today,3)
sp500$Lag4 = stats::lag(sp500$Today,4)
sp500$Lag5 = stats::lag(sp500$Today,5)

## ------------------------------------------------------------------------
sd

## ------------------------------------------------------------------------
mysum = function(a=4,b=3){
  c = a+b
  print(c)
}

mysum(10,20)

c = mysum(b=2,a=3)

## ------------------------------------------------------------------------
mysum = function(a=4,b=3){
  #stopifnot(is.numeric(a))
  if (!is.numeric(a)){
    print("a has to be numeric !!!!!! you idiot")
    return()
  }
  c = a+b
  return(c)
}

mysum("Karl",20)


## ------------------------------------------------------------------------

plot(mpg ~ weight, data = Auto,col = rgb(0,0,1,0.5), pch=20);grid()

##ggplot version
library(ggplot2)
p <- ggplot(Auto, aes(weight, mpg))
p + geom_point(color="firebrick", alpha=0.5)

## ---- fig.width=10-------------------------------------------------------
par(mfrow=c(1,2))
hist(Smarket$Lag1)
hist(Smarket$Volume)


## ----echo=TRUE-----------------------------------------------------------
library(ISLR)
data(Auto)

boxplot(mpg ~ cylinders, data=Auto, xlab="cylinders", ylab="mpg");grid()
#notched version - for a different data set
boxplot(mpg ~ cylinders, data=subset(Auto, cylinders %in% c(4,6,8)), xlab="cylinders", ylab="mpg", notch=TRUE);grid()
##ggplot version
library(ggplot2)
p <- ggplot(Auto, aes(factor(cylinders), mpg))
p + geom_boxplot(fill="darkseagreen4")


## ------------------------------------------------------------------------

p + geom_violin() + geom_jitter(alpha=0.5, width=0.3, aes(color=cylinders))

## ------------------------------------------------------------------------
plot(sp500[,1:2])

## ------------------------------------------------------------------------
library(dygraphs)
dy=dygraph(sp500[,"Open"])
dyRangeSelector(dy)

## ------------------------------------------------------------------------
N=40;M=1000;p=0.5;Head2Tail=0.7
  set.seed(123)
  #initialize parameters:
  coin = c(0,1)#values to sample from
  xm = vector();#sample mean or sum
  #loop
  for (i in 1:M){
    x = sample(coin, N, rep=TRUE, prob  = c(1-p,p))
    xm[i] = mean(x)
  }
  hist(xm)
  #get the 5% and 95% quantiles:
  q = quantile(xm,c(0.05,0.95))
  #add vertical lines:
  abline(v=q,col=2)
  pObs = sum(xm >= Head2Tail) + sum(xm <= 1-Head2Tail)
  
  pObs = sum(xm >= Head2Tail | xm <= 1-Head2Tail)
  #pObs = sum(xm >= Head2Tail & xm <= 1-Head2Tail)
  

## ------------------------------------------------------------------------

qnorm(0.975)
pnorm(-1.96)
hist(rnorm(500))


# Compute P(45 < X < 55) for X Binomial(100,0.5)
sum(dbinom(46:54, 100, 0.5))
# Compute P( X < 55) for X Binomial(100,0.5)
pbinom(54, 100, 0.5)


## ------------------------------------------------------------------------
library(nycflights13)
dim(flights)
head(flights)

## ------------------------------------------------------------------------
library(dplyr)
filter(flights, month == 1, day == 1)

## ---- eval = FALSE-------------------------------------------------------
## flights[flights$month == 1 & flights$day == 1, ]

## ------------------------------------------------------------------------
slice(flights, 1:10)

## ------------------------------------------------------------------------
arrange(flights, year, month, day)

## ------------------------------------------------------------------------
arrange(flights, desc(arr_delay))

## ------------------------------------------------------------------------
# Select columns by name
select(flights, year, month, day)
# Select all columns between year and day (inclusive)
select(flights, year:day)
# Select all columns except those from year to day (inclusive)
select(flights, -(year:day))

## ------------------------------------------------------------------------
select(flights, tail_num = tailnum)

## ------------------------------------------------------------------------
rename(flights, tail_num = tailnum)

## ------------------------------------------------------------------------
distinct(flights, tailnum)
distinct(flights, origin, dest)

## ------------------------------------------------------------------------
mutate(flights,
  gain = arr_delay - dep_delay,
  speed = distance / air_time * 60)

## ------------------------------------------------------------------------
mutate(flights,
  gain = arr_delay - dep_delay,
  gain_per_hour = gain / (air_time / 60)
)

## ------------------------------------------------------------------------
summarise(flights,
  delay = mean(dep_delay, na.rm = TRUE))

## ---- warning = FALSE, message = FALSE, fig.width = 6--------------------
by_tailnum <- group_by(flights, tailnum)
delay <- summarise(by_tailnum,
  count = n(),
  dist = mean(distance, na.rm = TRUE),
  delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dist < 2000)

# Interestingly, the average delay is only slightly related to the
# average distance flown by a plane.
library(ggplot2)
ggplot(delay, aes(dist, delay)) +
  geom_point(aes(size = count), alpha = 1/2) +
  geom_smooth() +
  scale_size_area()

## ------------------------------------------------------------------------
destinations <- group_by(flights, dest)
summarise(destinations,
  planes = n_distinct(tailnum),
  flights = n()
)

## ------------------------------------------------------------------------
olddata_wide <- read.table(header=TRUE, text='
 subject sex control cond1 cond2
       1   M     7.9  12.3  10.7
       2   F     6.3  10.6  11.1
       3   F     9.5  13.1  13.8
       4   M    11.5  13.4  12.9
')
# Make sure the subject column is a factor
olddata_wide$subject <- factor(olddata_wide$subject)

## ------------------------------------------------------------------------
library(tidyr)

# The arguments to gather():
# - data: Data object
# - key: Name of new key column (made from names of data columns)
# - value: Name of new value column
# - ...: Names of source columns that contain values
# - factor_key: Treat the new key column as a factor (instead of character vector)
data_long <- gather(olddata_wide, condition, measurement, control:cond2, factor_key=TRUE)
data_long

## ------------------------------------------------------------------------
gather(olddata_wide, condition, measurement, control, cond1, cond2)

## ------------------------------------------------------------------------
keycol <- "condition"
valuecol <- "measurement"
gathercols <- c("control", "cond1", "cond2")
gather_(olddata_wide, keycol, valuecol, gathercols)

## ------------------------------------------------------------------------
library(tidyr)

# The arguments to spread():
# - data: Data object
# - key: Name of column containing the new column names
# - value: Name of column containing values
data_wide <- spread(data_long, condition, measurement)
data_wide

## ------------------------------------------------------------------------
# Rename cond1 to first, and cond2 to second
names(data_wide)[names(data_wide)=="cond1"] <- "first"
names(data_wide)[names(data_wide)=="cond2"] <- "second"

# Reorder the columns
data_wide <- data_wide[, c(1,2,5,3,4)]
data_wide

## ---- echo = TRUE--------------------------------------------------------
train <- read.csv("data/TitanicTrain.csv")

## ---- echo = TRUE--------------------------------------------------------
round(prop.table(table(train$Sex, train$Survived),1),2)

## ---- echo = TRUE--------------------------------------------------------
train$Child <- 0
train$Child[train$Age < 18] <- 1

## ---- echo = TRUE--------------------------------------------------------
suppressPackageStartupMessages(require(dplyr))
summarise(group_by(train, Sex, Child), round(mean(Survived),2), length(Survived))


## ---- echo = TRUE--------------------------------------------------------
train$Fare2 <- '30+'
 train$Fare2[train$Fare < 30 & train$Fare >= 20] <- '20-30'
 train$Fare2[train$Fare < 20 & train$Fare >= 10] <- '10-20'
train$Fare2[train$Fare < 10] <- '<10'

## ---- echo = FALSE-------------------------------------------------------
SurvProp = summarise(group_by(train, Child, Fare2, Sex), round(mean(Survived),2), length(Survived))

SurvProp = SurvProp[order(SurvProp$`round(mean(Survived), 2)`),]

## ---- echo = FALSE-------------------------------------------------------
summarise(group_by(train, Child, Fare2, Sex, Embarked), round(mean(Survived),2), length(Survived))


## ------------------------------------------------------------------------

mean(flights$dep_delay)

mean(flights$dep_delay, na.rm=T)

median(flights$dep_delay, na.rm=T)

#robustness
mean(flights$dep_delay, na.rm=T, trim = 0.1)

## ------------------------------------------------------------------------
#var

sd(flights$dep_delay, na.rm=T)

IQR(flights$dep_delay, na.rm=T)

mad(flights$dep_delay, na.rm=T)


## ------------------------------------------------------------------------
#define our own transformation
require(scales) # trans_new() is in the scales library
sign_sqrt_trans = function() trans_new("sign_sqrt", function(x) sign(x)*sqrt(abs(x)), function(x) sign(x)*x^2)


## ------------------------------------------------------------------------
if (baseR){
  boxplot(arr_delay ~ carrier, data=flights)
  grid()
} else {
  p = ggplot(flights, aes( carrier,arr_delay))
  p + geom_boxplot() + coord_trans(y="sign_sqrt") #+ scale_y_sqrt()
}

## ---- fig.width=10-------------------------------------------------------
if (baseR){
  boxplot(arr_delay ~ hour, data=flights)
  grid()
} else {
  p = ggplot(flights, aes( factor(hour),arr_delay))
  p + geom_boxplot() + coord_trans(y="sign_sqrt") #+ scale_y_sqrt()
}


## ---- echo=TRUE, fig.width=10--------------------------------------------
print(load("data/BirthWeights.rda"))
class(x$gender)
#split the plotting region into 2 columns:
par(mfrow=c(1,2))
boxplot(dbirwt ~ gender, data=x)
hist(x$dbirwt, xlab="birth weight [g]")

## ------------------------------------------------------------------------
#either:
ii = which(x$dbirwt> 8000)
x = x[-ii,]

#or:
x = subset(x, dbirwt <= 8000)


## ---- echo=TRUE----------------------------------------------------------
library(ggplot2)
ggplot(x, aes(dbirwt, fill=gender)) + geom_density(alpha=.5) + 
  scale_fill_manual(values = c("orange", "purple")) # +   theme(legend.position = "none")

## ------------------------------------------------------------------------
boys = subset(x, gender == "male")$dbirwt
girls = subset(x, gender == "female")$dbirwt
  
t.test(x=boys, y=girls)

## ------------------------------------------------------------------------
set.seed(1234)

b=sample(boys,100);g=sample(girls,100)

t.test(b,g)

## ------------------------------------------------------------------------
var.test(b,g)

## ------------------------------------------------------------------------
(gs = table(train$Sex, train$Survived))
prop.test(gs)


## ------------------------------------------------------------------------
binom.test(gs[1,2:1], p=0.75)


## ---- fig.width=8--------------------------------------------------------
if (baseR){
  plot(arr_delay ~ dep_delay, data=flights, pch=20,cex=0.5,col=carrier)
  grid()
} else {
  p = ggplot(flights, aes( dep_delay,arr_delay, col=carrier ))
  p + geom_point( alpha=0.5, size=1) + coord_trans(x="sign_sqrt", y="sign_sqrt") # +  geom_smooth(method=lm) 
}


cor(flights$dep_delay,flights$arr_delay, use = "complete.obs",method = "pearson")
#slooow    
#cor(flights$dep_delay,flights$arr_delay, use = "complete.obs",method = "kendall")
  
#cor(flights$dep_delay,flights$arr_delay, use = "complete.obs",method = "spearman")

Shortdelays = filter(flights, abs(arr_delay)<100 & abs(dep_delay)<100)

cor(Shortdelays$dep_delay,Shortdelays$arr_delay, use = "complete.obs",method = "pearson")

#plot(arr_delay ~ dep_delay,data=Shortdelays)

## ------------------------------------------------------------------------
library(ISLR);data(Auto)
plot(mpg ~ weight, data = Auto,col = rgb(0,0,1,0.5), pch=20,xlim=c(250, 7000), ylim = c(0,45));grid()
LSfit = lm(mpg ~ weight, data = Auto)

#overlay regression line
abline(LSfit, col=2)

#summary
summary(LSfit)

#diagnostics
plot(LSfit, c(1,2,4))


## ---- fig.width=12, fig.height = 6---------------------------------------
par(mfrow=c(1,3), cex=1.4)

outlrs = cbind(weight=c(500,10000,3000),mpg=c(40,80,80))
Auto2 = Auto

fit=list()
for (i in 1:3){
  Auto2[1,c("weight","mpg")] = outlrs[i,]
  
  plot(mpg ~ weight, data = Auto2,col = rgb(1,0.894,0.769,0.5), pch=20);grid()
  #overlay regression line
  abline(LSfit, col=2, lwd=2.5)
  fit[[i]] = lm(mpg ~ weight, data = Auto2) 
  points(Auto2[1,c("weight","mpg")], col = i+2, pch = 18, cex = 2)
  #overlay regression line
  abline(fit[[i]], col=i+2,lwd=2, lty=2)
  #plot(fit[[i]],5)
}



## ------------------------------------------------------------------------
Global <- scan("data/global.dat")
 Global.ts <- ts(Global, st = c(1856, 1), end = c(2005, 12),
fr = 12)
 Global.annual <- aggregate(Global.ts, FUN = mean)
 plot(Global.ts);grid()
 

## ------------------------------------------------------------------------
library(dygraphs)
dygraph(Global.ts) %>%  dyRangeSelector() 

## ------------------------------------------------------------------------
Last35 <- window(Global.ts, start=c(1970, 1), end=c(2005, 12))
 Last35Yrs <- time(Last35)
 fitAD=lm(Last35 ~ Last35Yrs)
summary(fitAD)
plot(Last35)
  abline(fitAD,col=2)
  
  confint(fitAD)
  

## ------------------------------------------------------------------------
acf(resid(fitAD),  main = "Autocorrelation of residuals")

## ------------------------------------------------------------------------
library(nlme)
x.gls <- gls(Last35 ~ Last35Yrs, cor = corAR1(0.7))
confint(x.gls)
#par(mar=c(7,3,1,1));
#pacf(fitAD$residuals,lag.max = 10)


## ------------------------------------------------------------------------
 Global.ar <- ar(Global.annual, method = "mle")
mean(aggregate(Global.ts, FUN = mean))
 
 Global.ar$ar
 
 options(digits=3)
 rbind(Global.ar$ar -2 * sqrt(diag(Global.ar$asy.var)),
       Global.ar$ar,
       Global.ar$ar +2 * sqrt(diag(Global.ar$asy.var)) )
 
 
acf(Global.ar$res[-(1:Global.ar$order)], lag = 50, main = "Autocorrelation of residuals")

## ------------------------------------------------------------------------
fit = glm(Survived ~ Age, family = binomial, data = train)
pander(summary(fit)$coefficients)

## ------------------------------------------------------------------------
fit = glm(Survived ~ Pclass, family = binomial, data = train)
pander(summary(fit)$coefficients)

## ------------------------------------------------------------------------
fit = glm(Survived ~ factor(Pclass), family = binomial, data = train)
pander(summary(fit)$coefficients)

## ------------------------------------------------------------------------
fit = glm(Survived ~ factor(Pclass) -1, family = binomial, data = train)
pander(summary(fit)$coefficients)

## ------------------------------------------------------------------------
fit1=glm(Survived ~ Pclass + Sex + Age + Fare, data = train, family=binomial)
pander(summary(fit1)$coefficients)


## ------------------------------------------------------------------------
fit2=glm(Survived ~ Pclass + Sex + Age, data = train, family=binomial)
pander(summary(fit2)$coefficients)

## ------------------------------------------------------------------------
 fit1=lm(Survived ~ Pclass + Sex + Age + Fare, data = train)
 fit2=lm(Survived ~ Pclass + Sex + Age , data = train)

anova(fit1,fit2)

## ---- fig.width=10-------------------------------------------------------
if (baseR){
  boxplot(arr_delay ~ origin, data=flights)
  grid()
} else {
  p = ggplot(flights, aes( factor(origin),arr_delay))
  p + geom_boxplot() + coord_trans(y="sign_sqrt") #+ scale_y_sqrt()
}


## ------------------------------------------------------------------------
summary(lm(arr_delay ~ factor(origin) -1, data = flights))

myAOV = aov(arr_delay ~ factor(origin) -1, data = flights)

summary(myAOV)



## ------------------------------------------------------------------------
pairwise.t.test(flights$arr_delay, flights$origin, adjust="bonferroni")

## ------------------------------------------------------------------------
TukeyHSD(myAOV)

## ------------------------------------------------------------------------
library(ISLR)
names(Smarket)
#dim(Smarket)
#summary(Smarket)
#pairs(Smarket)
#cor(Smarket)
#cor(Smarket[,-9])
attach(Smarket)
plot(Volume, type="l", col = "brown");grid()

## ------------------------------------------------------------------------

train=(Year<2005)
Smarket.2005=Smarket[!train,]
dim(Smarket.2005)
Direction.2005=Direction[!train]

## ------------------------------------------------------------------------

glm.fit=glm(Direction~Lag1+Lag2+Lag3+Lag4+Lag5+Volume,data=Smarket,family=binomial,subset=train)
glm.probs=predict(glm.fit,Smarket.2005,type="response")

## ------------------------------------------------------------------------

glm.pred=rep("Down",252)
glm.pred[glm.probs>.5]="Up"
table(glm.pred,Direction.2005)
mean(glm.pred==Direction.2005)
mean(glm.pred!=Direction.2005)

## ------------------------------------------------------------------------

glm.fit=glm(Direction~Lag1+Lag2,data=Smarket,family=binomial,subset=train)
glm.probs=predict(glm.fit,Smarket.2005,type="response")
glm.pred=rep("Down",252)
glm.pred[glm.probs>.5]="Up"
table(glm.pred,Direction.2005)
mean(glm.pred==Direction.2005)
106/(106+76)
predict(glm.fit,newdata=data.frame(Lag1=c(1.2,1.5),Lag2=c(1.1,-0.8)),type="response")

