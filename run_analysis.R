# Import required libraries
library(plyr)

# Check current directory name
if(basename(getwd()) != "UCI HAR Dataset")
{
  stop("Current directory is not 'UCI HAR Dataset'");
}

# Read common files - activity and feature info
activity_labelsDF <- read.table(file = "./activity_labels.txt", 
                                stringsAsFactors = F, 
                                col.names = c("activityId", "activityLabel"))

featuresDF <- read.table(file = "./features.txt",
                         stringsAsFactors = F)

# Common function to read various files in test & train datasets
fn_load_Data <- function(subjectFile, xFile, yFile, act_DF, id)
{
  # Read files data
  subject_DF <- read.table(file = subjectFile,
                           stringsAsFactors = F)
  
  x_DF <- read.table(file = xFile,
                     stringsAsFactors = F,
                     col.names = featuresDF[[2]],
                     check.names = FALSE)
  
  y_DF <- read.table(file = yFile,
                     stringsAsFactors = F,
                     col.names = "subjectId")
  
  who_did_whatDF <- data.frame(subject_DF, y_DF)
  names(who_did_whatDF) <- c("subjectId","activityId")
  
  # Join activityIds & activityNames with subjectIds
  #--------------------------------------------------------
  
  who_did_whatDF <- join(x=who_did_whatDF, 
                         y=act_DF, 
                         by="activityId", 
                         type="left")
  
  # Add Role column
  who_did_whatDF$Role <- rep(id, nrow(who_did_whatDF))
  
  # Consolidate whole test data
  full_data <- data.frame(who_did_whatDF, 
                          x_DF, 
                          check.names = FALSE)
  
  return(full_data)
}

# Call fn_load_Data() to get test dataset
test_data <- fn_load_Data(subjectFile = "./test/subject_test.txt", 
                          xFile = "./test/x_test.txt", 
                          yFile = "./test/y_test.txt",
                          act_DF = activity_labelsDF,
                          id = "Test")

# Call fn_load_Data() to get train dataset
train_data <- fn_load_Data(subjectFile = "./train/subject_train.txt", 
                           xFile = "./train/x_train.txt", 
                           yFile = "./train/y_train.txt",
                           act_DF = activity_labelsDF,
                           id = "Train")

# Merge test & train data to single data frame.
data_full <- rbind(test_data, train_data)

# Filter required columns
data_full_reqd <- data_full[, c(1,3, grep("mean|std", names(data_full)))]

# Clean the column names
names <- names(data_full_reqd)
names <- gsub('-mean', 'Mean', names) # Replace `-mean' by `Mean'
names <- gsub('-std', 'Std', names) # Replace `-std' by 'Std'
names <- gsub(',gravity', 'Gravity', names) # Replace ',gravity by 'Gravity'
names <- gsub('[-()]', '', names) # Remove the parenthesis and dashes
names <- gsub('BodyBody', 'Body', names) # Replace `BodyBody' by `Body'
names(data_full_reqd) <- names

# Group by subject and activity and summarise using mean values
library(dplyr)
data_full_reqd_Summary <- data_full_reqd %>% group_by(subjectId, activityLabel) %>% summarise_each(funs(mean))

# Output result to file "tidy_data.txt"
write.table(data_full_reqd_Summary, 
            "tidy_data.txt", 
            row.names = FALSE, 
            quote = FALSE)
