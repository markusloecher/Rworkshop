## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)

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

## ---- echo=TRUE, fig.width=12, fig.height=10-----------------------------
train <- read.csv("data/TitanicTrain.csv")
library(partykit, quietly = TRUE)
train$Pclass = factor(train$Pclass)
train$Survived = factor(train$Survived)

naRows = is.na(train$Age)

fit = ctree(Survived ~ Age + Sex + Pclass, data= train[!naRows,])
plot(fit)

## ------------------------------------------------------------------------
FemalePclass12 = subset(train[!naRows,], Sex =="female" & Pclass %in% 1:2)
(ST=table(FemalePclass12$Survived, FemalePclass12$Pclass))
x=ST["1",1:2]
n=colSums(ST[,1:2])

prop.test(x,n)

## ------------------------------------------------------------------------
MalePclass23 = subset(train[!naRows,], Sex =="male" & Pclass %in% 2:3 & Age > 9)
(ST=table(MalePclass23$Survived, MalePclass23$Pclass))
x=ST["1",2:3]
n=colSums(ST[,2:3])

prop.test(x,n)

## ------------------------------------------------------------------------
MalePclass1 = subset(train[!naRows,], Sex =="male" & Pclass %in% 1 )
(ST=table(MalePclass1$Survived, MalePclass1$Age > 52))
x=ST["1",]
n=colSums(ST)

prop.test(x,n)

## ------------------------------------------------------------------------
k=2
p=0.01019
1 - (1 - p)^k

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

