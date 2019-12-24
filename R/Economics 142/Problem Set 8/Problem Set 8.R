#Question 1a)
ps8 <- read.csv("C:/Users/Naval/Dropbox/Berkeley Documents/Fall 2016/Econ C142/Problem Set 8/ps8.csv", header = TRUE, sep = ",")
ps8$two_fos <- floor((ps8$FOD1P)/100)
ps8$logwage <- log(ps8$WAGP)
set.seed(7)
train = sample(1:nrow(ps8), nrow(ps8)/2)
test = (-train)
ps8train = ps8[train,]; ps8test = ps8[test,]

#Question 1b)
v <- sort(unique(ps8train$two_fos))
mean_wage_v <- rep(0, length(v))
count_v <- rep(0, length(v))
for (i in 1:length(v)){
  mean_wage_v[i] = mean(subset(ps8train,two_fos == v[i])$logwage)
  count_v[i] = length(subset(ps8train,two_fos == v[i])$logwage)
}
grandmean_wage = mean(ps8train$logwage)

#Question 1c)
N = length(ps8test$logwage)
theta_v = rep(0, length(v))
mean_wage_hat_v = rep(0, length(v))
msfe_1 = rep(0, 100)
#Using 100 values for potential k: 10, 20, ..., 1000
for (k in 1:100) {
  for (i in 1:length(v)){
    theta_v[i] = (N - count_v[i])/(N - count_v[i] + k*10*count_v[i])
    mean_wage_hat_v[i] = theta_v[i]*grandmean_wage + (1 - theta_v[i])*mean_wage_v[i]
  }
  for (i in 1:N) {
    msfe_1[k] = msfe_1[k] + (ps8test$logwage[i] - mean_wage_hat_v[which(v == ps8test$two_fos[i])])^2
  }
  msfe_1[k] = msfe_1[k]/N
}
plot(x = seq(1,1000, 10), y = msfe_1, xlab = "k", ylab = "MSFE", main = "MSFE varying with k, under Shrinkage Regression")
#The MSFE continues to decrease with higher k, implying the optimal k is k = infinity (causing theta_v = mean_wage_v)

#Question 2
library(glmnet)
library(dummies)
x_train = dummy(ps8train$two_fos); x_test = dummy(ps8test$two_fos)
y_train = ps8train$logwage; y_test = ps8test$logwage
#Using 100 values for potential lambda: 0.1, 0.2, ..., 10
grid = seq(1,100,1)/10
ridge.mod = glmnet(x_train, y_train, alpha = 0, lambda = grid, standardize=FALSE)

msfe_2 = rep(0,100)
for (lmbda in 1:length(grid)){
  ridge_pred=predict(ridge.mod, s=lmbda/10, newx =x_test)
  msfe_2[lmbda] = mean((ridge_pred-y_test)^2)
}
plot(x = grid, y = msfe_2, xlab = "lambda", ylab = "MSFE", main = "MSFE varying with k, under Ridge Regression")
#The MSFE continues to increase with higher lambda, implying the optimal lambda is lambda = 0 (causing beta_v = mean_wage_v)
#The MSFE of the Ridge regression almost looks like the reciprocal of the MSFE for the Shrinkage regression.

#Question 3
#Using 100 values for potential lambda from 10^-3 to 10^-1
grid_lasso = 10^seq(-3, -1, length = 100)
lasso.mod = glmnet(x_train, y_train, alpha = 1, lambda = grid_lasso, standardize=FALSE)

msfe_3 = rep(0,100)
for (lmbda in 1:length(grid)){
  lasso_pred = predict(lasso.mod, s= grid_lasso[lmbda], newx =x_test)
  msfe_3[lmbda] = mean((lasso_pred-y_test)^2)
}
plot(x = grid_lasso, y = msfe_3, xlab = "lambda", ylab = "MSFE", main = "MSFE varying with k, under Lasso Regression")
#The MSFE increase with lambda, and plateaus at roughly lambda = 0.04 and MSFE = 0.92. 
#Again the optimal lambda is lambda = 0 (causing beta_v = mean_wage_v).
#The MSFE of the Lasso regression almost looks linear, unlike the curves shown in Ridge and Shrinkage.
