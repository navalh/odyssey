library(readxl)
library(dplyr)
library(ggplot2)
library(lubridate)
library(reshape2)
library(ggrepel)

################################################################
#Import the Category and FB/Google split for each app
category <- read_excel("C:/Users/Naval/Dropbox/Interview Materials/Take Home Tests/AppsFlyer Case/Naval Handa - Data Analyst Benchmark Test.xlsx", 
                       sheet = "More Info")

#Import the app installs data for Apps A-Z, Organic and Non-Organic --> Join the category data
installs <- read_excel("C:/Users/Naval/Dropbox/Interview Materials/Take Home Tests/AppsFlyer Case/Naval Handa - Data Analyst Benchmark Test.xlsx",
     skip = 3) %>%
  melt(id = "Date", value.name = "installs") %>%
  mutate(app = paste0("App ", substr(variable, 1, 1)),
         type = case_when(
          substr(variable, 3, 4) %in% "Or" ~ "Organic",
           substr(variable, 3, 4) %in% "No" ~ "Non-Organic",
           TRUE ~ "ERROR")) %>%
  select(-c(variable)) %>%
  inner_join(category, by = c("app" = "Application")) %>%
  mutate(fb_installs = case_when(
      type %in% "Non-Organic" ~ goog_fb_factor*installs,
      TRUE ~ 0),
      app_and_industry = paste0(app,", ", Industry))

#Installs aggregated by week to smooth the noisy data
installs_weekly <- installs %>%
  mutate(week = week(Date)) %>%
  group_by (week, app, Industry, goog_fb_factor, app_and_industry, type) %>%
  summarise(installs = sum(installs),
            fb_installs = sum(fb_installs)) %>%
  ungroup(week, app, Industry, goog_fb_factor, app_and_industry, type)

################################################################
#Overall Market Graph
ggplot(data.frame(installs_weekly), aes(x= week, y = installs, fill = type)) + 
  geom_smooth(method = "loess", aes(color = type), size = 0.85) +
  geom_point(aes(color = type), size = 0.83) +
  facet_wrap( ~ app_and_industry, scales = "free") +
  labs(title="Installs over Time (in 2018) of Apps in Market X",
       x ="Week Number (1 = First Week of 2018)", y = "Number of Installs") + 
  theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_text(size = 8)) 

################################################################
#All Apps vs Avg Installs
installs_all <- installs_weekly %>%
  mutate(app_s = substr(app, 5, 5)) %>%
  group_by(app_s) %>%
  summarise(avg_installs = mean(installs))

ggplot(data.frame(installs_all), aes(x= reorder(app_s, avg_installs), y = avg_installs)) + 
  geom_bar(position="stack", stat = "identity", fill = "green") +
  labs(title="Average Weekly Installs of All Apps in Market X",
       x ="App", y = "Average Weekly Installs") + 
  theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_text(size = 8)) 


#Benchmark Apps vs Avg Installs
installs_bench <- installs_weekly %>%
  filter(Industry %in% "Gaming") %>%
  mutate(app_s = substr(app, 5, 5)) %>%
  group_by(app_s) %>%
  summarise(avg_installs = mean(installs)) %>%
  filter(avg_installs > 20000)

ggplot(data.frame(installs_bench), aes(x= reorder(app_s, avg_installs), y = avg_installs)) + 
  geom_bar(position="stack", stat = "identity", fill = "green") +
  labs(title="Average Weekly Installs of Benchmark Apps in Market X",
       x ="App", y = "Average Weekly Installs") + 
  theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_text(size = 8)) 


################################################################
#Avg Non Organic Installs // Avg Google-FB Installs vs. Google-FB Factor
installs_fb <- installs_weekly %>%
  filter(type %in% "Non-Organic") %>%
  group_by(app_and_industry, goog_fb_factor) %>%
  summarise(avg_non_organic_installs = mean(installs),
            avg_fb_installs = mean(fb_installs))

#Graph Non-Organic installs against FB Factor
ggplot(data.frame(installs_fb), aes(x= goog_fb_factor*100, y = avg_non_organic_installs)) + 
  geom_point() +
  geom_label_repel(aes(label = app_and_industry), size = 3, box.padding   = 0.35, point.padding = 0.5, segment.color = 'grey50') +
  labs(title="Average Weekly Non-Organic Installs of Apps vs. % of Non-Organic Installs coming from Google/Facebook",
       x ="% of Non-Organic Installs coming from Google/Facebook", y = "Average Weekly Non-Organic Installs") + 
  theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_text(size = 8))  

#Graph FB installs against FB Factor
ggplot(data.frame(installs_fb), aes(x= goog_fb_factor*100, y = avg_fb_installs)) + 
  geom_point() +
  geom_label_repel(aes(label = app_and_industry), size = 3, box.padding   = 0.35, point.padding = 0.5, segment.color = 'grey50') +
  labs(title="Average Weekly Google/Facebook Installs of Apps vs. % of Non-Organic Installs coming from Google/Facebook",
       x ="% of Non-Organic Installs coming from Google/Facebook", y = "Average Weekly Google/Facebook Installs") + 
  theme(plot.title = element_text(hjust = 0.5), axis.text.y = element_text(size = 8))  



