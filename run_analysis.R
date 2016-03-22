############################################################################################################
#### PREREQUISITES :
############################################################################################################

## setwd("D:/Mike/Work/Personal/2016.01.04 - 2016.02.03 - Getting and Cleaning Data/week 04 - Project 01 - Getting and Cleaning Data Course Project/")

## install&load "plyr", "dplyr", "tidyr" packages
install.packages("plyr")		# HTTPS CRAN mirror : Spain (Madrid)[https] was selected
install.packages("dplyr")
install.packages("tidyr")
install.packages("reshape2")
library(plyr)
library(dplyr)
library(tidyr)
library(reshape2)

## we want to use all the 8 digits after the comma for the measurements
options(digits=16)

## load data sets for dimensions : activity_labels and features
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("Activity_ID", "Activity_Name"), stringsAsFactors=FALSE, header=FALSE, comment.char="", quote="\"")
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("Feature_ID", "Feature_Name"), stringsAsFactors=FALSE, header=FALSE, comment.char="", quote="\"")

#### load data sets for 'test', put proper names on columns, create join keys for each data set
test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE); 																		## 2947 x 561
## add labels from "features.txt" to variable 'test'
names(test) <- features[, 2];
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("Activity_ID"), header=FALSE);								## 2947 x 1
test_subject_to_activity_asgn <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject_ID"), header=FALSE);			## 2947 x 1

#### load data sets for 'train', put proper names on columns, create join keys for each data set
train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE); 																		## 7352 x 561
## add labels from "features.txt" to variable 'train'
names(train) <- features[, 2];
train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("Activity_ID"), header=FALSE);								## 7352 x 1
train_subject_to_activity_asgn <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject_ID"), header=FALSE);			## 7352 x 1

############################################################################################################
#### task 1.	Merges the training and the test sets to create one data set.
############################################################################################################
all_data = rbind(test, train);
all_activities = bind_rows(test_activity, train_activity);
all_subject_to_activity_asgn = bind_rows(test_subject_to_activity_asgn, train_subject_to_activity_asgn);

############################################################################################################
#### task 2.	Extracts only the measurements on the mean and standard deviation for each measurement.
############################################################################################################
featuresMeanStd <- filter(features, grepl('mean|std', Feature_Name));
all_data_mean_std <- all_data[, featuresMeanStd[,2]]

############################################################################################################
#### task 3.	Uses descriptive activity names to name the activities in the data set
############################################################################################################
all_data_activities <- cbind(all_subject_to_activity_asgn, all_data);
all_activities <- merge(all_activities, activity_labels, by='Activity_ID', all.y = TRUE);
all_data_activities <- cbind(select(all_activities, -Activity_ID), all_data_activities);

############################################################################################################
#### task 4.	Appropriately labels the data set with descriptive variable names.
############################################################################################################
# done

############################################################################################################
#### task 5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
############################################################################################################
all_data_output <- melt(all_data_activities, id=c("Activity_Name", "Subject_ID"), measure.vars=c(features[, 2]));
all_data_output <- summarize(group_by(all_data_output, Subject_ID, Activity_Name, as.character(variable)), mean(value));
names(all_data_output)[3] <- paste("Measurement")
names(all_data_output)[4] <- paste("Mean_Value")

############################################################################################################
#### Please upload the tidy data set created in step 5 of the instructions. Please upload your data set as a txt file created with write.table() using
#### row.name=FALSE (do not cut and paste a dataset directly into the text box, as this may cause errors saving your submission).
############################################################################################################
write.table(all_data_output, "output.txt", sep="\t", row.name=FALSE);

#### loaded at : https://github.com/mikemircea/Getting-and-Cleansing-Data/blob/master/README.md