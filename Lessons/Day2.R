## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message=FALSE)
baseR = FALSE
library(pander)

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
plot(LSfit, c(1,2,5))


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
 
Last35 <- window(Global.ts, start=c(1970, 1), end=c(2005, 12))
 Last35Yrs <- time(Last35)
 fitAD=lm(Last35 ~ Last35Yrs)
summary(fitAD)
  abline(fitAD,col=2)



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

