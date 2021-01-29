# Getting-and-Cleaning-Data-Project
Course project for John Hopkins University course, Getting and Cleaning Data

The purpose of this project is to tidy the dataset from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip to make it easier for analysis which includes merging the different data sets into one, and providing the mean and standard deviation for specific physical activity. The data was collected from a Smartphone device ie  Samsung Galaxy S II which has an embedded accelerometer and gyroscope that could determine the physical activity perform by the user. 

For more info you could refer to: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

##This repo contains the following:
1. An R script called run_analysis.R - this is what you need to run, further details provided below.
2. A code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
3. This README file
4. The output of the script in (1) called tidySamsungGalaxyS.txt

##How to use the R script:
1. Run source("run_analysis.R") on Rstudio then it will generate a new file tidySamsungGalaxyS.txt in your working directory.

##What does the R script do:
1. Download the dataset
2. Extract the mean and standard deviation
3. Merge all the relevant data into a data frame
4. Calculates the average of each variable for each activity and each subject.
5. Results will then be avaialble in tidySamsungGalaxyS.txt

Please review the file Codebook.md for further explanation of the variables.
