#Assignment for Getting and Cleaning Data

setwd("C:/Users/Jenny/Documents/Coursera/Course3/UCI HAR Dataset/test")
setwd("C:/Users/Jenny/Documents/Coursera/Course3/UCI HAR Dataset")
setwd("C:/Users/Jenny/Documents/Coursera/Course3/UCI HAR Dataset/train")

library(tidyr)
library(dplyr)

#read in test and train data

#read in X_test data
test_X<-read.table("C:/Users/Jenny/Documents/Coursera/Course3/UCI HAR Dataset/test/X_test.txt", header=FALSE)
#read in X_train data
train_X<-read.table("C:/Users/Jenny/Documents/Coursera/Course3/UCI HAR Dataset/train/X_train.txt", header=FALSE)

#read in variable names
colnames<-read.table("C:/Users/Jenny/Documents/Coursera/Course3/UCI HAR Dataset/features.txt", header = FALSE)
#read in activity labels
train_labels<-read.table("C:/Users/Jenny/Documents/Coursera/Course3/UCI HAR Dataset/train/y_train.txt", header=FALSE)
test_labels<-read.table("C:/Users/Jenny/Documents/Coursera/Course3/UCI HAR Dataset/test/y_test.txt", header=FALSE)
dat_labels<-bind_rows(test_labels, train_labels)

#read in subject labels
sub_labels_train<-read.table("C:/Users/Jenny/Documents/Coursera/Course3/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
sub_labels_test<-read.table("C:/Users/Jenny/Documents/Coursera/Course3/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
sub_labels<-rbind(sub_labels_test,sub_labels_train)

#renaming activies to make sense
dat_labels[dat_labels==1]<-"walking"
dat_labels[dat_labels==2]<-"walking upstairs"
dat_labels[dat_labels==3]<-"walking downstairs"
dat_labels[dat_labels==4]<-"sitting"
dat_labels[dat_labels==5]<-"standing"
dat_labels[dat_labels==6]<-"laying down"


#label the test and trail data with the variable names.  Need to make each col name unique because some are duplicates.
colname_vector<-as.vector(colnames$V2)
colname_vector<-make.names(colname_vector, unique = TRUE, allow_ = TRUE)
colnames(test_X)<-colname_vector
colnames(train_X)<-colname_vector

#combine test and train datasets
dat_bind<-bind_rows(test_X,train_X)


#select only columns of mean or standard deviation
test2<-dat_bind[,grep("std()|mean()",colnames(dat_bind))]

#col bind dat_labels with dat_bind
dat_with_activity<-cbind(dat_labels,test2)
#colbind sub_labels with dat_with_activity
final_dat<-cbind(sub_labels,dat_with_activity)

#fixing variable names
dat_with_activity<-rename(dat_with_activity,activity=V1) #renames V1
names(dat_with_activity)<-tolower(names(dat_with_activity)) #makes all lowercase
final_dat<-rename(final_dat,subject=V1)

#rename dataset to tidydata for question 4
tidydataQ4<-dat_with_activity

#question 5 creates a second, independent tidy data set with the average 
#of each variable for each activity and each subject.

groups<-group_by(final_dat,activity,subject)
group_means<-summarize_all(groups,mean)
