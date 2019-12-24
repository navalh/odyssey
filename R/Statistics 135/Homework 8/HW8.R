x <- c(41, 38.4, 24.9, 25.9, 21.9, 18.3, 13.1, 27.3, 28.5, -16.9, 17.4, 21.8, 15.4, 
       27.4, 19.2, 22.4, 17.7, 26, 29.4, 21.4, 22.7, 26, 26.6) #Control
y <- c(10.1, 6.1, 20.4, 7.3, 14.3, 15.5, -9.9, 6.8, 28.2, 17.9, -12.9, 14, 6.6, 12.1,
       15.7, 39.9, -15.9, 54.6, -14.7, 44.1, -9, -9) #Ozone

#This data gives no reason to be paired. Examining their sample variance:
s_X2 <- var(x)
s_Y2 <- var(y)
#We see their variances are very far from each other, implying their population variances are 
#different. Hence, we will use the unpaired unequal variance t-test.
#H0: Mu.x - Mu.y = 0
#H1: Mu.x - Mu.y != 0

sample_mean_difference <- mean(x) - mean(y)
n <- length(x)
m <- length(y)
#SE when variances are unequal
se_unequal <- sqrt(s_X2/n + s_Y2/m)

t_statistic = sample_mean_difference/se_unequal
#Saitherwaite approximation
degree = ((s_X2/n) + (s_Y2/m))^2/(((s_X2/n)^2)/(n-1) + ((s_Y2/m)^2)/(m-1)) 

pvalue <- pt(t_statistic, df = degree, lower.tail = FALSE)*2

#These findings can be summarised by the t.test() function below.
t.test(x, y, var.equal = FALSE, alternative = "two.sided")
