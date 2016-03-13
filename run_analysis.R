############################################################################################################
#### PREREQUISITES :
############################################################################################################

## install&load "plyr", "dplyr", "tidyr" packages
install.packages("plyr")		# HTTPS CRAN mirror : Spain (Madrid)[https] was selected
install.packages("dplyr")
install.packages("tidyr")
library(plyr)
library(dplyr)
library(tidyr)

## set working directory, it has subridectories with data to be managed
setwd("D:/Mike/Work/Personal/2016.01.04 - 2016.02.03 - Getting and Cleaning Data/week 04 - Project 01 - Getting and Cleaning Data Course Project/")

## we want to use all the 8 digits after the comma for the measurements
options(digits=16)

## load data sets for dimensions
#activity_labels <- read.delim2("./UCI HAR Dataset/activity_labels.txt", sep=" ", row.names = NULL, col.names = c("Activity_ID", "Activity_Name"), stringsAsFactors=FALSE, header=FALSE);							## 6 x 2
#features <- read.delim2("./UCI HAR Dataset/features.txt", sep=" ", row.names = NULL, col.names = c("Feature_ID", "Feature_Name"), stringsAsFactors=FALSE, header=FALSE);													## 561 x 2, we set stringsAsFactors=FALSE for having strings and not factors in second column
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("Activity_ID", "Activity_Name"), stringsAsFactors=FALSE, header=FALSE, comment.char="", quote="\"")
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("Feature_ID", "Feature_Name"), stringsAsFactors=FALSE, header=FALSE, comment.char="", quote="\"")

############################################################################################################
#### 1.	Merges the training and the test sets to create one data set.
############################################################################################################

#### 1.1. preparing data for 'test' :

#### 1.1.1. load data sets for 'test', put proper names on columns, create join keys for each data set
test <- read.table("./UCI HAR Dataset/test/X_test.txt", header=FALSE); 																		## 2947 x 561
	## check if "-4.8095837e-001" is printed correctly 
	##		> test[2947, 520]
	##		[1] -0.48095837
## add labels from "features.txt" to variable 'test'
names(test) <- paste("Feat_ID", features[, 1], sep="")
test <- cbind(Test_ID=seq_len(nrow(test)), test)
test <- cbind(data_type="test", test)
	
test_activity <- read.table("./UCI HAR Dataset/test/y_test.txt", col.names = c("Activity_ID"), header=FALSE);								## 2947 x 1
test_activity <- cbind(Test_ID=seq_len(nrow(test_activity)), test_activity)

test_subject_to_activity_asgn <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = c("Subject_ID"), header=FALSE);			## 2947 x 1
test_subject_to_activity_asgn <- cbind(Test_ID=seq_len(nrow(test_subject_to_activity_asgn)), test_subject_to_activity_asgn)

body_acc_x_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_x_test.txt", header=FALSE);		## 2947 x 128
colnames(body_acc_x_test) <- paste("bax", 1:128, sep="")
body_acc_x_test <- cbind(Test_ID=seq_len(nrow(body_acc_x_test)), body_acc_x_test)

body_acc_y_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_y_test.txt", header=FALSE);		## 2947 x 128
colnames(body_acc_y_test) <- paste("bay", 1:128, sep="")
body_acc_y_test <- cbind(Test_ID=seq_len(nrow(body_acc_y_test)), body_acc_y_test)

body_acc_z_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_acc_z_test.txt", header=FALSE);		## 2947 x 128
colnames(body_acc_z_test) <- paste("baz", 1:128, sep="")
body_acc_z_test <- cbind(Test_ID=seq_len(nrow(body_acc_z_test)), body_acc_z_test)

total_acc_x_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_x_test.txt", header=FALSE);	## 2947 x 128
colnames(total_acc_x_test) <- paste("tax", 1:128, sep="")
total_acc_x_test <- cbind(Test_ID=seq_len(nrow(total_acc_x_test)), total_acc_x_test)

total_acc_y_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_y_test.txt", header=FALSE);	## 2947 x 128
colnames(total_acc_y_test) <- paste("tay", 1:128, sep="")
total_acc_y_test <- cbind(Test_ID=seq_len(nrow(total_acc_y_test)), total_acc_y_test)

total_acc_z_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/total_acc_z_test.txt", header=FALSE);	## 2947 x 128
colnames(total_acc_z_test) <- paste("taz", 1:128, sep="")
total_acc_z_test <- cbind(Test_ID=seq_len(nrow(total_acc_z_test)), total_acc_z_test)

body_gyro_x_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_x_test.txt", header=FALSE);	## 2947 x 128
colnames(body_gyro_x_test) <- paste("bgx", 1:128, sep="")
body_gyro_x_test <- cbind(Test_ID=seq_len(nrow(body_gyro_x_test)), body_gyro_x_test)

body_gyro_y_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_y_test.txt", header=FALSE);	## 2947 x 128
colnames(body_gyro_y_test) <- paste("bgy", 1:128, sep="")
body_gyro_y_test <- cbind(Test_ID=seq_len(nrow(body_gyro_y_test)), body_gyro_y_test)

body_gyro_z_test <- read.table("./UCI HAR Dataset/test/Inertial Signals/body_gyro_z_test.txt", header=FALSE);	## 2947 x 128
colnames(body_gyro_z_test) <- paste("bgz", 1:128, sep="")
body_gyro_z_test <- cbind(Test_ID=seq_len(nrow(body_gyro_z_test)), body_gyro_z_test)

#### 1.2. preparing data for 'train' :

#### 1.2.1. load data sets for 'train', put proper names on columns, create join keys for each data set

train <- read.table("./UCI HAR Dataset/train/X_train.txt", header=FALSE); 																		## 7352 x 561

## add labels from "features.txt" to variable 'train'
start_with <- nrow(test)+1;
end_with <- nrow(test)+nrow(train);

names(train) <- paste("Feat_ID", features[, 1], sep="")
train <- cbind(Test_ID=seq(from=start_with, to=end_with), train)
train <- cbind(data_type="train", train)


train_activity <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = c("Activity_ID"), header=FALSE);								## 7352 x 1
train_activity <- cbind(Test_ID=seq(from=start_with, to=end_with), train_activity)

train_subject_to_activity_asgn <- read.table("./UCI HAR Dataset/train/subject_train.txt", col.names = c("Subject_ID"), header=FALSE);			## 7352 x 1
train_subject_to_activity_asgn <- cbind(Test_ID=seq(from=start_with, to=end_with), train_subject_to_activity_asgn)

body_acc_x_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_x_train.txt", header=FALSE);		## 7352 x 128
colnames(body_acc_x_train) <- paste("bax", 1:128, sep="")
body_acc_x_train <- cbind(Test_ID=seq(from=start_with, to=end_with), body_acc_x_train)

body_acc_y_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_y_train.txt", header=FALSE);		## 7352 x 128
colnames(body_acc_y_train) <- paste("bay", 1:128, sep="")
body_acc_y_train <- cbind(Test_ID=seq(from=start_with, to=end_with), body_acc_y_train)

body_acc_z_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_acc_z_train.txt", header=FALSE);		## 7352 x 128
colnames(body_acc_z_train) <- paste("baz", 1:128, sep="")
body_acc_z_train <- cbind(Test_ID=seq(from=start_with, to=end_with), body_acc_z_train)

total_acc_x_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_x_train.txt", header=FALSE);	## 7352 x 128
colnames(total_acc_x_train) <- paste("tax", 1:128, sep="")
total_acc_x_train <- cbind(Test_ID=seq(from=start_with, to=end_with), total_acc_x_train)

total_acc_y_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_y_train.txt", header=FALSE);	## 7352 x 128
colnames(total_acc_y_train) <- paste("tay", 1:128, sep="")
total_acc_y_train <- cbind(Test_ID=seq(from=start_with, to=end_with), total_acc_y_train)

total_acc_z_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/total_acc_z_train.txt", header=FALSE);	## 7352 x 128
colnames(total_acc_z_train) <- paste("taz", 1:128, sep="")
total_acc_z_train <- cbind(Test_ID=seq(from=start_with, to=end_with), total_acc_z_train)

body_gyro_x_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_x_train.txt", header=FALSE);	## 7352 x 128
colnames(body_gyro_x_train) <- paste("bgx", 1:128, sep="")
body_gyro_x_train <- cbind(Test_ID=seq(from=start_with, to=end_with), body_gyro_x_train)

body_gyro_y_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_y_train.txt", header=FALSE);	## 7352 x 128
colnames(body_gyro_y_train) <- paste("bgy", 1:128, sep="")
body_gyro_y_train <- cbind(Test_ID=seq(from=start_with, to=end_with), body_gyro_y_train)

body_gyro_z_train <- read.table("./UCI HAR Dataset/train/Inertial Signals/body_gyro_z_train.txt", header=FALSE);	## 7352 x 128
colnames(body_gyro_z_train) <- paste("bgz", 1:128, sep="")
body_gyro_z_train <- cbind(Test_ID=seq(from=start_with, to=end_with), body_gyro_z_train)



############################################################################################################
#### task 1.	Merges the training and the test sets to create one data set.
############################################################################################################
all_data = bind_rows(test, train);

############################################################################################################
#### task 2.	Extracts only the measurements on the mean and standard deviation for each measurement.
############################################################################################################
all_data_gathered = gather(all_data, features, values, -data_type, -Test_ID);
all_data_gathered$features = substr(all_data_gathered$features, 8, 100);		## keep the number corresponding to Feature_ID
all_data_gathered <- rename(all_data_gathered, Feature_ID=features);			## rename the column

featuresMeanStd <- filter(features, grepl('mean|std', Feature_Name));			## prepare filter and data type
featuresMeanStd$Feature_ID <- as.character(featuresMeanStd$Feature_ID);

all_data_gatheredMeanStd <- inner_join(all_data_gathered, featuresMeanStd, by=c("Feature_ID"));

############################################################################################################
#### task 3.	Uses descriptive activity names to name the activities in the data set
############################################################################################################
all_activities = bind_rows(test_activity, train_activity);

all_data_gathered <- join_all(list(all_data_gathered, all_activities), by='Test_ID', type='full');
all_data_gathered <- inner_join(all_data_gathered, activity_labels, by=c("Activity_ID"));

############################################################################################################
#### task 3.	Uses descriptive activity names to name the activities in the data set
############################################################################################################

############################################################################################################
#### 4.	Appropriately labels the data set with descriptive variable names.
############################################################################################################
done

############################################################################################################
#### task 5.	From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
############################################################################################################
all_subjects = bind_rows(test_subject_to_activity_asgn, train_subject_to_activity_asgn);

all_data_gathered <- inner_join(all_data_gathered, all_subjects, by=c("Test_ID"));

all_data_gathered_MEAN <- select(all_data_gathered, -data_type, -Test_ID);
all_data_gathered_MEAN <- summarize(group_by(all_data_gathered_MEAN, Feature_ID, Activity_ID, Subject_ID), mean(values));

############################################################################################################
#### Please upload the tidy data set created in step 5 of the instructions. Please upload your data set as a txt file created with write.table() using
#### row.name=FALSE (do not cut and paste a dataset directly into the text box, as this may cause errors saving your submission).
############################################################################################################
write.table(all_data_gathered_MEAN, "output.txt", sep="\t", row.name=FALSE);
