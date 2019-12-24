#Table 1 and Figure 1
#Discuss the characteristics; Explore the fraction splits through education and wage.
#Discuss both histagrams;
#Conclude with main differences between men and women

library(plyr)
library(scales)
library(xtable)
library(stargazer)
library(ggplot2)

project2016 <- read.csv("C:/Users/Naval/Dropbox/Berkeley Documents/Fall 2016/Econ C142/Final Project/project2016.csv", header = TRUE, sep = ",")
female_obs <- sum(project2016$female)
male_obs <- nrow(project2016) - female_obs
education <- rep(0, 4); ages <- rep(0, 4); ln_wage <- rep(0, 4); productivity <- rep(0,4)
education[1] <- mean(project2016$educ); ages[1] <- mean(project2016$age); ln_wage[1] <- mean(project2016$y); productivity[1] <- mean(project2016$va)
education[2] <- mean(subset(project2016,female == 1)$educ); ages[2] <- mean(subset(project2016,female == 1)$age); ln_wage[2] <- mean(subset(project2016,female == 1)$y); productivity[2] <- mean(subset(project2016,female == 1)$va)
education[3] <- mean(subset(project2016,female == 0)$educ); ages[3] <- mean(subset(project2016,female == 0)$age); ln_wage[3] <- mean(subset(project2016,female == 0)$y); productivity[3] <- mean(subset(project2016,female == 0)$va)
education[4] <- t.test(project2016$educ[project2016$female == 1], project2016$educ[project2016$female == 0])$statistic
ages[4] <- t.test(project2016$age[project2016$female == 1], project2016$age[project2016$female == 0])$statistic
ln_wage[4] <- t.test(project2016$y[project2016$female == 1], project2016$y[project2016$female == 0])$statistic
productivity[4] <- t.test(project2016$va[project2016$female == 1], project2016$va[project2016$female == 0])$statistic
table1 <- data.frame(education, ages, ln_wage, productivity)
rownames(table1) <- c("Mean of all workers", "Mean of females", "Mean of males", "T-statistic")
colnames(table1) <- c("Education", "Age", "Log Hourly Wage", "Log of Output per Worker")
xtable(t(table1))

female_prop_educ <- (count(subset(project2016, female == 1), 'educ'))[,2]/female_obs
male_prop_educ <- (count(subset(project2016, female == 0), 'educ'))[,2]/male_obs
wage_quartiles <- quantile(project2016$y)
project2016$y_quartiles <- findInterval(project2016$y, wage_quartiles, rightmost.closed = TRUE)
female_prop_wage <- (count(subset(project2016, female == 1), 'y_quartiles'))[,2]/female_obs
male_prop_wage <- (count(subset(project2016, female == 0), 'y_quartiles'))[,2]/male_obs
table1a <- data.frame(male_prop_educ, female_prop_educ)
rownames(table1a) <- c("4 Years", "6 Years", "9 Years", "12 Years", "16 Years")
colnames(table1a) <- c("Fraction of Males", "Fraction of Females")
xtable(table1a)

table1b <- data.frame(male_prop_wage, female_prop_wage)
rownames(table1b) <- c("Lowest 25%", "2nd Lowest 25%", "2nd Highest 25%", "Highest 25%")
colnames(table1b) <- c("Fraction of Males", "Fraction of Females")
xtable(table1b)

hist(project2016$y[project2016$female == 0], freq = FALSE, breaks = seq(0.4, 4.4, 0.1), col='skyblue', border=F, main = "Log Hourly Wage by Gender", xlab = "Log Hourly Wage", ylim = c(0, 1.4))
lines(density(project2016$y[project2016$female == 0]), col='blue', lwd = 1.5)
hist(project2016$y[project2016$female == 1], freq = FALSE, add = T, breaks = seq(0.4, 4.4, 0.1), col=scales::alpha('red',.5),border=F)
lines(density(project2016$y[project2016$female == 1]), col='darkred', lwd = 1.5)
legend("topright", c("Male", "Female"), fill=c("skyblue", "red"))

hist(project2016$va[project2016$female == 0], freq = FALSE, breaks = seq(1.6,4.6, 0.1), col='skyblue', border=F, main = "Log Output per Worker (Productivity) by Gender", xlab = "Log Output per Worker", ylim = c(0, 1.4))
lines(density(project2016$va[project2016$female == 0]), col='blue', lwd = 1.5)
hist(project2016$va[project2016$female == 1], freq = FALSE, add = T, breaks = seq(1.6,4.6, 0.1), col=scales::alpha('red',.5),border=F)
lines(density(project2016$va[project2016$female == 1]), col='darkred', lwd = 1.5)
legend("topright", c("Male", "Female"), fill=c("skyblue", "red"))

#Table 2 and Figure 2-4
#Discuss female coefficient in s1, s2
#Discuss educ, age coefficient in s3, s4

#Construct Oaxaca as:
#y_male - y_female = (Ed-Age_male - Ed-Age_female)Beta_female + Ed-Age_male(Beta_male - Beta_female) 
# = (Ed-Age_male - Ed-Age_female)Beta_male + Ed-Age_female(Beta_male - Beta_female)
#Comment on Oaxaca results vs beta coefficient results
#Briefly discuss Age graphs
#Note how knots K = 3 doesn't work. Compare MSE of Cubic vs Splines. K = 10 for Males, K = 5 for Females, lower MSE than Cubic at best K.

s1 <- lm(y ~ female, data = project2016)
s2 <- lm(y ~ educ + age + I(age^2) + I(age^3) + female, data = project2016)
s3 <- lm(y ~ educ + age + I(age^2) + I(age^3), data = project2016[project2016$female == 0,])
s4 <- lm(y ~ educ + age + I(age^2) + I(age^3), data = project2016[project2016$female == 1,])
stargazer(s1,s2,s3,s4, type="html", out = "table2.htm")

wAge_4 <- aggregate(project2016$y[project2016$educ == 4], list(Age = project2016$age[project2016$educ == 4], Gender = project2016$female[project2016$educ == 4]), mean) 
wAge_6 <- aggregate(project2016$y[project2016$educ == 6], list(Age = project2016$age[project2016$educ == 6], Gender = project2016$female[project2016$educ == 6]), mean) 
wAge_9 <- aggregate(project2016$y[project2016$educ == 9], list(Age = project2016$age[project2016$educ == 9], Gender = project2016$female[project2016$educ == 9]), mean) 
wAge_12 <- aggregate(project2016$y[project2016$educ == 12], list(Age = project2016$age[project2016$educ == 12], Gender = project2016$female[project2016$educ == 12]), mean) 
wAge_16 <- aggregate(project2016$y[project2016$educ == 16], list(Age = project2016$age[project2016$educ == 16], Gender = project2016$female[project2016$educ == 16]), mean) 

male_age_cubic <- function(educ) {helper <- function(x) {s3$coefficients[1] + s3$coefficients[2]*educ + s3$coefficients[3]*x + s3$coefficients[4]*(x^2) + s3$coefficients[5]*(x^3)}}
female_age_cubic <- function(educ) {helper <- function(x) {s4$coefficients[1] + s4$coefficients[2]*educ + s4$coefficients[3]*x + s4$coefficients[4]*(x^2) + s4$coefficients[5]*(x^3)}}

ggplot(data = wAge_4, aes(x=Age, y=x)) + geom_point(aes(colour=factor(Gender))) + scale_colour_manual(values = c("0" = "blue","1" = "red"), name = "Gender", labels = c("Male", "Female")) + ylab("Log Hourly Wage (Mean, by Age)") + ggtitle("Mean Wage by Age - 4 Years Educated") + stat_function(fun = male_age_cubic(4), colour = "blue") + stat_function(fun = female_age_cubic(4), colour = "red")
ggplot(data = wAge_6, aes(x=Age, y=x)) + geom_point(aes(colour=factor(Gender))) + scale_colour_manual(values = c("0" = "blue","1" = "red"), name = "Gender", labels = c("Male", "Female")) + ylab("Log Hourly Wage (Mean, by Age)") + ggtitle("Mean Wage by Age - 6 Years Educated") + stat_function(fun = male_age_cubic(6), colour = "blue") + stat_function(fun = female_age_cubic(6), colour = "red")
ggplot(data = wAge_9, aes(x=Age, y=x)) + geom_point(aes(colour=factor(Gender))) + scale_colour_manual(values = c("0" = "blue","1" = "red"), name = "Gender", labels = c("Male", "Female")) + ylab("Log Hourly Wage (Mean, by Age)") + ggtitle("Mean Wage by Age - 9 Years Educated") + stat_function(fun = male_age_cubic(9), colour = "blue") + stat_function(fun = female_age_cubic(9), colour = "red")
ggplot(data = wAge_12, aes(x=Age, y=x)) + geom_point(aes(colour=factor(Gender))) + scale_colour_manual(values = c("0" = "blue","1" = "red"), name = "Gender", labels = c("Male", "Female")) + ylab("Log Hourly Wage (Mean, by Age)") + ggtitle("Mean Wage by Age - 12 Years Educated") + stat_function(fun = male_age_cubic(12), colour = "blue") + stat_function(fun = female_age_cubic(12), colour = "red")
ggplot(data = wAge_16, aes(x=Age, y=x)) + geom_point(aes(colour=factor(Gender))) + scale_colour_manual(values = c("0" = "blue","1" = "red"), name = "Gender", labels = c("Male", "Female")) + ylab("Log Hourly Wage (Mean, by Age)") + ggtitle("Mean Wage by Age - 16 Years Educated") + stat_function(fun = male_age_cubic(16), colour = "blue") + stat_function(fun = female_age_cubic(16), colour = "red")

set.seed(7)
spm <- aggregate(project2016$y[project2016$educ == 12 & project2016$female == 0], list(Age = project2016$age[project2016$educ == 12 & project2016$female == 0]), mean)
spf <- aggregate(project2016$y[project2016$educ == 12 & project2016$female == 1], list(Age = project2016$age[project2016$educ == 12 & project2016$female == 1]), mean) 
train1 = sample(1:nrow(spm), nrow(spm)/2); train2 = sample(1:nrow(spf), nrow(spf)/2)
test1 = (-train1); test2 = (-train2)
spmtrain = spm[train1,]; spmtest = spm[test1,]
spftrain = spf[train2,]; spftest = spf[test2,]
msfe_m = rep(0, 7); msfe_f = rep(0, 7)
msfe_m_cubic <- mean((spmtest$x - male_age_cubic(12)(spmtest$Age))^2)
msfe_f_cubic <- mean((spftest$x - female_age_cubic(12)(spftest$Age))^2)

for (k in 1:7){
  m_spline <- smooth.spline(spmtrain$Age, spmtrain$x, nknots = k + 3)
  f_spline <- smooth.spline(spftrain$Age, spftrain$x, nknots = k + 3)
  
  msfe_m[k] <- mean((spmtest$x - predict(m_spline, spmtest$Age)$y)^2)
  msfe_f[k] <- mean((spftest$x - predict(f_spline, spftest$Age)$y)^2)
}
best_m <- function (x) {predict(smooth.spline(spmtrain$Age, spmtrain$x, nknots = 10), x)$y}
best_f <- function (x) {predict(smooth.spline(spftrain$Age, spftrain$x, nknots = 5), x)$y}

plot(4:10, msfe_f, xlab = "Number of Knots" , ylab = "MSE of Spline Prediction", main = "MSE for Splines with K Knots", col = "red")
points(4:10, msfe_m, col = "blue")
legend("topright", c("Male","Female"), lty=c(1,1), lwd=c(2.5,2.5),col=c("blue","red"))

ggplot(data = spm, aes(x=Age, y=x)) + geom_point() + ylab("Log Hourly Wage (Mean, by Age)") + ggtitle("Male Mean Wage by Age - 12 Years Educated") + stat_function(fun = male_age_cubic(12), colour = "blue") + stat_function(fun = best_m, colour = "purple") 
ggplot(data = spf, aes(x=Age, y=x)) + geom_point() + ylab("Log Hourly Wage (Mean, by Age)") + ggtitle("Female Mean Wage by Age - 12 Years Educated") + stat_function(fun = female_age_cubic(12), colour = "red") + stat_function(fun = best_f, colour = "purple")


#Table 3
#Oaxaca Decomposition to find effect of productivity on gender wage gap (Beta is pooled here).
#If higher va employers higher more productive works, the OLS beta will overstate the true causal effect of higher va employer.
#Oaxaca decomp using Male and Female Betas. va has smaller effect for women than men: Difference in 'returns' to va?
#Renormalize va and re-decomp, subtracting off lowest value of va.

m1 <- lm(y ~ educ + age + I(age^2) + I(age^3) + female, data = project2016)
m2 <- lm(y ~ educ + age + I(age^2) + I(age^3) + female + va, data = project2016)
m3 <- lm(y ~ educ + age + I(age^2) + I(age^3) + va, data = project2016[project2016$female == 0,])
m4 <- lm(y ~ educ + age + I(age^2) + I(age^3) + va, data = project2016[project2016$female == 1,])
stargazer(m1,m2,m3,m4, type="html", out = "table3.htm")


#Table 4
#Discuss how dva coefficient is smaller by using first differences to eliminate fixed effects.
#Effect of va is smaller for female than male. Possibly because of discrimination, taking breaks in career for family or working part-time.

c1 <- lm(dy ~ age + I(age^2) + dva, data = project2016)
c2 <- lm(dy ~ age + I(age^2) + dva + female, data = project2016)
c3 <- lm(dy ~ age + I(age^2) + dva, data = project2016[project2016$female == 0,])
c4 <- lm(dy ~ age + I(age^2) + dva, data = project2016[project2016$female == 1,])
stargazer(c1,c2,c3,c4, type="html", out = "table4.htm")


#Table 5 and Figure 5-6 
#What if employer productivity has a positive causal effect on wages? Moving up many quartiles should cause yp1 > yl2 etc.
#Discuss Figure 5, 6 and the above idea. How do moves benefit females vs males?

va_p_quartiles <- quantile(project2016$va_previous)
project2016$va_previous_quartiles <- findInterval(project2016$va_previous, va_p_quartiles, rightmost.closed = TRUE)
female_prop_va_p <- (count(subset(project2016, female == 1), 'va_previous_quartiles'))[,2]/female_obs
male_prop_va_p <- (count(subset(project2016, female == 0), 'va_previous_quartiles'))[,2]/male_obs
va_quartiles <- quantile(project2016$va)
project2016$va_quartiles <- findInterval(project2016$va, va_quartiles, rightmost.closed = TRUE)
female_prop_va <- (count(subset(project2016, female == 1), 'va_quartiles'))[,2]/female_obs
male_prop_va <- (count(subset(project2016, female == 0), 'va_quartiles'))[,2]/male_obs
female_prop_delta_va <- female_prop_va - female_prop_va_p
male_prop_delta_va <- male_prop_va - male_prop_va_p

table5 <- data.frame(male_prop_va_p, female_prop_va_p, male_prop_va, female_prop_va, male_prop_delta_va, female_prop_delta_va)
rownames(table5) <- c("Lowest 25%", "2nd Lowest 25%", "2nd Highest 25%", "Highest 25%")
colnames(table5) <- c("Male va_pre", "Female va_pre", "Male va", "Female va", "Male Change", "Female Change")
xtable(table5)

male_origin <- aggregate(project2016[project2016$female == 0,], list(Origin_Quartile = project2016$va_previous_quartiles[project2016$female == 0], Destination_Quartile = project2016$va_quartiles[project2016$female == 0]), mean) 
male_origin <- male_origin[, c("Origin_Quartile", "Destination_Quartile", "yl2", "yl1", "y", "yp1")]

female_origin <- aggregate(project2016[project2016$female == 1,], list(Origin_Quartile = project2016$va_previous_quartiles[project2016$female == 1], Destination_Quartile = project2016$va_quartiles[project2016$female == 1]), mean) 
female_origin <- female_origin[, c("Origin_Quartile", "Destination_Quartile", "yl2", "yl1", "y", "yp1")]

m_origin <- array(0, c(64, 4)); f_origin <- array(0, c(64, 4))
for (i in 1:4) { #Destination
  for (j in 1:4) { #Origin
    total_offset <- (i-1)*16 + (j-1)*4
    m_origin[total_offset + 1, 1] <- -2; m_origin[total_offset + 2, 1] <- -1; m_origin[total_offset + 3, 1] <- 0; m_origin[total_offset + 4, 1] <- 1;
    m_origin[total_offset + 1, 2] <- j; m_origin[total_offset + 2, 2] <- j; m_origin[total_offset + 3, 2] <- j; m_origin[total_offset + 4, 2] <- j; 
    m_origin[total_offset + 1, 3] <- i; m_origin[total_offset + 2, 3] <- i; m_origin[total_offset + 3, 3] <- i; m_origin[total_offset + 4, 3] <- i;
    m_origin[total_offset + 1, 4] <- male_origin$yl2[male_origin$Origin_Quartile == j & male_origin$Destination_Quartile == i]
    m_origin[total_offset + 2, 4] <- male_origin$yl1[male_origin$Origin_Quartile == j & male_origin$Destination_Quartile == i] 
    m_origin[total_offset + 3, 4] <- male_origin$y[male_origin$Origin_Quartile == j & male_origin$Destination_Quartile == i]
    m_origin[total_offset + 4, 4] <- male_origin$yp1[male_origin$Origin_Quartile == j & male_origin$Destination_Quartile == i]
    
    f_origin[total_offset + 1, 1] <- -2; f_origin[total_offset + 2, 1] <- -1; f_origin[total_offset + 3, 1] <- 0; f_origin[total_offset + 4, 1] <- 1;
    f_origin[total_offset + 1, 2] <- j; f_origin[total_offset + 2, 2] <- j; f_origin[total_offset + 3, 2] <- j; f_origin[total_offset + 4, 2] <- j; 
    f_origin[total_offset + 1, 3] <- i; f_origin[total_offset + 2, 3] <- i; f_origin[total_offset + 3, 3] <- i; f_origin[total_offset + 4, 3] <- i;
    f_origin[total_offset + 1, 4] <- female_origin$yl2[female_origin$Origin_Quartile == j & female_origin$Destination_Quartile == i]
    f_origin[total_offset + 2, 4] <- female_origin$yl1[female_origin$Origin_Quartile == j & female_origin$Destination_Quartile == i] 
    f_origin[total_offset + 3, 4] <- female_origin$y[female_origin$Origin_Quartile == j & female_origin$Destination_Quartile == i]
    f_origin[total_offset + 4, 4] <- female_origin$yp1[female_origin$Origin_Quartile == j & female_origin$Destination_Quartile == i]
  }
}
colnames(m_origin) <- c("Period", "Origin", "Destination", "Wage"); colnames(f_origin) <- c("Period", "Origin", "Destination", "Wage")
m_origin <- as.data.frame.matrix(m_origin); f_origin <- as.data.frame.matrix(f_origin); 

ggplot(data = m_origin[m_origin$Origin == 1,], aes(x= Period, y= Wage)) + geom_line(aes(colour = factor(Destination))) + ylab("Log Hourly Wage (Mean, by Period)") + ggtitle("Male Mean Wage by Period with Origin Quartile 1") + scale_colour_manual(values = c("1" = "blue","2" = "red", "3" = "springgreen3", "4" = "purple" ), name = "Destination Quartile", labels = c("1st Quartile", "2st Quartile", "3rd Quartile", "4th Quartile"))
ggplot(data = m_origin[m_origin$Origin == 2,], aes(x= Period, y= Wage)) + geom_line(aes(colour = factor(Destination))) + ylab("Log Hourly Wage (Mean, by Period)") + ggtitle("Male Mean Wage by Period with Origin Quartile 2") + scale_colour_manual(values = c("1" = "blue","2" = "red", "3" = "springgreen3", "4" = "purple" ), name = "Destination Quartile", labels = c("1st Quartile", "2st Quartile", "3rd Quartile", "4th Quartile"))
ggplot(data = m_origin[m_origin$Origin == 3,], aes(x= Period, y= Wage)) + geom_line(aes(colour = factor(Destination))) + ylab("Log Hourly Wage (Mean, by Period)") + ggtitle("Male Mean Wage by Period with Origin Quartile 3") + scale_colour_manual(values = c("1" = "blue","2" = "red", "3" = "springgreen3", "4" = "purple" ), name = "Destination Quartile", labels = c("1st Quartile", "2st Quartile", "3rd Quartile", "4th Quartile"))
ggplot(data = m_origin[m_origin$Origin == 4,], aes(x= Period, y= Wage)) + geom_line(aes(colour = factor(Destination))) + ylab("Log Hourly Wage (Mean, by Period)") + ggtitle("Male Mean Wage by Period with Origin Quartile 4") + scale_colour_manual(values = c("1" = "blue","2" = "red", "3" = "springgreen3", "4" = "purple" ), name = "Destination Quartile", labels = c("1st Quartile", "2st Quartile", "3rd Quartile", "4th Quartile"))

ggplot(data = f_origin[f_origin$Origin == 1,], aes(x= Period, y= Wage)) + geom_line(aes(colour = factor(Destination))) + ylab("Log Hourly Wage (Mean, by Period)") + ggtitle("Female Mean Wage by Period with Origin Quartile 1") + scale_colour_manual(values = c("1" = "blue","2" = "red", "3" = "springgreen3", "4" = "purple" ), name = "Destination Quartile", labels = c("1st Quartile", "2st Quartile", "3rd Quartile", "4th Quartile"))
ggplot(data = f_origin[f_origin$Origin == 2,], aes(x= Period, y= Wage)) + geom_line(aes(colour = factor(Destination))) + ylab("Log Hourly Wage (Mean, by Period)") + ggtitle("Female Mean Wage by Period with Origin Quartile 2") + scale_colour_manual(values = c("1" = "blue","2" = "red", "3" = "springgreen3", "4" = "purple" ), name = "Destination Quartile", labels = c("1st Quartile", "2st Quartile", "3rd Quartile", "4th Quartile"))
ggplot(data = f_origin[f_origin$Origin == 3,], aes(x= Period, y= Wage)) + geom_line(aes(colour = factor(Destination))) + ylab("Log Hourly Wage (Mean, by Period)") + ggtitle("Female Mean Wage by Period with Origin Quartile 3") + scale_colour_manual(values = c("1" = "blue","2" = "red", "3" = "springgreen3", "4" = "purple" ), name = "Destination Quartile", labels = c("1st Quartile", "2st Quartile", "3rd Quartile", "4th Quartile"))
ggplot(data = f_origin[f_origin$Origin == 4,], aes(x= Period, y= Wage)) + geom_line(aes(colour = factor(Destination))) + ylab("Log Hourly Wage (Mean, by Period)") + ggtitle("Female Mean Wage by Period with Origin Quartile 4") + scale_colour_manual(values = c("1" = "blue","2" = "red", "3" = "springgreen3", "4" = "purple" ), name = "Destination Quartile", labels = c("1st Quartile", "2st Quartile", "3rd Quartile", "4th Quartile"))


#Table 6
#Run Oaxaca on n3, n4.
#Conclude!
project2016$y_beta_Dva <- project2016$y - c3$coefficients[4]*project2016$dva
project2016$y_beta_Dva[project2016$female == 1] <- project2016$y[project2016$female == 1] - c4$coefficients[4]*project2016$dva[project2016$female == 1]

n3 <- lm(y_beta_Dva ~ educ + age + I(age^2) + I(age^3), data = project2016[project2016$female == 0,])
n4 <- lm(y_beta_Dva ~ educ + age + I(age^2) + I(age^3), data = project2016[project2016$female == 1,])
stargazer(n3, n4, type="html", out = "table6.htm")
