#Question 1
rd <- read.csv("C:/Users/Naval/Dropbox/Berkeley Documents/Fall 2016/Econ C142/Problem Set 7/rd.csv", header = TRUE, sep = ",")
means_rd <- aggregate(rd[,-2], list(psu = floor(rd$psu)), mean)
library(ggplot2)
ggplot(means_rd, aes(x = psu, y = hsgpa)) + geom_point() 
ggplot(means_rd, aes(x = psu, y = entercollege)) + geom_point() 
ggplot(means_rd, aes(x = psu, y = privatehs)) + geom_point()
ggplot(means_rd, aes(x = psu, y = hidad)) + geom_point() 
ggplot(means_rd, aes(x = psu, y = himom)) + geom_point()
#We do see a jump from 0.25 to ~0.31 in the value of entercollege at psu = 475
#The other variables do not vary much at psu = 475.


#Question 2a)
means_rd$x4 = ((means_rd$psu) - 475)*means_rd$over475
entercollege_10 <- lm(entercollege ~ psu + over475 + x4, subset = psu >= 475-10 & psu <= 474+10, data = means_rd)
hsgpa_10 <- lm(hsgpa ~ psu + over475 + x4, subset = psu >= 475-10 & psu <= 474+10, data = means_rd)
hidad_10 <- lm(hidad ~ psu + over475 + x4, subset = psu >= 475-10 & psu <= 474+10, data = means_rd)
himom_10 <- lm(himom ~ psu + over475 + x4, subset = psu >= 475-10 & psu <= 474+10, data = means_rd)
#Beta3 for hsgpa, hidad, himom are slightly negative (-0.001:-0.03), while Beta3 for entercollege is positive at 0.172

#Question 2b)
entercollege_20 <- lm(entercollege ~ psu + over475 + x4, subset = psu >= 475-20 & psu <= 474+20, data = means_rd)
hsgpa_20 <- lm(hsgpa ~ psu + over475 + x4, subset = psu >= 475-20 & psu <= 474+20, data = means_rd)
hidad_20 <- lm(hidad ~ psu + over475 + x4, subset = psu >= 475-20 & psu <= 474+20, data = means_rd)
himom_20 <- lm(himom ~ psu + over475 + x4, subset = psu >= 475-20 & psu <= 474+20, data = means_rd)
#Beta3 for hidad, himom are slightly negative (-0.01:-0.02), Beta3 for hsgpa is quite negative (-0.2)
#Meanwhile, Beta3 for entercollege is quite positive at 0.172

#Question 2c)
entercollege_bands <- array(0, c(50-5+1, 4))
for (i in 5:50) {
  temp <- lm(entercollege ~ psu + over475 + x4, subset = psu >= 475-i & psu <= 474+i, data = means_rd)
  entercollege_bands[i-4,] <- temp$coefficients
}
plot(x = 5:50, y = entercollege_bands[,3], xlab = "Bandwidth", ylab = "Beta 3", ylim = c(0.14,0.2), main = "Beta3 as Bandwidth varies")
lines(x = 5:50, y = entercollege_bands[,3])

#Question 2d)
summary(hidad_10); summary(hidad_20); summary(himom_10); summary(himom_20)
#Beta3 has a p-value of 0.368, 0.287, 0.038, 0.051 for hidad_10, hidad_20, himom_10, himom_20.
#For hidad_10 and hidad_20, the p-value is >0.05, so we cannot reject the null that beta3 = 0, and hence cannot conclude a significant jump at psu = 475 (5% sig level).
#For himom_20, the p-value is <0.06, so we reject the null that beta3 = 0 and conclude there is a significant jump at psu = 475 (6% sig level).
#For himom_10, the p-value is <0.05, so we reject the null that beta3 = 0 and conclude there is a significant jump at psu = 475 (5% sig level).