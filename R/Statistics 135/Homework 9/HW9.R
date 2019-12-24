#Question 22, Chapter 12, Page 509.
tablets2 <- read.csv("tablets2.csv", header=TRUE, sep = ",")
tablets2a <- data.frame(measurement = c(tablets2$Lab1, tablets2$Lab2, 
                                        tablets2$Lab3, tablets2$Lab4, 
                                        tablets2$Lab5, tablets2$Lab6, 
                                        tablets2$Lab7), 
                        lab = rep(paste("lab", 1:7, sep=""), each=10))

i = ncol(tablets2)
j = nrow(tablets2)
df_num = i - 1
df_denom = i*(j-1)

overall_mean = mean(tablets2a$measurement) #Ybar..
treatment_mean = rep(0, i) #Ybari.
for (a in 1:i) {
  treatment_mean[a] = mean(tablets2[ , a])
}

ssw = 0
for (a in 1:i) {
  ssw = ssw + (j-1)*var(tablets2[ , a])
}

ssb = j*(i-1)*var(treatment_mean)

f_statistic = (ssb/df_num)/(ssw/df_denom)
p_value = pf(f_statistic,df_num, df_denom, lower.tail = FALSE) 
#Less than 0.05 so we reject the null with significance level 0.05.

verify <- aov(measurement ~ lab, data = tablets2a) #Gives the same results!
#Now, to use Tukey's method to compare the treatments and see which pairs differ significantly.
#tukey_threshold = qtukey(0.05, i, df_denom, lower.tail = FALSE)*sqrt(ssw/(df_denom*j))

tablets2_tukey = TukeyHSD(verify)
plot(tablets2_tukey)
#We see that lab7-lab5, lab5- lab3, lab4-lab3, lab7-lab2,lab6-lab2, lab5-lab2, lab4-lab2, 
#lab5-lab1 have CIs that do not contain 0.


#Question 28, Chapter 12, Page 510.
watches <- read.csv("watches.csv", header=TRUE, sep = ",")
watchesa <- data.frame(measurement = c(watches$Type.1, watches$Type.2, 
                                       watches$Type.3), 
                       type = rep(paste("type", 1:3, sep=""), each=9))
watchesa <- watchesa[-c(16, 17, 18, 24, 25, 26, 27), ]

i = ncol(watches)
j = c(9, 6, 5)
df_num = i - 1
df_denom = sum(j-1)

overall_mean = mean(watchesa$measurement) #Ybar..
treament_mean = c(mean(watches[ , 1]), mean(watches[ , 2][- c(7,8,9)]), 
                    mean(watches[ , 3][- c(6, 7,8,9)]))
ssw = 8*var(watches[ , 1]) + 5*var(watches[ , 2][- c(7,8,9)]) + 4*var(watches[ , 3][- c(6, 7,8,9)])

ssb = 9*(treament_mean[1] - overall_mean)^2 + 6*(treament_mean[2] - overall_mean)^2 + 5*(treament_mean[3] - overall_mean)^2

f_statistic = (ssb/df_num)/(ssw/df_denom)
p_value = pf(f_statistic,df_num, df_denom, lower.tail = FALSE) 
#Greater than 0.05 so we fail to reject the null with significance level 0.05.

verify <- aov(measurement ~ type, data = watchesa) #Gives the same results!