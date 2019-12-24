setwd("C:/Users/Naval/Dropbox/Berkeley Documents/Fall 2015/Stat 135")
# Imports data from Source Table into the 'babies' variable 
babies <- read.table("babiesI.data", header=TRUE)

# creates a vector with birthweights of babies born to mothers who smoke
bwt.smokers <- babies$bwt[babies$smoke == 1] 

# creates a vector with birthweights of babies born to mothers who don't smoke
bwt.nonsmokers <- babies$bwt[babies$smoke == 0]

#Part A: This following block of code summarises the two distributions.
summary(bwt.smokers)
sd(bwt.smokers)
IQR(bwt.smokers)

summary(bwt.nonsmokers)
sd(bwt.nonsmokers)
IQR(bwt.nonsmokers)

#Part B: This following block of code creates graphs to compare both distributions.
hist(bwt.smokers, freq = FALSE, breaks = 20, xlim = range (bwt.smokers, bwt.nonsmokers), 
     ylim = c(0,0.03), xlab = "Weight (In Ounces)", main = "Birth Weights of Babies Born to Smokers")

hist(bwt.nonsmokers, freq = FALSE, breaks = 20, xlim = range (bwt.smokers, bwt.nonsmokers), 
     ylim = c(0,0.03), xlab = "Weight (In Ounces)", main = "Birth Weights of Babies Born to Non-Smokers")

boxplot(bwt.smokers, bwt.nonsmokers, names = c("Smoker Babies", "Non-smoker Babies"),
        ylab = "Weight (In Ounces)", main = "Birthweight of Babies")

qqplot(bwt.smokers, bwt.nonsmokers, xlim = range (bwt.smokers, bwt.nonsmokers),
       ylim = range (bwt.smokers, bwt.nonsmokers), 
       xlab = "Quantiles of Smoker Babies", ylab = "Quantiles of Non-Smoker Babies",
       main = "Quantiles of Smoker Babies vs. Non-Smoker Babies") 
abline(a=0, b=1, col = "red")

