library(RNHANES)
library(stringr)
files <- nhanes_data_files()
results <- nhanes_search(files, "")

for(i in 1:nrow(results)){
  if(is.na(results$data_file_name[i])){
    
  }
  #else if(results$cycle[i] == "2013-2014"){
  #  file_data <- nhanes_load_data(results$data_file_name[i], results$cycle[i], cache = "./nhanes_data")
  #  write.csv(file_data, paste("M:/Documents/ML_Healthcare_Final_Project/NHANES Dataset/", results$cycle[i], "_", results$data_file_name[i], ".csv"))
  #}
  else if(str_detect(results$data_file_name[i], "DEMO")){
    file_data <- nhanes_load_data(results$data_file_name[i], results$cycle[i], cache = "./nhanes_data")
    write.csv(file_data, paste("M:/Documents/ML_Healthcare_Final_Project/NHANES_Dataset/", results$cycle[i], "_", results$data_file_name[i], ".csv"))
  }
}

for(i in 1:nrow(results)){
  if(is.na(results$data_file_name[i])){
    
  }
  #else if(results$cycle[i] == "2013-2014"){
  #  file_data <- nhanes_load_data(results$data_file_name[i], results$cycle[i], cache = "./nhanes_data")
  #  write.csv(file_data, paste("M:/Documents/ML_Healthcare_Final_Project/NHANES Dataset/", results$cycle[i], "_", results$data_file_name[i], ".csv"))
  #}
  else if(str_detect(results$data_file_name[i], "MCQ")){
    file_data <- nhanes_load_data(results$data_file_name[i], results$cycle[i], cache = "./nhanes_data")
    write.csv(file_data, paste("M:/Documents/ML_Healthcare_Final_Project/NHANES_Dataset/", results$cycle[i], "_", results$data_file_name[i], ".csv"))
  }
}



demographics <- read.csv(file = "M:/Documents/ML_Healthcare_Final_Project/national-health-and-nutrition-examination-survey/demographic.csv", header = TRUE, sep = ",")
labs <- read.csv(file = "M:/Documents/ML_Healthcare_Final_Project/national-health-and-nutrition-examination-survey/labs.csv", header = TRUE, sep = ",")

complete_data <- cbind(demographics, labs)


library(sqldf)

complete_data <- sqldf("SELECT de.*,
                               la.*
                        FROM   demographics de LEFT OUTER JOIN labs la
                        ON     de.SEQN = la.SEQN")


complete_data_age <- subset(complete_data, complete_data$RIDAGEYR > 15 & complete_data$RIDAGEYR <= 50)
complete_data_age <- subset(complete_data_age, !is.na(complete_data_age$URDFLOW1))
complete_data_age$urine_flow_state <- ifelse(complete_data_age$URDFLOW1 > 0.35, "Nor", "Abnor")
complete_data_age <- subset(complete_data_age, !is.na(complete_data_age$URDFLOW1))


table(complete_data_age$urine_flow_state, complete_data_age$RIAGENDR)