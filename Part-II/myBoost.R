myBoost = function(train,
                   y="logSale",
                   B= 10,
                   d=2,
                   lambda = 1
){
  fit_b=list()
  
  res_b= train[,y]
  yCol = which(colnames(train)==y)
  yHat_b = 0
  for (i in 1:B){
    train$residuals = res_b
    
    fit_b[[i]] = rpart(residuals ~ ., data = train[,-yCol],
                  control = rpart.control(maxdepth=d), method = "anova")
    #summary(fit1)$r.squared
    
    yHat_b = yHat_b + lambda*predict(fit_b[[i]])
    cat(i, "th, iteration, R = ", round(cor(exp(yHat_b), exp(train[,y])), 4), "\n")
    res_b = residuals(fit_b[[i]])
  }
  invisible(fit_b)
}

########################

myPredict = function(fit1,x, lambda=1,y="logSale"){
  B=length(fit1)
  yHat1 = 0
  
  for (i in 1:B){
    yHat1 = yHat1 + lambda*predict(fit1[[i]], new=x)
    cat(i, "th, iteration, R = ", round(cor(exp(yHat1), exp(x[,y])), 4), "\n")
  }
  invisible(yHat1)
}

if (0){
  library(dplyr)
    
  train = select(train, -contains("SalePrice") )
  train = select(train, -contains("Residuals") )
  fitP = rpart(logSale ~ ., data = train, maxdepth=2)
  plot(as.party(fitP))
  yHat = predict(fitP)
  plot( exp(yHat), exp(train$logSale), col=rgb(0,0,1,0.5),pch=20,cex=0.5);grid()
  round(cor(exp(yHat), exp(train$logSale)), 4)
}

