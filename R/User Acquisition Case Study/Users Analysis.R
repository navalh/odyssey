#Loading libraries needed for this analysis
library(dplyr)
library(tidyr)
library(xtable)


#Question 1: What are the differences/similarities of customers by channel?
#Can look at source, group and conversion days

#To re-run this code, the import directory needs to be changed as appropriate
users <- read.csv("C:/Users/Naval/Desktop/DH Coding Assignment/users.csv", header = TRUE, sep = ",") %>%
  mutate(source_num = as.numeric(substr(source, 7, 7)))

#Break down users by channel and source
users_by_channel_source <- users %>%
  na.omit() %>%
  group_by(channel, source_num) %>%
  summarise(total_obs = n()) %>%
  mutate(percent_of_channel = total_obs/sum(total_obs)) %>%
  select(channel, source_num, percent_of_channel) %>%
  spread(channel, percent_of_channel)

table1 <- data.frame(users_by_channel_source[,-1])

rownames(table1) <- c("Source 1", "Source 2", "Source 3")
colnames(table1) <- c("Proportion of Channel 1", "Proportion of Channel 2")
xtable(table1)

#Break down users by channel and group
users_by_channel_group <- users %>%
  na.omit() %>%
  group_by(channel, group) %>%
  summarise(total_obs = n()) %>%
  mutate(percent_of_channel = total_obs/sum(total_obs)) %>%
  select(channel, group, percent_of_channel) %>%
  spread(channel, percent_of_channel)

table2 <- data.frame(users_by_channel_group[,-1])
rownames(table2) <- c("Group 1", "Group 2", "Group 3", "Group 4", "Group 5", "Group 6")
colnames(table2) <- c("Proportion of Channel 1", "Proportion of Channel 2")
xtable(table2)

#Break down users by channel and conversion days
users_by_channel_conversion <- users %>%
  na.omit() %>%
  group_by(channel) %>%
  summarise(total_obs = n(), avg_conversion = mean(conversiondays), max_conversion = max(conversiondays), 
            percentile_75 = quantile(conversiondays, probs=0.75),
            percentile_95 = quantile(conversiondays, probs=0.95))

table3 <- data.frame(users_by_channel_conversion[, -1])
rownames(table3) <- c("Channel 1", "Channel 2")
colnames(table3) <- c("Total Customers", "Average Conversion Days", "Max Conversion Days", 
                      "75th Percentile of Conversion Days", "95th Percentile of Conversion Days")
xtable(t(table3))

#Question 2: What is the most valuable channel?
orders <- read.csv("C:/Users/Naval/Desktop/DH Coding Assignment/orders.csv", header = TRUE, sep = ",")

#Aggregate order data so that one row corresponds to one user, to use for the join to the users dataset
orders_agg <- orders %>%
  group_by(owner_id) %>%
  summarise(total_orders = n(), min_age = min(age), max_age = max(age), lifetime = max_age - min_age)

users_orders <- users %>%
  left_join(orders_agg, by = c("id" = "owner_id"))

#Group user order data by channel 
users_orders_by_channel <- users_orders %>%
  na.omit() %>%
  group_by(channel) %>%
  summarise(total_customers_with_orders = n(), total_orders_by_channel = sum(total_orders), 
            avg_orders_by_channel = mean(total_orders), avg_conversion_by_channel = mean(conversiondays),
            avg_lifetime_by_channel = mean(lifetime)) 
  
table4 <- data.frame(users_orders_by_channel[, -1])
rownames(table4) <- c("Channel 1", "Channel 2")
colnames(table4) <- c("Total Customers with Orders", "Total Orders within Channel", "Average Orders per Customer",
                      "Average Conversion Days", "Average Customer Lifetime")
xtable(t(table4))

#Function used to filter user order dataset, for convenience with the t-statistic calculations
users_orders_filter <- function(channel_num, variable) {
  variable <- enquo(variable)
  
  users_orders %>%
    na.omit() %>%
    filter(channel == channel_num) %>%
    select(!!variable) 
}

#T-stats of the 3 types of averages calculated in Table 4
avg_order_t <- t.test(users_orders_filter("channel1", total_orders), users_orders_filter("channel2", total_orders))
avg_conversion_t <- t.test(users_orders_filter("channel1", conversiondays), users_orders_filter("channel2", conversiondays))
avg_lifetime_t <- t.test(users_orders_filter("channel1", lifetime), users_orders_filter("channel2", lifetime))