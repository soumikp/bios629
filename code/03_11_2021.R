require(tidyverse)
require(lubridate)
require(data.table)

#cleaning quarterly data - promis scores summed
promis.quarter.cleaner <- function(data){
  temp <- data %>% 
    filter(SurveyName == "NIH PROMIS Cognitive Function 4a - Quarterly",
           SurveyTaskStatus == "Complete") %>% 
    select(ParticipantResearchID, SurveyEndDate, SurveyQuestion, SurveyAnswer)
    if(temp %>% nrow() == 0){
    return(NULL)
  }else{
    return(temp %>% 
             unique() %>% 
             pivot_wider(names_from = SurveyQuestion,
                         values_from = SurveyAnswer) %>% 
             select(contains(c("ID", "Date", "In the past"))) %>% 
             rename(PRID = "ParticipantResearchID",
                    time = "SurveyEndDate",
                    X1 = "In the past 7 days:It has seemed like my brain was not working as well as usual",
                    X2 = "In the past 7 days:I have had to work harder than usual to keep track of what I was doing",
                    X3 = "In the past 7 days:I have had trouble shifting back and forth between different activities that require thinking",
                    X4 = "In the past 7 days:My thinking has been slow") %>% 
             mutate(promis =  as.numeric(X1) + as.numeric(X2) + as.numeric(X3) + as.numeric(X4)) %>% 
             select(-contains("X")))
  }
}

data <- NULL
phrase <- "/nfs/turbo/umms-HDS629/MIPACT/HealthKit_Live/Surveys/Surveys_20"
for (i in c("17", "18", "19", "20")){
  for (j in c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")){
    if(i == "20" & j == "12"){
      next
    }else{
      data <- rbind(data, 
                    promis.quarter.cleaner(read_csv(paste0(phrase, i, j, ".csv"))))
    }
  }
}

write_csv(data, "/home/soumikp/bios629_output/quarterly.csv")

temp.intake <- read_csv("/home/soumikp/bios629_output/intake.csv")
temp.quarterly <- read_csv("/home/soumikp/bios629_output/quarterly.csv")

promis <- rbind(temp.intake, temp.quarterly) %>% 
  arrange(PRID, time) %>% 
  drop_na() %>% 
  rename(end = time) %>% 
  mutate(start = end - days(7)) %>% 
  select(PRID, start, end, promis)

write_csv(promis, "/home/soumikp/bios629_output/quarterly.csv")

file.name.creator <- function(start.time, end.time){
  file.start <- paste0(year(start.time),
                       ifelse(month(start.time) < 10, 
                              paste0("0", month(start.time)), 
                              month(start.time)), 
                       ".csv")
  file.end <- paste0(year(end.time),
                     ifelse(month(end.time) < 10, 
                            paste0("0", month(end.time)), 
                            month(end.time)), 
                     ".csv")
  return(unique(c(file.start, file.end)))
}   

active.data <- function(PRID, start.time, end.time){
  files <- file.name.creator(start.time, end.time)
  if(length(files) == 1){
    return(as_tibble(fread(paste0("/nfs/turbo/umms-HDS629/MIPACT/HealthKit_Live/Healthkit_AppleExerciseTime/AppleExerciseTime_", 
                           files))) %>% 
             drop_na() %>% 
             filter(ParticipantResearchID == PRID) %>% 
             filter(StartDate >= start.time & Date <= end.time) %>% 
             summarise(active = sum(Value)) %>% 
             pull(active))
  }else{
    file <- as_tibble(rbind(fread(paste0("/nfs/turbo/umms-HDS629/MIPACT/HealthKit_Live/Healthkit_AppleExerciseTime/AppleExerciseTime_", 
                                  files[1])), 
                  fread(paste0("/nfs/turbo/umms-HDS629/MIPACT/HealthKit_Live/Healthkit_AppleExerciseTime/AppleExerciseTime_", 
                                  files[2])))) %>% drop_na()
    return(file %>% 
             filter(ParticipantResearchID == PRID) %>% 
             filter(StartDate >= start.time & Date <= end.time) %>% 
             summarise(active = sum(Value)) %>% 
             pull(active))
  }
}

#system.time(temp %>% rowwise() %>% mutate(act = possibly(active.data, otherwise = NA_real_)(PRID, start, end)))
