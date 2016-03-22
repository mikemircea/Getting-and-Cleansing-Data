----------------------------------------
-- Prerequisites:
----------------------------------------
1) the following are placed in the same folder
	- "UCI HAR Dataset" folder containing data downloaded from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
	- "run_analysis.R" file
2) set working directory to the that folder from R console with:
	setwd("EnterFullPathHere/")
3) run the "run_analysis.R" script from R console with:
	source("mytest.R")
4) file "output.txt" will be placed in the same directory

----------------------------------------
-- Processing steps in "run_analysis.R":
----------------------------------------
1) configure environment - prepare and load packages
2) load data sets from text files into variables:
	- "./UCI HAR Dataset/activity_labels.txt" --> activity_labels
	- "./UCI HAR Dataset/features.txt" --> features
	-------------------- test data --------------------
	- "./UCI HAR Dataset/test/X_test.txt" --> test
	- "./UCI HAR Dataset/test/y_test.txt" --> test_activity
	- "./UCI HAR Dataset/test/subject_test.txt" --> test_subject_to_activity_asgn
	-------------------- train data --------------------
	- "./UCI HAR Dataset/train/X_train.txt" --> train
	- "./UCI HAR Dataset/train/y_train.txt" --> train_activity
	- "./UCI HAR Dataset/train/subject_train.txt" --> train_subject_to_activity_asgn
3) #### task 1.	Merges the training and the test sets to create one data set.
	- test + train --> all_data
	- test_activity + train_activity --> all_activities
	- test_subject_to_activity_asgn + train_subject_to_activity_asgn --> all_subject_to_activity_asgn
	- add IDs to the merged datasets (all_data, all_activities, all_subject_to_activity_asgn)
4) #### task 2.	Extracts only the measurements on the mean and standard deviation for each measurement.
	- prepare list of features(columns) that contain "mean|std" --> featuresMeanStd
	- subtract columns from all_data variable based on filter featuresMeanStd --> all_data_mean_std
5) #### task 3.	Uses descriptive activity names to name the activities in the data set
	- join all_activities with all_data and activity_labels --> all_data_activities
6) #### task 4.	Appropriately labels the data set with descriptive variable names.
	- already solved in previous steps
7) #### task 5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject
	- remove additional columns that are not for interese for aggregation (Test_ID, Activity_ID, data_type) --> all_data_activities_MEAN
	- summarize information from all_data_activities_MEAN --> all_data_output
8) prepare export in "output.txt" file in same directory
	- write in file data from all_data_output variable