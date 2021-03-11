require(tidyverse)

#cleaning intake data - promis scores summed
promis.intake.cleaner <- function(data){
  
  temp <- data %>% 
    filter(SurveyTaskStatus == "Complete", 
           SurveyName == "NIH PROMIS Cognitive Function 4a - Intake") %>% 
    select(ParticipantResearchID, SurveyEndDate, SurveyQuestion, SurveyAnswer)
  
  if(temp %>% nrow() == 0){
    return(NULL)
  }else{
    return(temp %>% 
             pivot_wider(names_from = SurveyQuestion,
                         values_from = SurveyAnswer) %>% 
             select(contains(c("ID", "Date", "In the past"))) %>% 
             rename(PRID = "Participant Research ID",
                    time = "Survey End Date",
                    X1 = "In the past 7 days:It has seemed like my brain was not working as well as usual",
                    X2 = "In the past 7 days:I have had to work harder than usual to keep track of what I was doing",
                    X3 = "In the past 7 days: I have had trouble shifting back and forth between different activities",
                    X4 = "In the past 7 days:My thinking has been slow") %>% 
             mutate(promis = (as.numeric(X1) + as.numeric(X2) + as.numeric((X3) + as.numeric(X4)))) %>% 
             select(-contains("X")))
  }
  }
  
  

data <- NULL

phrase <- "/nfs/turbo/umms-HDS629/MIPACT/HealthKit_Live/Surveys/Surveys_20"

for (i in c("17", "18", "19", "20")){
  for (j in c("01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12")){
    data <- rbind(data, 
                  promis.intake.cleaner(read_csv(paste(phrase, i, j, ".csv"))))
  }
}
