# Getting-and-Cleansing-Data
Project for Getting and Cleansing Data

Description of "run_analysis.R"
----------------------------------------------------------------
1. In the first part of the script (PREREQUISITES) I configure the environment (packages, path)
2. In the second part of the script I take care of the 1st task (1.	Merges the training and the test sets to create one data set.) by loading all data sets needed in separate objects for test and train datasets and then binding together the "test" and "train" in variable "all_data" as datasets needed to be merged.
3. In the third part I take care of the 2nd task (2.	Extracts only the measurements on the mean and standard deviation for each measurement.). Merged data set from previuos step is now "transposed" in "all_data_gathered" variable using gather. In variable featuresMeanStd i prepare only measures containging requested measures. Then I use this variable as driver for filtering "all_data_gathered" variable.
4. In the 4th part I take care of the 3rd task (3.	Uses descriptive activity names to name the activities in the data set). Merge lists of activities loaded in "all_activities" variable then join this into existing "all_data_gathered" variable.
5. in the 5th pary I take care of the 5th task (5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.) since tasks 4 was implicitely accomplished. Merge lists of subjects loaded in "all_subjects" variable then join this into existing "all_data_gathered" variable. Then create "all_data_gathered_MEAN" without columns that were not requested and apply average of measures values for summarization over features, activity, subject.
6. Export in tab delimited as requested.
