library(rpart)

myFirstTree = rpart(Survived ~ . , data=train[,-4])

myFirstTree = rpart(Survived ~ Age + Pclass + Sex + Fare , data=train)
plot(myFirstTree)

library(partykit)
plot(as.party(myFirstTree))




library(nycflights13)

fit = gam::gam(arr_delay ~ s(dep_delay,4) + s(distance,4) + 
                 carrier, data=flights)

fit = gam::gam(arr_delay ~ s(dep_delay,distance,6) , data=flights)

library (gam)
data(Wage)
fit =glm(wage ~ year+ age+ education ,data=Wage, family=gaussian)
cv.glm(Wage,fit,K=10)$delta

gam.m3=gam::gam(wage ~ s(year ,4)+s(age ,5)+education ,data=Wage)
summary(gam.m3)
cv.glm(Wage,gam.m3,K=10)$delta

library(boot)
fit = glm(medv ~ ., data = Boston, family=gaussian)
tmp = cv.glm(Boston, fit,K=10)$delta

CV = function(K=10, x = Boston){
  n =nrow(x)
  x = x[sample(nrow(x)),]
  folds = rep(1:K,length=n)
  y=x
  y$TestPreds=y$TrainPreds=NA
  for (i in 1:K){
    test = which(folds==i)
    #y = split(Boston, folds!=i)
    #fitTrain = lm(medv ~ rm + crim + rad + dis, data = x[-test,])
    #browser()
    fitTrain = lm(medv ~ ., data = x[-test,])
    y$TestPreds[test] = predict(fitTrain,x[test,])
    y$TrainPreds[-test] = predict(fitTrain,x[-test,])
    #print(sum(is.na(x$TestPreds[test])))
  }
  #browser()
  rmseTest = sqrt(mean((y$TestPreds-x$medv)^2))
  rmseTrain = sqrt(mean((y$TrainPreds-x$medv)^2))
  return(c(rmseTrain,rmseTest))
}

CV(5, Boston)
CV(10,Boston)





