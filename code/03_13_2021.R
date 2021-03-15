require(tidyverse)
require(data.table)
require(lubridate)
require(purrr)
# 
# file.name.creator <- function(start.time, end.time){
#   file.start <- paste0(year(start.time),
#                        ifelse(month(start.time) < 10, 
#                               paste0("0", month(start.time)), 
#                               month(start.time)), 
#                        ".csv")
#   file.end <- paste0(year(end.time),
#                      ifelse(month(end.time) < 10, 
#                             paste0("0", month(end.time)), 
#                             month(end.time)), 
#                      ".csv")
#   return(unique(c(file.start, file.end)))
# }  
# 
# basal.data <- function(PRID, start.time, end.time){
#   files <- file.name.creator(start.time, end.time)
#   if(length(files) == 1){
#     return(as_tibble(fread(paste0("/nfs/turbo/umms-HDS629/MIPACT/HealthKit_Live/Healthkit_BasalBodyTemperature/BasalBodyTemperature_", 
#                                   files))) %>% 
#              filter(ParticipantResearchID == PRID) %>% 
#              filter(StartDate >= start.time & Date <= end.time) %>% 
#              summarise(active = sum(Value)) %>% 
#              pull(active))
#   }else{
#     file <- as_tibble(rbind(fread(paste0("/nfs/turbo/umms-HDS629/MIPACT/HealthKit_Live/Healthkit_BasalBodyTemperature/BasalBodyTemperature_", 
#                                          files[1])), 
#                             fread(paste0("/nfs/turbo/umms-HDS629/MIPACT/HealthKit_Live/Healthkit_BasalBodyTemperature/BasalBodyTemperature_", 
#                                          files[2])))) 
#     return(file %>% 
#              filter(ParticipantResearchID == PRID) %>% 
#              filter(StartDate >= start.time & Date <= end.time) %>% 
#              summarise(active = sum(Value)) %>% 
#              pull(active))
#   }
# }
# 
# i <- as.numeric(Sys.getenv("SLURM_ARRAY_TASK_ID"))
# 
# begin <- 60*(i-1) + 1
# end <- min(60*i, 29320)
# 
# promis <- as_tibble(fread("/home/soumikp/bios629_output/promis.csv"))[begin:end, ]
# 
# temp <- promis %>% 
#   rowwise() %>% 
#   mutate(act = possibly(basal.data, otherwise = NA_real_)(PRID, start, end))
# 
# write_csv(temp, paste0("/home/soumikp/bios629_output/slurm_op/basal_", i, ".csv"))
# 

active <- NULL

for(i in 1:489){
  filename = paste0("/home/soumikp/bios629_output/slurm_op/promis_", i, ".csv")
  temp <- as_tibble(fread(filename))
  active <- rbind(temp, active)
}

demo <- read_csv("/nfs/turbo/umms-HDS629/MIPACT/HealthKit_Live/EHR/EHR_Demographic_202010.csv") %>% 
  rename(PRID = ParticipantResearchID, 
         Age = AgeAtEnrollment, 
         Sex = GenderName, 
         Marital = MaritalStatusName, 
         Race = RaceName) %>% 
  select(PRID, Age, Sex, Marital, Race)


data <- left_join(active, demo) %>% 
  group_by(PRID) %>% 
  mutate(OBS = seq_along(end)) %>% 
  select(PRID, OBS, promis, act, Age, Sex, Marital, Race) %>% 
  ungroup()

#write_csv(active, "/home/soumikp/bios629_output/data.csv")

data <- data %>% 
  rename(PROMIS = promis, 
         Activity = act) %>% 
  mutate(Race = ifelse(Race %in% c("Asian", "Caucasian", "African American"),
                       Race, 
                       "Other")) %>% 
  mutate(Age.cat = ifelse(Age <= 30, "18 - 30", 
                          ifelse(Age <= 45, "30 - 45", 
                                 ifelse(Age <= 60, "45 - 60", "60+"))))

require(lme4)

# inv.norm <- function(x){
#   qnorm((rank(x,na.last="keep")-0.5)/sum(!is.na(x)))
# }

model <- lmer(PROMIS ~ as.factor(OBS)+ Age + Sex + Marital + Race + Activity + (1|PRID), 
              data = data #%>% mutate(PROMIS = inv.norm(PROMIS))
              )

summary(model)
tab_model(model)

table1::table1(~PROMIS|Age.cat, data = data)
table1::table1(~PROMIS|Sex, data = data)
table1::table1(~PROMIS|Race, data = data)
table1::table1(~PROMIS|Marital, data = data)
