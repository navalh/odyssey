#Loading libraries needed for this analysis
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(scales)

#Function used to filter an experiment dataset, for convenience with the t-statistic calculations
experiment_filter <- function(dataset, group_type, variable) {
  variable <- enquo(variable)
  
  dataset %>%
    filter(group == group_type) %>%
    select(!!variable) %>%
    pull() 
}

#Import shopper experiment data, and create a success flag and cost variable
shoppers <- read.csv("U:/Instacart/applicant_data.csv", header = TRUE, sep = ",") %>%
  mutate(success = if_else(event == 'first_batch_completed_date', 1, 0),
         cost = if_else(event == 'background_check_completed_date', 30, 0))

###############
#Q1: What can we conclude from the A/B test? How confident should we be in this conclusion?
###############

#Filter shopper data 
experiment <- shoppers %>%
  group_by(group, applicant_id, channel, city) %>%
  summarise(converted = sum(success),
            shopper_cost = sum(cost)) %>%
  ungroup()

#H0: difference between average conversion rates for control and treatement is 0
#H1: difference between average conversion rates for control and treatement is less than 0
#We use the one-sided test here, because the theory is that having the background check earlier INCREASES conversion rate
conversion_rate_t <- t.test(experiment_filter(experiment, "control", converted), 
                            experiment_filter(experiment, "treatment", converted),
                            alternative = "less")

#Calculate conversion rate for control/treatment
experiment2 <- experiment %>%
  group_by(group) %>%
  summarise(sample_size = n(),
            sum_converted = sum(converted),
            sum_shopper_cost = sum(shopper_cost),
            conversion_rate = sum_converted/sample_size,
            avg_cost = sum_shopper_cost/sample_size) %>%
  ungroup() 
  
#Plot conversion 
graph <- ggplot(data.frame(experiment2), aes(x=group, y = conversion_rate, fill = group)) + 
  geom_bar(position="stack", stat = "identity") +
  scale_y_continuous(limits = c(0, 0.4), labels = scales::percent) +
  labs(title="Conversion Rate Observed in Control/Treatment Sample",
          x ="Testing Group", y = "Conversion Rate") +
  theme(plot.title = element_text(hjust = 0.5))
  

###############
#Q2: Is this change cost-effective? To be conclusive, we need to make an assumption about average shopper's profit to Instacart
###############

# Alternatively, we can calculate a break-even profit value. Let x = Break-even average shopper's profit to Instacart
# x * conversion_rate (treatment) - avg_cost (treatment) = x * conversion_rate (control) - avg_cost (control)
break_even_shopper_profit <- (experiment_filter(experiment2, "treatment", avg_cost) - 
                                experiment_filter(experiment2,"control", avg_cost))/
  (experiment_filter(experiment2,"treatment", conversion_rate) - 
     experiment_filter(experiment2,"control", conversion_rate))

###############
#Q3: Do we have any other observations and recommendations?
###############

#Q3a: What was the distribution of control/treatment profiles in this A/B Test? Were the two samples similar?
profile1 <- experiment %>%
  group_by(channel, group) %>%
  summarize(counts = n()) %>%
  left_join(experiment2, "group") %>%
  mutate(pct = counts/sample_size) %>%
  select(channel, group, counts, pct)

profile2 <- experiment %>%
  group_by(city, group) %>%
  summarize(counts = n()) %>%
  left_join(experiment2, "group") %>%
  mutate(pct = counts/sample_size) %>%
  select(city, group, counts, pct)

graph2 <- ggplot(data.frame(profile1), aes(x=channel, y = pct, fill = group)) + 
  geom_bar(position="dodge", stat = "identity") +
  scale_y_continuous(limits = c(0, 0.5), labels = scales::percent) +
  labs(title="Channel Breakdown in Control/Treatment Sample",
       x ="Channel of Applicants", y = "Percentage of Group") +
  theme(plot.title = element_text(hjust = 0.5))

graph3 <- ggplot(data.frame(profile2), aes(x=city, y = pct, fill = group)) + 
  geom_bar(position="dodge", stat = "identity") +
  scale_y_continuous(limits = c(0, 0.5), labels = scales::percent) +
  labs(title="City Breakdown in Control/Treatment Sample",
       x ="City of Applicants", y = "Percentage of Group") +
  theme(plot.title = element_text(hjust = 0.5))

#Q3b: Did the treatment group convert faster? How confident are we that they did?
#This can be measured with a "conversion days" variable

converted_date <- shoppers %>%
  filter(success == 1)
converted_date$event_date <-as.Date(converted_date$event_date, "%m/%d/%Y")

application_date <- shoppers %>%
  filter(event == "application_date")
application_date$event_date <-as.Date(application_date$event_date,"%m/%d/%Y")

experiment3 <- experiment %>%
  inner_join(select(converted_date, applicant_id, converted_date = event_date), "applicant_id") %>%
  left_join(select(application_date, applicant_id, application_date = event_date), "applicant_id") %>%
  mutate(conversion_days = converted_date - application_date) 

avg_conversion_days_t <- t.test(experiment_filter(experiment3, "control", conversion_days), 
                                experiment_filter(experiment3, "treatment", conversion_days),
                                alternative = "greater")

experiment4 <- experiment3 %>%
  group_by(group) %>%
  summarise(sample_size = n(),
            sum_conversion_days = sum(conversion_days),
            avg_conversion_days = sum_conversion_days/sample_size) 