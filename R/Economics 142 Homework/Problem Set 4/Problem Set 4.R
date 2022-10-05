ovb <- read.csv("C:/Users/Naval/Dropbox/Berkeley Documents/Fall 2016/Econ C142/Problem Set 3/ovb.csv", header = TRUE, sep = ",")
#Question 2
f <- subset(ovb, female == 1)
corr2_xy <- (cor(f$logwage, f$educ))^2 #Equals 0.22
r2_xy <- summary(lm(logwage ~ educ, subset = female == 1, data = ovb))$r.squared #Equals 0.22
r2_yx <- summary(lm(educ ~ logwage, subset = female == 1, data = ovb))$r.squared #Equals 0.22
#Indeed, corr2_xy = r2_xy = r2_yx

#To modify 1e) when x and y are reversed, note that the expression in d) will now have the RHS in terms of xi - xbar.
#Also, beta1_hat will have yi - ybar in the denominator. When you substitude back into the expression for corr^2, 
#The yi - ybar term in beta1_hat will cancel out with the yi - ybar term in the denominator of corr^2, giving you the 
#new R2 which will have xi - xbar in the numerator and denominator.

#Question 3a)
f_nonim <- subset(ovb, female == 1 & imm == 0)
meanf_nonim <- mean(f_nonim$logwage)
se_meanf_nonim <- sd(f_nonim$logwage)/sqrt(nrow(f_nonim))

f_im <- subset(ovb, female == 1 & imm == 1)
meanf_im <- mean(f_im$logwage)
se_meanf_im <- sd(f_im$logwage)/sqrt(nrow(f_im))

test_stat1 <- (meanf_im - meanf_nonim)/(sqrt(se_meanf_im^2 + se_meanf_nonim^2)) #Equals -10.266
#Since test_stat1 > 1.96, we reject the null hypothesis under a 2-sided test at 95% confidence and conclude the means are not equal.


#Question 3b)
im_coeff <- summary(lm(logwage ~ imm, subset = female == 1, data = ovb))$coefficients[2,1] #Equals -0.18
diff_means <- meanf_im - meanf_nonim #Equals -0.18

se_im_coeff <- summary(lm(logwage ~ imm, subset = female == 1, data = ovb))$coefficients[2,2] #Equals 0.0165
test_stat2 <- im_coeff/se_im_coeff #Equals -10.887, slightly off from test_stat
#This is because the errors are assumed to be homoscedastic, but are actually heteroscedastic

#Question 3c)
install.packages("sandwich")
library("sandwich")
ols <- lm(logwage ~ imm, subset = female == 1, data = ovb)
ols$robse <- vcovHC(ols, type="HC1")
#Diagonals correspond to the SE^2 of the Betas.
se_beta0 <- ols$robse[1,1]^0.5 #Equals 0.007
se_beta1 <- ols$robse[2,2]^0.5 #Equals 0.01753, which is also the SE of the difference of the means as expected.

#We see that the HC SE of Beta 1 is larger than the regular SE of Beta 1.
#Similar story for the HC and regular SEs of Beta 0.