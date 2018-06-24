## Objective of this assignment is to create one R script called run_analysis.R that does the following.

## 01.Merges the training and the test sets to create one data set.
## 02.Extracts only the measurements on the mean and standard deviation for each measurement.
## 03. Uses descriptive activity names to name the activities in the data set
## 04. Appropriately labels the data set with descriptive variable names.
## 05. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Get column names
columnNames<-read.table("features.txt")

#Extract only mean and standard deviation measurements columns
columnMeanAndStd<-grep("mean|std", columnNames[,2])


#Get Subject files
subjectTest<-read.table("test/subject_test.txt")
subjectTrain<-read.table("train/subject_train.txt")
#Set Labels for Subject Datasets
names(subjectTest)<-c("subjectID")
names(subjectTrain)<-c("subjectID")

#Get X files
xTest<-read.table("test/X_test.txt")
xTrain<-read.table("train/X_train.txt")
#Get only columns with mean and standard deviation measurements
xTest<-xTest[,columnMeanAndStd]
xTrain<-xTrain[,columnMeanAndStd]
#Set labels for X datasets
names(xTest)<-columnNames[columnMeanAndStd,2]
names(xTrain)<-columnNames[columnMeanAndStd,2]


#Get Y files 
yTest<-read.table("test/y_test.txt")
yTrain<-read.table("train/y_train.txt")

#Get activity labels (for Y datasets)
activityLabels<-read.table("activity_labels.txt")

#Merge Y datasets (train and test) with activity labels
yTest<-merge(activityLabels, yTest)
yTrain<-merge(activityLabels, yTrain)

#Set labels for Y datasets
names(yTest)<-c("activityCode", "activityDescription")
names(yTrain)<-c("activityCode", "activityDescription")

#Create data frame from test data
testdf<-data.frame(subjectTest, yTest, xTest)
#Create data frame from train data
traindf<-data.frame(subjectTrain, yTrain, xTrain)

#Combine test and train data frame
dataset<-rbind(testdf, traindf)

#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#Split dataset by subject and acvitity
splitdatasets<-split(dataset, list(dataset$subjectID, dataset$activityCode), drop=TRUE)

#Calculate column means (only to certain columns) and transpose
colmeans<-data.frame(t(sapply(splitdatasets, function(x) colMeans(x[, 4:82], na.rm=TRUE))))

#Get row.names
subject.activity<-row.names(colmeans)
#Delete row.names column
row.names(colmeans)<-NULL

#Create new subject.activity column
colmeans<-cbind(subject.activity, colmeans)

#Save the two tidy datasets
write.csv(colmeans, file="tidy.csv")

