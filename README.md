# Getting and Cleaning Data - Course Project

This is the course project for the Getting and Cleaning Data Coursera course.

The R script, 'run_analysis.R', does the following:

1. Access the dataset if it exists in the working directory 'UCI HAR Dataset'
2. Read common files - activity and feature info
3. Define common function fn_load_Data() to read various files in test & train datasets
4. Call fn_load_Data() to get test dataset
5. Call fn_load_Data() to get train dataset
6. Merge test & train data to single data frame.
7. Filter only those columns which reflect a mean or standard deviation
8. Clean the column names
	* Replace '-mean' by 'Mean'
	* Replace '-std' by 'Std'
	* Replace ',gravity by 'Gravity'
	* Remove the parenthesis and dashes
	* Replace 'BodyBody' by 'Body'
9. Group by subject and activity and summarise using mean values
10. Output end result to file "tidy_data.txt"
