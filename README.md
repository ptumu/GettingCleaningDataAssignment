# Getting and Cleaning Data Assigment

This repo has been created for the final assignment submission of Getting and Cleaning Data on Coursera

The purpose of this project is to demonstrate ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. 

Here are the data for the project: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The data linked represents data collected from the accelerometers from the Samsung Galaxy S smartphone. 
A full description is available at the site where the data was obtained: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The R script called run_analysis.R does the following.

1) Merges the training and the test sets to create one data set.
2) Extracts only the measurements on the mean and standard deviation for each measurement.
3) Uses descriptive activity names to name the activities in the data set
4) Appropriately labels the data set with descriptive variable names.
5) From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Copy the R file into the R working directory. Download the data zip file and unzip the data file into the R working directory. 

When the R code is executed a file named "tidy_data_avg_for_activity_subject_grouping.txt" is created in the Samsung data folder that is under the R working directory. The code book for this tidy data set is CodeBook.md