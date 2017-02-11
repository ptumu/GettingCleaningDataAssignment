# The purpose of this project is to demonstrate ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis.

# Script does the following -
# 1) Merges the training and the test sets to create one data set.
# 2) Extracts only the measurements on the mean and standard deviation for each measurement.
# 3) Uses descriptive activity names to name the activities in the data set
# 4) Appropriately labels the data set with descriptive variable names.
# 5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#Step 1 : Merges the training and the test sets to create one data set.

# Merging the data sets is done by doing the following
# Step 1.1 - load all the files into data frames
# Step 1.2 - add the header rows for all data frames
# Step 1.3 - for both test and train data - combine the subject (subject_*.txt), activity (y_*.txt) and features (x_*.txt) data
# Step 1.4 - merge the data from test and train data sets into combined data set

library(dplyr)

# load all the data files from test and trainig data sets
featureNamesMap <-
  fread("./UCI HAR Dataset/features.txt", header = FALSE)
activityNamesMap <-
  fread("./UCI HAR Dataset/activity_labels.txt", header = FALSE)

testDataSetSubject <-
  fread("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
testDataSetActivity <-
  fread("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
testDataSetFeatures <-
  fread("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

trainDataSetSubject <-
  fread("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
trainDataSetActivity <-
  fread("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
trainDataSetFeatures <-
  fread("./UCI HAR Dataset/train/X_train.txt", header = FALSE)

#change headers for all tables to more meaningful names
subject <- "subject"
actCode <- "activity.code"
actName <- "activity.name"
setnames(
  testDataSetFeatures,
  old = names(testDataSetFeatures),
  new = tolower(featureNamesMap[["V2"]])
)
setnames(
  trainDataSetFeatures,
  old = names(trainDataSetFeatures),
  new = tolower(featureNamesMap[["V2"]])
)

setnames(testDataSetSubject,
         old = names(testDataSetSubject),
         new = c(subject))
setnames(
  trainDataSetSubject,
  old = names(trainDataSetSubject),
  new = c(subject)
)

setnames(
  testDataSetActivity,
  old = names(testDataSetActivity),
  new = c(actCode)
)
setnames(
  trainDataSetActivity,
  old = names(trainDataSetActivity),
  new = c(actCode)
)

setnames(
  activityNamesMap,
  old = names(activityNamesMap),
  new = c(actCode, actName)
)

#consolidate all values for test and train data sets
testDataSetAllAttributes <-
  cbind(testDataSetSubject, 
        testDataSetActivity, 
        testDataSetFeatures)

trainDataSetAllAttributes <-
  cbind(trainDataSetSubject,
        trainDataSetActivity,
        trainDataSetFeatures)

combinedDataSetAllAttributes <-
  rbind(testDataSetAllAttributes, trainDataSetAllAttributes)

#step 2 : Extracts only the measurements on the mean and standard deviation for each measurement.
meanSdCols <-
  c(subject, actCode, grep("mean\\()|std\\()", names(testDataSetAllAttributes), value = TRUE))

combinedDataMeanSdCols <-
  combinedDataSetAllAttributes[, meanSdCols, with = FALSE]

#step 3 : Uses descriptive activity names to name the activities in the data set
setkey(combinedDataMeanSdCols, "activity.code")
setkey(activityNamesMap, "activity.code")
combinedDataMeanSdActyName <-
  combinedDataMeanSdCols[activityNamesMap, nomatch = 0]
#table(combinedDataMeanSdActyName[,c("activity.code", "activity.name"), with=FALSE])

#step 4 : Appropriately labels the data set with descriptive variable names.
# the column names have already been set to descriptive names as part of step1
# cleaning up names of the features list to remove () and replace - with .
cleanColNamesV1 <-
  gsub("-", ".", names(combinedDataMeanSdActyName))
cleanColNamesV2 <- gsub("\\()", "", cleanColNamesV1)

setnames(
  combinedDataMeanSdActyName,
  old = names(combinedDataMeanSdActyName),
  new = cleanColNamesV2
)

#step 5 : From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidyDataWithAvgForActivitySubjectGrouping <-
  combinedDataMeanSdActyName %>%
  group_by(activity.name, subject) %>%
  summarise_each(funs(mean))

#prefixing columns with "grpavg." to indicate these are group average values
grpAvgCols <-
  c(grep("mean|std", names(tidyDataWithAvgForActivitySubjectGrouping), value = TRUE))
grpAvgColsNew <- paste("grpavg.", grpAvgCols, sep="")

setnames(
  tidyDataWithAvgForActivitySubjectGrouping,
  old = grpAvgCols,
  new = grpAvgColsNew
)

#write the file
write.table(tidyDataWithAvgForActivitySubjectGrouping, file="./UCI HAR Dataset/tidy_data_avg_for_activity_subject_grouping.txt", quote=FALSE, row.names=FALSE, col.names=TRUE)