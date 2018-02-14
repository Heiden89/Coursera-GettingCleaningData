# DLE
# Date: 14-02-2018

#library setup
library(plyr)
library(tidyverse)

#file location
train_file <-  "C:/Users/David/OneDrive/Coursera/Getting and Cleaning Data/train/X_train.txt"
test_file <- "C:/Users/David/OneDrive/Coursera/Getting and Cleaning Data/test/X_test.txt"



# Import DataSet and Merge (Q1)
feature_name <- read.table("C:/Users/David/OneDrive/Coursera/Getting and Cleaning Data/features.txt",sep = "",header = FALSE,colClasses = character())
activity_labels <- read.table("C:/Users/David/OneDrive/Coursera/Getting and Cleaning Data/activity_labels.txt",sep = "",header = FALSE,colClasses = character())
names(activity_labels) <- c("Activityid","Activityname")

train_label <- read.table("C:/Users/David/OneDrive/Coursera/Getting and Cleaning Data/train/y_train.txt",sep = "",header = FALSE,colClasses = numeric())
train_set = read.table(train_file,sep = "",header = FALSE,colClasses = numeric())
train_set <- cbind(train_label,train_set)

test_label <- read.table("C:/Users/David/OneDrive/Coursera/Getting and Cleaning Data/test/y_test.txt",sep = "",header = FALSE,colClasses = numeric())
test_set <- read.table(test_file,sep = "",header = FALSE,colClasses = numeric())
test_set <- cbind(test_label,test_set)
# Create the merges

total_set <- rbind(train_set,test_set)
feature_name$V2 <- gsub("-mean",'Mean',feature_name$V2) 
feature_name$V2 <- gsub("-std",'Std',feature_name$V2)

names(total_set)[1] <- "Activityid"
names(total_set)[2:ncol(total_set)]<- as.character(feature_name$V2)

total_set <- merge(activity_labels,total_set, by="Activityid")
head(total_set[,1:10])



#Extract the measurement we need
columns_needed <-c(grep("Mean|Std",feature_name$V2,value=T),"Activityid","Activityname")

final_set <- total_set[,columns_needed]
head(final_set[,80:88])


#independant DS for the mean by group
indep_ds_mean <- aggregate(final_set,list(final_set$Activityname),mean)[1:ncol(final_set)-1]
write.table(indep_ds_mean, "mean_group.txt", sep="\t")

