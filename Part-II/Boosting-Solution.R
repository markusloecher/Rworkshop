## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE, message=FALSE, warning=FALSE)
library(pacman)
p_load(rpart, gbm)

## ---- echo = TRUE--------------------------------------------------------

#library(readr)
train <- read.csv("//user/home/loecherm/DropboxHWR/PreviousSemesters/SS2017/AnalyticsLab/data/kaggle/HousePrices/train.csv.gz")
test <- read.csv("//user/home/loecherm/DropboxHWR/PreviousSemesters/SS2017/AnalyticsLab/data/kaggle/HousePrices/test.csv.gz")

## ------------------------------------------------------------------------
cat_var <- names(train)[which(sapply(train, is.factor))]
cat_car <- unique(c(cat_var, 'BedroomAbvGr', 'HalfBath', ' KitchenAbvGr','BsmtFullBath', 'BsmtHalfBath', 'MSSubClass'))
numeric_var <- names(train)[which(sapply(train, is.numeric))]

## ------------------------------------------------------------------------
test$SalePrice = NA
train$logSale = log(train$SalePrice)
test$logSale = log(test$SalePrice)

## ----missing data--------------------------------------------------------
  
#setdiff(colnames(train), colnames(test))

train = train[,intersect(colnames(train), colnames(test))]

jj = is.na(train$SalePrice)
train$SalePrice[jj] = mean(train$SalePrice, na.rm=TRUE)
#remove NAs
mv = colSums(sapply(train, is.na))
train = train[,mv==0]

test = test[,intersect(colnames(train), colnames(test))]

allData = rbind.data.frame(train,test)
nTRain=nrow(train)
nTest=nrow(test)

cat_car = intersect(cat_car, colnames(allData))

for (catCol in cat_car){
   levels(train[,catCol]) = levels(allData[,catCol])
   levels(test[,catCol]) = levels(allData[,catCol])
}


## ---- echo=TRUE----------------------------------------------------------
fit0 = lm(logSale ~ LotArea + BedroomAbvGr + factor(YrSold), data = train)
cat("R2 = ", round(summary(fit0)$r.squared, 4))

yHat0 = fit0$fitted.values
cat("R = ", round(cor(yHat0, train$logSale), 4), "\n")

res0 = residuals(fit0)

## ---- echo=TRUE----------------------------------------------------------
res1= res0 #train$logSale
yHat1 = yHat0 #0

for (i in 1:5){
  train$residuals = res1
  
  fit1 = lm(residuals ~ LotArea + BedroomAbvGr + factor(YrSold), data = train)
  #summary(fit1)$r.squared
  
  yHat1 = yHat1 + fit1$fitted.values
  cat(i, "th, iteration, R = ", round(cor(exp(yHat1), exp(train$logSale)), 4), "\n")
  res1 = residuals(fit1)
}

## ----sol1 , echo=FALSE---------------------------------------------------

myBoost = function(train,
                   y="logSale",
                   B= 10,
                   d=2
){
  res1= train[,y] 
  yHat1 = 0
  for (i in 1:B){
    train$residuals = res1
    
    fit1 = rpart(residuals ~ ., data = train,
                 control = rpart.control(maxdepth=d), method = "anova")
    #summary(fit1)$r.squared
    
    yHat1 = yHat1 + predict(fit1)
    cat(i, "th, iteration, R = ", round(cor(exp(yHat1), exp(train[,y])), 4), "\n")
    res1 = residuals(fit1)
  }
}

myBoost(train,d=2)

## ----sol2 , echo=FALSE---------------------------------------------------

myBoost2 = function(train,
                   y="logSale",
                   B= 10,
                   d=2
){
  res1= train[,y] 
  yHat1 = 0
  fit1 = list()
  
  for (i in 1:B){
    train$residuals = res1
    
    fit1[[i]] = rpart(residuals ~ ., data = train,
                 control = rpart.control(maxdepth=d), method = "anova")
    #summary(fit1)$r.squared
    
    yHat1 = yHat1 + predict(fit1[[i]])
    cat(i, "th, iteration, R = ", round(cor(exp(yHat1), exp(train[,y])), 4), "\n")
    res1 = residuals(fit1[[i]])
  }
  invisible(fit1)
}

myPredict2 = function(fit1,x, y="logSale"){
  B=length(fit1)
  yHat1 = 0
  
  for (i in 1:B){
    yHat1 = yHat1 + predict(fit1[[i]], new=x)
    cat(i, "th, iteration, R = ", round(cor(exp(yHat1), exp(x[,y])), 4), "\n")
  }
}



## ------------------------------------------------------------------------
set.seed(123)
iTrain =sample(nrow(train), round(3*nrow(train)/4))


boostedTrees = myBoost2(train[iTrain,],d=2)

## ------------------------------------------------------------------------
#first double check the training error:
myPredict2(boostedTrees,train[iTrain,])

## ------------------------------------------------------------------------
#now  check the test error:
myPredict2(boostedTrees,train[-iTrain,])

## ------------------------------------------------------------------------
set.seed(123)
N <- 1000
X1 <- runif(N)
X2 <- 2*runif(N)
X3 <- ordered(sample(letters[1:4],N,replace=TRUE),levels=letters[4:1])
X4 <- factor(sample(letters[1:6],N,replace=TRUE))
X5 <- factor(sample(letters[1:3],N,replace=TRUE))
X6 <- 3*runif(N) 
mu <- c(-1,0,1,2)[as.numeric(X3)]

SNR <- 10 # signal-to-noise ratio
Y <- X1**1.5 + 2 * (X2**.5) + mu
sigma <- sqrt(var(Y)/SNR)
Y <- Y + rnorm(N,0,sigma)

# introduce some missing values
X1[sample(1:N,size=500)] <- NA
X4[sample(1:N,size=300)] <- NA

data <- data.frame(Y=Y,X1=X1,X2=X2,X3=X3,X4=X4,X5=X5,X6=X6)

## ------------------------------------------------------------------------
# fit initial model
gbm1 <-
gbm(Y~X1+X2+X3+X4+X5+X6,         # formula
    data=data,                   # dataset
    var.monotone=c(0,0,0,0,0,0), # -1: monotone decrease,
                                 # +1: monotone increase,
                                 #  0: no monotone restrictions
    distribution="gaussian",     # see the help for other choices
    n.trees=400,                # number of trees
    shrinkage=0.05,              # shrinkage or learning rate,
                                 # 0.001 to 0.1 usually work
    interaction.depth=3,         # 1: additive model, 2: two-way interactions, etc.
    bag.fraction = 0.5,          # subsampling fraction, 0.5 is probably best
    train.fraction = 0.5,        # fraction of data for training,
                                 # first train.fraction*N used for training
    n.minobsinnode = 10,         # minimum total weight needed in each node
    cv.folds = 3,                # do 3-fold cross-validation
    keep.data=TRUE,              # keep a copy of the dataset with the object
    verbose=FALSE)#,               # don't print out progress
    #n.cores=1)                   # use only a single core (detecting #cores is
                                 # error-prone, so avoided here)

## ------------------------------------------------------------------------
# check performance using an out-of-bag estimator
# OOB underestimates the optimal number of iterations
best.iter <- gbm.perf(gbm1,method="OOB")
print(best.iter)

# check performance using a 50% heldout test set
best.iter <- gbm.perf(gbm1,method="test")
print(best.iter)

# check performance using cross-validation
best.iter <- gbm.perf(gbm1,method="cv")
print(best.iter)

# plot the performance # plot variable influence
summary(gbm1,n.trees=1)         # based on the first tree
summary(gbm1,n.trees=best.iter) # based on the estimated best number of trees

# compactly print the first and last trees for curiosity
print(pretty.gbm.tree(gbm1,1))
print(pretty.gbm.tree(gbm1,gbm1$n.trees))

## ------------------------------------------------------------------------
# make some new data
set.seed(321)
N <- 1000
X1 <- runif(N)
X2 <- 2*runif(N)
X3 <- ordered(sample(letters[1:4],N,replace=TRUE))
X4 <- factor(sample(letters[1:6],N,replace=TRUE))
X5 <- factor(sample(letters[1:3],N,replace=TRUE))
X6 <- 3*runif(N) 
mu <- c(-1,0,1,2)[as.numeric(X3)]

Y <- X1**1.5 + 2 * (X2**.5) + mu + rnorm(N,0,sigma)

data2 <- data.frame(Y=Y,X1=X1,X2=X2,X3=X3,X4=X4,X5=X5,X6=X6)

# predict on the new data using "best" number of trees
# f.predict generally will be on the canonical scale (logit,log,etc.)
f.predict <- predict(gbm1,data2,best.iter)

# least squares error
print(sum((data2$Y-f.predict)^2))



## ------------------------------------------------------------------------
# create marginal plots
# plot variable X1,X2,X3 after "best" iterations
par(mfrow=c(1,3))
plot(gbm1,1,best.iter)
plot(gbm1,2,best.iter)
plot(gbm1,3,best.iter)
par(mfrow=c(1,1))
# contour plot of variables 1 and 2 after "best" iterations
plot(gbm1,1:2,best.iter)
# lattice plot of variables 2 and 3
plot(gbm1,2:3,best.iter)
# lattice plot of variables 3 and 4
#plot(gbm1,3:4,best.iter)





## ------------------------------------------------------------------------
# do another 100 iterations
gbm2 <- gbm.more(gbm1,100,
                 verbose=FALSE) # stop printing detailed progress

## ------------------------------------------------------------------------
library(xgboost)


## ---- eval=FALSE---------------------------------------------------------
## 
## gbmFit = gbm(SalePrice ~ ., data = train)
## summary(gbmFit)
## preds = predict(gbmFit, test)
## subMiss = cbind.data.frame(Id= test$Id,SalePrice= preds)
## write.csv(subMiss, "C:/DatenLoecher/kaggle/HousePrices/data/GBMsubmission.csv", quote=F, row.names = FALSE)

