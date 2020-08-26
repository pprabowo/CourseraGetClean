##Get files from main directory
  library(data.table)
  library(dplyr)
  library(stringr)
  features <- fread("features.txt", select = 2)
  activities <- fread("activity_labels.txt", select = 2)

##Get files from test directory
  setwd("./test")
  xtest <- fread("X_test.txt")
  ytest <- fread("y_test.txt")
  subjecttest <- fread("subject_test.txt")
  setwd('..')

##Get files from train directory
  setwd("./train")
  xtrain <- fread("X_train.txt")
  ytrain <- fread("y_train.txt")
  subjecttrain <- fread("subject_train.txt")
  setwd('..')

##STEP 1. Merge train and test datasets
##First 2947 rows of the merged dataset contain the test data, while the rest of the rows contain the train data
##Then, the activity labels and the subject codes columns are added to the main (X files) dataset, respectively
  mergedset <- as.data.frame(cbind(rbind(subjecttest,subjecttrain),rbind(ytest,ytrain),rbind(xtest,xtrain)))
  for(i in (1:nrow(features))){
    colnames(mergedset)[i+2] <- features[i]
  }
  colnames(mergedset)[1] <- "Subject ID"
  colnames(mergedset)[2] <- "Activity"
  ##Delete variables from workspace for efficiency
  rm("xtest", "xtrain", "ytest", "ytrain", "subjecttest", "subjecttrain", "features")

##STEP 2. Extract the mean and standard deviation variables only (stored into meanstdset variable)
  meancolumns <- which(grepl("mean\\(\\)",names(mergedset)))
  stdcolumns <- which(grepl("std\\(\\)",names(mergedset)))
  meanstdcolumns <- sort(c(meancolumns,stdcolumns))
  tidyset <- mergedset[,c(1:2,meanstdcolumns)]
  
##STEP 3. Descriptive Activity Names
  activitylist <- c(toString(activities[1]),toString(activities[2]),toString(activities[3]),toString(activities[4]),toString(activities[5]),toString(activities[6]))
  activitylist <- sub("_", " ", activitylist)
  activitylist <- str_to_title(activitylist)
  tidyset$Activity <- factor(tidyset$Activity, labels = activitylist)
  rm("activities", "activitylist", "i", "meancolumns", "meanstdcolumns", "stdcolumns")
  
##STEP 4. Descriptive Variable Names
  names(tidyset) <- gsub("^t", "Time Domain ", names(tidyset))
  names(tidyset) <- gsub("^f", "Frequency Domain ", names(tidyset))
  names(tidyset) <- gsub("BodyAcc", "Body Acceleration ", names(tidyset))
  names(tidyset) <- gsub("GravityAcc", "Gravity Acceleration ", names(tidyset))
  names(tidyset) <- gsub("Mag", "Magnitude ", names(tidyset))
  names(tidyset) <- gsub("BodyGyro", "Body Gyroscopic ", names(tidyset))
  names(tidyset) <- gsub("-mean\\(\\)", "Mean ", names(tidyset))
  names(tidyset) <- gsub("-std\\(\\)", "Std. Deviation ", names(tidyset))
  names(tidyset) <- gsub("-", "", names(tidyset))
  names(tidyset) <- gsub("X$", "X Axis", names(tidyset))
  names(tidyset) <- gsub("Y$", "Y Axis", names(tidyset))
  names(tidyset) <- gsub("Z$", "Z Axis", names(tidyset))
  names(tidyset) <- gsub("BodyBody", "Body", names(tidyset))
  names(tidyset) <- gsub("Jerk", "Jerk ", names(tidyset))
  
##STEP 5. Create second Tidy Data Set with average of each variable for each subject
  secondTidy <- tidyset %>% 
                group_by(`Subject ID`, Activity) %>%
                summarize_all(mean)