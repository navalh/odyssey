#Loading libraries needed for this analysis
library(readxl)
library(dplyr)
library(tidyr)
library(ggplot2)
library(scales)
library(lubridate)

#Import Users Find Savings (Sephora) transaction data
transactions <- read_excel("Data.xlsx") %>%
  #Assumption - Missing commission implies 0 commission, not a missing value
  mutate(commission = coalesce(commission, 0),
    week = floor_date(date, "week"),
    browser_os = paste(browser_name, os_name),
    #Creating bins of Cart Final Price
    cfp_bins = case_when(
      cart_final_price >= 0 & cart_final_price < 100 ~ "$0 - $99",
      cart_final_price >= 100 & cart_final_price < 200 ~ "$100 - 199",
      cart_final_price >= 200 & cart_final_price < 300 ~ "200 - 299",
      cart_final_price >= 300 & cart_final_price < 400 ~ "300 - 399",
      cart_final_price >= 400 & cart_final_price < 500 ~ "400 - 499",
      cart_final_price >= 500 & cart_final_price < 600 ~ "500 - 599",
      cart_final_price >= 600 & cart_final_price < 700 ~ "600 - 699",
      cart_final_price >= 700 & cart_final_price < 800 ~ "700 - 799",
      cart_final_price >= 800 & cart_final_price < 900 ~ "800 - 899",
      cart_final_price >= 900 & cart_final_price < 1000 ~ "900 - 999",
      cart_final_price >= 1000 ~ "1000+"),
    #Calculating ratios of CSP/CFP to Commission to see how they vary
    csp_commission_ratio = ifelse(cart_start_price==0, 0, commission/cart_start_price),
    cfp_commission_ratio = ifelse(cart_final_price==0, 0, commission/cart_final_price)) 


##############
#Code-level dataset
#From here, I repeat some common aggregations:
#Total Count - number of observations for that category
#No Commission - number of transactions with no commission
#Pct No Com - Percentage of transactions that had no commission awarder
#Lifetime Revenue - Total Revenue earned by that category in the timeframe of this dataset (Sept - Dec 2018)

#Notice TWENTYOFF, YESINSIDER have 60%+ no commission rates. 
code_level <- transactions %>%
  group_by(best_code) %>%
  summarise(total_count = n(),
            no_commission = sum(commission==0),
            pct_no_com = no_commission/total_count,
            avg_cart_start = mean(cart_start_price),
            avg_cart_final = mean(cart_final_price),
            sum_cart_final = sum(cart_final_price),
            avg_code_duration = mean(code_run_duration),
            avg_commission = mean(commission),
            lifetime_revenue = sum(commission),
            avg_cfp_ratio = mean(cfp_commission_ratio)) 

scaleFactor3 <- max(filter(code_level, total_count > 100)$total_count) / max(filter(code_level, total_count > 100)$avg_code_duration)
graph3 <- ggplot(data.frame(filter(code_level, total_count > 100)), aes(x=best_code,  width=.4)) +
  geom_col(aes(y=total_count), fill="blue", position = position_nudge(x = -.4)) +
  geom_col(aes(y=avg_code_duration * scaleFactor3), fill="red") +
  scale_y_continuous(name="Number of Transactions", sec.axis=sec_axis(~./scaleFactor3, name="Average Code Duration (Seconds)")) +
  scale_x_discrete() +
  theme(
    axis.title.y.left=element_text(color="blue"),
    axis.text.y.left=element_text(color="blue"),
    axis.title.y.right=element_text(color="red"),
    axis.text.y.right=element_text(color="red")
  ) +
  labs(title="Average Code Run Duration by Best Code Used", x ="Best Code Used") +
  theme(plot.title = element_text(hjust = 0.5))

##############
#Week-level dataset
#I see a weird reporting lag here, where counts spike for a few weeks at a time, and then suddently crash
week_level <- transactions %>%
  group_by(week) %>%
  summarise(total_count = n(),
            no_commission = sum(commission==0),
            pct_no_com = no_commission/total_count,
            avg_cart_start = mean(cart_start_price),
            avg_cart_final = mean(cart_final_price),
            sum_cart_final = sum(cart_final_price),
            avg_code_duration = mean(code_run_duration),
            avg_commission = mean(commission),
            lifetime_revenue = sum(commission),
            avg_cfp_ratio = mean(cfp_commission_ratio)) 

graph1 <- ggplot(data.frame(week_level), aes(x=as.Date(week), y = total_count)) + 
  geom_bar(position="dodge", stat = "identity", fill = "darkmagenta") +
  scale_y_continuous(limits = c(0, 5000)) +
  scale_x_date(limits = c(as.Date("2018-07-01"), as.Date("2018-12-31")), 
               labels = date_format("%m/%d"), breaks = date_breaks("3 weeks")) +
  labs(title="Number of Transactions by Week", x ="Week", y = "Number of Transactions") +
  theme(plot.title = element_text(hjust = 0.5))

graph6 <- ggplot(data.frame(week_level), aes(x=as.Date(week), y = pct_no_com)) + 
  geom_bar(position="dodge", stat = "identity", fill = "darkmagenta") +
  scale_y_continuous(limits = c(0, 1)) +
  scale_x_date(limits = c(as.Date("2018-07-01"), as.Date("2018-12-31")), 
               labels = date_format("%m/%d"), breaks = date_breaks("3 weeks")) +
  labs(title="Number of Transactions by Week", x ="Week", y = "Number of Transactions") +
  theme(plot.title = element_text(hjust = 0.5))

##############
#Day-level dataset
#Many transactions in December had no commission - not good as we want to capture these the most due to holiday shopping.
#Could this be potentially because some holiday items in the cart invalidate the commission? 
day_level <- transactions %>%
  group_by(date) %>%
  summarise(total_count = n(),
            no_commission = sum(commission==0),
            pct_no_com = no_commission/total_count,
            avg_cart_start = mean(cart_start_price),
            avg_cart_final = mean(cart_final_price),
            sum_cart_final = sum(cart_final_price),
            avg_code_duration = mean(code_run_duration),
            avg_commission = mean(commission),
            lifetime_revenue = sum(commission),
            avg_cfp_ratio = mean(cfp_commission_ratio)) 


##############
#Device-level dataset
device_level <- transactions %>%
  group_by(browser_os) %>%
  summarise(total_count = n(),
            no_commission = sum(commission==0),
            pct_no_com = no_commission/total_count,
            avg_cart_start = mean(cart_start_price),
            avg_cart_final = mean(cart_final_price),
            sum_cart_final = sum(cart_final_price),
            avg_code_duration = mean(code_run_duration),
            avg_commission = mean(commission),
            lifetime_revenue = sum(commission),
            avg_cfp_ratio = mean(cfp_commission_ratio)) 

graph4 <- ggplot(data.frame(device_level), aes(x=browser_os, y = total_count)) + 
  geom_bar(position="dodge", stat = "identity", fill = "darkmagenta") +
  scale_y_continuous(limits = c(0, 17000)) +
  scale_x_discrete() +
  labs(title="Number of Transactions by Browser/OS", x ="Browser/OS", y = "Number of Transactions") +
  theme(plot.title = element_text(hjust = 0.5))

scaleFactor2 <- max(device_level$total_count) / max(device_level$avg_code_duration)
graph2 <- ggplot(data.frame(device_level), aes(x=browser_os,  width=.4)) +
  geom_col(aes(y=total_count), fill="blue", position = position_nudge(x = -.4)) +
  geom_col(aes(y=avg_code_duration * scaleFactor2), fill="red") +
  scale_y_continuous(name="Number of Transactions", sec.axis=sec_axis(~./scaleFactor2, name="Average Code Duration (Seconds)")) +
  scale_x_discrete() +
  theme(
    axis.title.y.left=element_text(color="blue"),
    axis.text.y.left=element_text(color="blue"),
    axis.title.y.right=element_text(color="red"),
    axis.text.y.right=element_text(color="red")
  ) +
  labs(title="Average Code Run Duration by Browser/OS", x ="Browser & OS Used") +
  theme(plot.title = element_text(hjust = 0.5))

##############
#Buckets of Cart Final Price-level dataset
cfp_bins_level <- transactions %>%
  group_by(cfp_bins) %>%
  summarise(total_count = n(),
            no_commission = sum(commission==0),
            pct_no_com = no_commission/total_count,
            avg_cart_start = mean(cart_start_price),
            avg_cart_final = mean(cart_final_price),
            sum_cart_final = sum(cart_final_price),
            avg_code_duration = mean(code_run_duration),
            avg_commission = mean(commission),
            lifetime_revenue = sum(commission),
            avg_cfp_ratio = mean(cfp_commission_ratio)) 

scaleFactor5 <- max(cfp_bins_level$lifetime_revenue)/ max(cfp_bins_level$pct_no_com)
graph5 <- ggplot(data.frame(cfp_bins_level), aes(x=cfp_bins,  width=.4)) +
  geom_col(aes(y=lifetime_revenue), fill="blue", position = position_nudge(x = -.4)) +
  geom_col(aes(y=pct_no_com * scaleFactor5), fill="red") +
  scale_y_continuous(name="Total Revenue Earned (USD)", sec.axis=sec_axis(~./scaleFactor5, name="No Commission Rate", labels = scales::percent)) +
  scale_x_discrete(limits=c("0 - 99", "100 - 199", "200 - 299", "300 - 399", "400 - 499",
                            "500 - 599", "600 - 699", "700 - 799", "800 - 899", "900 - 999", "1000+")) +
  theme(
    axis.title.y.left=element_text(color="blue"),
    axis.text.y.left=element_text(color="blue"),
    axis.title.y.right=element_text(color="red"),
    axis.text.y.right=element_text(color="red")
  ) +
  labs(title="Total Revenue Earned and No Commission Rates (Sept - Dec 2018) by Cart Final Price", x ="Cart Final Price (USD)") +
  theme(plot.title = element_text(hjust = 0.5))

##############

  






