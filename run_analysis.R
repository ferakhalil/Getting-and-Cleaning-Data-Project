#
# Getting and Cleaning Data Course Project
#
# Make sure environment variable for tokens exists in home directory

rm(list=ls())
# 
#  
library(pacman)

#check directory and create
getwd() 
setwd("D:/My Documents/Coursera/John Hopkins Specialization in Data Science/Getting and Cleaning Data/Course Project")
if ( !file.exists( "data" )) {
    dir.create ( "data" )
}
#_____________________________________________________________
#load libraries
#_____________________________________________________________
p_load(dplyr)

#check for date downloaded
dateDownloaded <- gsub(":",".",date())
dateDownloaded

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
fileLocation <- paste0("./data/GalaxyS-data ",dateDownloaded,".zip")
download.file(fileUrl, destfile =fileLocation, method="curl")

#  Get file names including path
fname <- unzip(fileLocation, list=TRUE)$Name

#unzip the files
unzip(fileLocation, files=fname, exdir="./data", overwrite=TRUE)

# path to extracted files
fpath <- file.path("./data", fname)

#------------------------------------------------------------------------------
# Get the pieces of data 
#------------------------------------------------------------------------------

# activity labels
activity <- read.table(fpath[1])
activity[,2] <- tolower(activity[,2])
activity[,2] <- gsub("_","", activity[,2])

# feature labels for dataset
ind2 <- grep("features.txt", fpath)
features <- read.table(fpath[ind2])

#  remove "-"
features[,2] <- gsub("-","",features[,2])

#  remove brackets
features[,2] <- gsub("\\(|\\)","",features[,2])

#------------------------------------------------------------------------------
# Get the pieces of data 
#------------------------------------------------------------------------------

# column for subject in train dataset
ind0 <- grep("subject_train", fpath)
subject_train <- read.table(fpath[ind0]) 

# assign label
names(subject_train) <- "subject"
subject_train[,1] <- as.factor(subject_train[,1])

# train dataset
ind4 <- grep("X_train", fpath)
train <- read.table(fpath[ind4]) #7342 x 561

# assign label
names(train) <- features[,2]

# want only mean and standard deviation columns
col_ind1 <- grep("[Mm]ean|std",names(train))
df_train <- train[,col_ind1]

# train activity
ind5 <- grep("/y_train", fpath)
activity_train <- read.table(fpath[ind5]) #7352 rows

# check for NA
sum(is.na(activity_train))

# change to factors
activity_train[,1] <- factor(activity_train[,1], levels=activity[,1], 
                             labels=activity[,2])

# assign label
names(activity_train) <- "activity"

# Combine all into data frame

df_train1 <- cbind(subject_train,activity_train,df_train)


#------------------------------------------------------------------------------
# test data set
#------------------------------------------------------------------------------

# column for subject in test dataset
ind1 <- grep("subject_test", fpath)
subject_test <- read.table(fpath[ind1])  

# assign label
names(subject_test) <- "subject"
subject_test[,1] <- as.factor(subject_test[,1])

# test dataset
ind3 <- grep("X_test", fpath)
test <- read.table(fpath[ind3])

# assign label
names(test) <- features[,2]

# want only mean and standard deviation columns
col_ind2 <- grep("[Mm]ean|std",names(test))
df_test <- test[,col_ind2]

# test activity
ind6 <- grep("/y_test", fpath)
activity_test <- read.table(fpath[ind6]) 

# check for NA
sum(is.na(activity_test))

# change to factors
activity_test[,1] <- factor(activity_test[,1], levels=activity[,1], 
                            labels=activity[,2])

# assign label
names(activity_test) <- "activity"


# Combine all into data frame
df_test1 <- cbind( subject_test, activity_test, df_test)

#------------------------------------------------------------------------------
# Combine into merged dataset
#------------------------------------------------------------------------------

df <- rbind(df_train1, df_test1)

#------------------------------------------------------------------------------
# Tidy data set for the average of each variable for each activity and each subject
#------------------------------------------------------------------------------

# add a new column which is a hybrid of subject and activity
df1 <- df %>% mutate(subjectActivity = as.factor(paste0(subject,activity)) ) 

# calculate the mean for each subject + activity combination
df2 <- aggregate(df1[3:88], list(df1$subjectActivity), FUN=mean)

#anonymous function to rename headers
comb_header <- function(x) {
    if (x=="Group.1") { "subjectActivity" }
    else{ paste0("average",x) }
}

# rename headers
header <- sapply(names(df2), FUN=comb_header ) 
names(df2) <- header

# Output file
write.table(df2, file="./data/tidySamsungGalaxyS.txt", row.names=F)

