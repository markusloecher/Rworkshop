#####

x = 2
y = 3

x+y

#assignment operator <- 
x <- 2
x <<- 2

#comparison operator
x == 2

# vectors:


x = c(1,2,3)
y = 10:50
#or 
y = seq(10,12,by=1)
#operations on x
x[2]

y[-1]
y[2:3]

#vectorized operation


2^2

x^2

x*y # elemnt wise

# gsgsgsg
# sklkkldkldkld
# dkkdlkkld

# There are 3 brackets

[]
()
{}

barplot(x); grid()


paste("Jim", 1:10)

x = matrix(1:9, ncol=3)
colnames(x) = c("var1","var2","var3")
x
# sadly referencing by string is slow for large data sets!!

#matrices can only take ONE data type !!

# data frames can be accessed via $

#lists can be accesses also via the [[]]

# factors are 

# I want to count from 1 to 10

for (i in 1:10) print(i)

for (i in 1:10) {
  #print(i)
  if (i %% 5 ==0 & i %% 2 ==0) {
    print(paste(i, " is divisible by 5 and 2!") )
  } else {
      print(paste(i, " is not divisible by 5 and 2!") )
    } 
}

i = 1
while(i %% 5 !=0  ) {
  print(paste(i, " is not divisible by 5!") )
  i=i+1
}


library("readxl")
x = read_excel("data/TitanicTrain.xlsx")

library(foreign)












print(1)
print(2)
print(3)


mysum = function(a,b){
  c = a+b
  print(c)
  return(c)
}


#population stdev
psd = function(x, naRemove, trim = 0){
  if (naRemove==TRUE) x = na.omit(x)
  #s = sqrt(mean((x-mean(x))^2))
  s = sqrt(mean((x-mean(x,na.rm =naRemove, trim = trim))^2,na.rm =naRemove))
  return(s)
}

mymean = function(x, naRemove){
  #if ()
  n=length(x)
  n2 = 0
  s=0
  for (i in 1:n){
    if (!is.na(x[i])) {
      s = s+x[i]
      n2=n2+1
    }
  }
  return(s/n2)
}

psd = function(x){
  m = mean(x)
  SqDiff = (x-m)^2
  v = mean(SqDiff)
  s = sqrt(v)
  return(s)
}
































