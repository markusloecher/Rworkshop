## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, fig.width = 6, fig.height = 4)
options(digits=3)

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
load("sp500.rda")
n=nrow(sp500)
#can we compute percent returns?
sp500$Today = round(100*diff(sp500[,"Open"])/sp500[-n,"Open"],3)
colnames(sp500)[1]= "Open"

## ------------------------------------------------------------------------
sp500$Lag1 = lag(sp500$Today,-1)
sp500$Lag2 = lag(sp500$Today,-2)
sp500$Lag3 = lag(sp500$Today,-3)
sp500$Lag4 = lag(sp500$Today,-4)
sp500$Lag5 = lag(sp500$Today,-5)

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


