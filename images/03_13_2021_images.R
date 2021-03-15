require(tidyverse)
require(ggsci)
require(ggpubr)
require(table1)

img.height = 11.20*2.25
img.width = 17.92*2
x.labels <- c("Intake", 
              "Follow up #1", "Follow up #2", "Follow up #3", "Follow up #4", "Follow up #5", "Follow up #6", 
              "Follow up #7", "Follow up #8", "Follow up #9")

data <- read_csv("/nfs/turbo/umms-HDS629/soumikp/code/data.csv") %>% 
  mutate(Race = ifelse(Race %in% c("African American", "Asian", "Caucasian"), 
                        Race, 
                        "Other")) %>% 
  mutate(Age.cat = ifelse(Age <= 30, "18-30", 
                          ifelse(Age <= 45, 
                                 "30-45", 
                                 ifelse(Age <= 60, 
                                        "45-60", "60+"))))



### activitiy vs promis for sex-stratified data
promis.sex <- data %>%
  ggplot(aes(x = OBS, y  = promis)) + 
  #geom_line(aes(group = PRID)) + 
  geom_smooth(aes(group = Sex, color = Sex), se = FALSE)  + 
  ylab("PROMIS cognitive score") + 
  xlab("") + 
  labs(title = "GAM-smoothed curve of self-reported PROMIS scores in MIPACT study patients (stratified by gender)", 
       subtitle = "During each survey (intake and subsequent quarterly follow-up) patients were asked to report PROMIS cognition scores based on their mental health during the week leading up to the survey.
We examine the smoothed trajectories of self-reported PROMIS scores over the course of multiple surveys for patients, stratified by gender.") + 
  scale_x_continuous(breaks = seq(1, 10, 1), labels = x.labels) + 
  theme_bw() + 
  theme(legend.position = "bottom") + 
  scale_color_jco()

active.sex <- data %>%
  ggplot(aes(x = OBS, y  = act)) + 
  #geom_line(aes(group = PRID)) + 
  geom_smooth(aes(group = Sex, color = Sex), se = FALSE)  + 
  ylab("Exercise time (minutes)") + 
  xlab("") + 
  labs(title = "GAM-smoothed curve of HealthKit\uA9 Exercise Time (stratified by gender)", 
       subtitle = "During each survey (intake and subsequent quarterly follow-up) patients were asked to report PROMIS cognition scores based on their mental health during the week leading up to the survey.
We examine the smoothed trajectories of time spent exercising (collected through Apple HealthKit\uA9) in the week leading up to each survey, over the course of multiple surveys, stratified by gender.") + 
  scale_x_continuous(breaks = seq(1, 10, 1), labels = x.labels) + 
  theme_bw() + 
  theme(legend.position = "bottom") + 
  scale_color_jco()

ggsave("/nfs/turbo/umms-HDS629/soumikp/code/promis_active_sex.png",
  ggpubr::ggarrange(promis.sex, active.sex, ncol = 1, common.legend = TRUE, legend = "bottom"), 
  height = img.height, 
  width = img.width, 
  units = "cm", 
  dpi = 300)


### activitiy vs promis for race-stratified data
promis.race <- data %>%
  drop_na() %>% 
  ggplot(aes(x = OBS, y  = promis)) + 
  #geom_line(aes(group = PRID)) + 
  geom_smooth(aes(group = Race, color = Race), method = "loess", se = FALSE)  + 
  ylab("PROMIS cognitive score") + 
  xlab("") + 
  labs(title = "GAM-smoothed curve of self-reported PROMIS scores in MIPACT study patients (stratified by race)", 
       subtitle = "During each survey (intake and subsequent quarterly follow-up) patients were asked to report PROMIS cognition scores based on their mental health during the week leading up to the survey.
We examine the smoothed trajectories of self-reported PROMIS scores over the course of multiple surveys for patients, stratified by race.") + 
  scale_x_continuous(breaks = seq(1, 10, 1), labels = x.labels) +  
  theme_bw() + 
  theme(legend.position = "bottom") + 
  scale_color_jco()

active.race <- data %>%
  drop_na() %>% 
  ggplot(aes(x = OBS, y  = act)) + 
  #geom_line(aes(group = PRID)) + 
  geom_smooth(aes(group = Race, color = Race), method = "loess", se = FALSE)  + 
  ylab("Exercise time (minutes)") + 
  xlab("") + 
  labs(title = "GAM-smoothed curve of HealthKit\uA9 Exercise Time (stratified by race)", 
       subtitle = "During each survey (intake and subsequent quarterly follow-up) patients were asked to report PROMIS cognition scores based on their mental health during the week leading up to the survey.
We examine the smoothed trajectories of time spent exercising (collected through Apple HealthKit\uA9) in the week leading up to each survey, over the course of multiple surveys, stratified by race.") + 
  scale_x_continuous(breaks = seq(1, 10, 1), labels = x.labels) + 
  theme_bw() + 
  theme(legend.position = "bottom") + 
  scale_color_jco()

ggsave("/nfs/turbo/umms-HDS629/soumikp/code/promis_active_race.png",
       ggpubr::ggarrange(promis.race, active.race, ncol = 1, common.legend = TRUE, legend = "bottom"), 
       height = img.height, 
       width = img.width, 
       units = "cm", 
       dpi = 300)


### activitiy vs promis for age-stratified data
promis.age <- data %>%
  drop_na() %>% 
  ggplot(aes(x = OBS, y  = PROMIS)) + 
  #geom_line(aes(group = PRID)) + 
  geom_smooth(aes(group = Age.cat, color = Age.cat), method = "loess", se = FALSE)  + 
  ylab("PROMIS cognitive score") + 
  xlab("") + 
  labs(title = "GAM-smoothed curve of self-reported PROMIS scores in MIPACT study patients (stratified by age group)", 
       subtitle = "During each survey (intake and subsequent quarterly follow-up) patients were asked to report PROMIS cognition scores based on their mental health during the week leading up to the survey.
We examine the smoothed trajectories of self-reported PROMIS scores over the course of multiple surveys for patients, stratified by age group.", 
       color = "Age group") + 
  scale_x_continuous(breaks = seq(1, 10, 1), labels = x.labels) +  
  theme_bw() + 
  theme(legend.position = "bottom") + 
  scale_color_jco() 

active.age <- data %>%
  drop_na() %>% 
  ggplot(aes(x = OBS, y  = Activity)) + 
  #geom_line(aes(group = PRID)) + 
  geom_smooth(aes(group = Age.cat, color = Age.cat), method = "loess", se = FALSE)  + 
  ylab("Exercise time (minutes)") + 
  xlab("") + 
  labs(title = "GAM-smoothed curve of HealthKit\uA9 Exercise Time (stratified by age group)", 
       subtitle = "During each survey (intake and subsequent quarterly follow-up) patients were asked to report PROMIS cognition scores based on their mental health during the week leading up to the survey.
We examine the smoothed trajectories of time spent exercising (collected through Apple HealthKit\uA9) in the week leading up to each survey, over the course of multiple surveys, stratified by age group.", 
       color = "Age group") + 
  scale_x_continuous(breaks = seq(1, 10, 1), labels = x.labels) + 
  theme_bw() + 
  theme(legend.position = "bottom") + 
  scale_color_jco()

ggsave("code/promis_active_age.png",
       ggpubr::ggarrange(promis.age, active.age, ncol = 1, common.legend = TRUE, legend = "bottom"), 
       height = img.height, 
       width = img.width, 
       units = "cm", 
       dpi = 300)

#### marital status ####
promis.marital <- data %>%
  drop_na() %>% 
  ggplot(aes(x = OBS, y  = PROMIS)) + 
  #geom_line(aes(group = PRID)) + 
  geom_smooth(aes(group = Marital, color =Marital), method = "loess", se = FALSE)  + 
  ylab("PROMIS cognitive score") + 
  xlab("") + 
  labs(title = "GAM-smoothed curve of self-reported PROMIS scores in MIPACT study patients (stratified by marital status)", 
       subtitle = "During each survey (intake and subsequent quarterly follow-up) patients were asked to report PROMIS cognition scores based on their mental health during the week leading up to the survey.
We examine the smoothed trajectories of self-reported PROMIS scores over the course of multiple surveys for patients, stratified by marital status.", 
       color = "Marital Status") + 
  scale_x_continuous(breaks = seq(1, 10, 1), labels = x.labels) +  
  theme_bw() + 
  theme(legend.position = "bottom") + 
  scale_color_jco() 

active.marital <- data %>%
  drop_na() %>% 
  ggplot(aes(x = OBS, y  = Activity)) + 
  #geom_line(aes(group = PRID)) + 
  geom_smooth(aes(group = Marital, color = Marital), method = "loess", se = FALSE)  + 
  ylab("Exercise time (minutes)") + 
  xlab("") + 
  labs(title = "GAM-smoothed curve of HealthKit\uA9 Exercise Time (stratified by marital status)", 
       subtitle = "During each survey (intake and subsequent quarterly follow-up) patients were asked to report PROMIS cognition scores based on their mental health during the week leading up to the survey.
We examine the smoothed trajectories of time spent exercising (collected through Apple HealthKit\uA9) in the week leading up to each survey, over the course of multiple surveys, stratified by marital status.", 
       color = "Age group") + 
  scale_x_continuous(breaks = seq(1, 10, 1), labels = x.labels) + 
  theme_bw() + 
  theme(legend.position = "bottom") + 
  scale_color_jco()

ggsave("code/promis_active_marital.png",
       ggpubr::ggarrange(promis.marital, active.marital, ncol = 1, common.legend = TRUE, legend = "bottom"), 
       height = img.height, 
       width = img.width, 
       units = "cm", 
       dpi = 300)



table1(~`Promis score`|Sex, data = data %>% 
         group_by(PRID) %>% 
         summarise(p = mean(promis, na.rm = TRUE), 
                   Sex = unique(Sex), 
                   Race = unique(Race), 
                   Age = min(Age, na.rm = TRUE), .groups = "drop") %>% 
         rename(`Promis score` = p), 
       topclass = "Rtable1-zebra") 
  
table1(~`Promis score`|Race, data = data %>% 
         group_by(PRID) %>% 
         summarise(p = mean(promis, na.rm = TRUE), 
                   Sex = unique(Sex), 
                   Race = unique(Race), 
                   Age = unique(Age.cat, na.rm = TRUE), .groups = "drop") %>% 
         rename(`Promis score` = p), 
       topclass = "Rtable1-zebra") 

table1(~`Promis score`|Age, data = data %>% 
         group_by(PRID) %>% 
         summarise(p = mean(promis, na.rm = TRUE), 
                   Sex = unique(Sex), 
                   Race = unique(Race), 
                   Age = unique(Age.cat, na.rm = TRUE), .groups = "drop") %>% 
         rename(`Promis score` = p), 
       topclass = "Rtable1-zebra")

require(lme4)
summary(lmer(promis ~ act + Sex + Marital + Race + (1|PRID), 
             data = data))


