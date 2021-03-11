require(tidyverse)

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

write_csv(data, "quarterly.csv")

