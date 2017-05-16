

library(rstudioapi)
library(data.table)
library(dplyr)

# Read data train set
subject_train=fread("/Users/armingau/UCI HAR Dataset/train/subject_train.txt")
X_train=fread("/Users/armingau/UCI HAR Dataset/train/X_train.txt")
y_train=fread("/Users/armingau/UCI HAR Dataset/train/y_train.txt")

# Read data test set
subject_test=fread("/Users/armingau/UCI HAR Dataset/test/subject_test.txt")
X_test=fread("/Users/armingau/UCI HAR Dataset/test/X_test.txt")
y_test=fread("/Users/armingau/UCI HAR Dataset/test/y_test.txt")

# combine sets
X_dataset<-tbl_df(rbind(X_train,X_test))
y_dataset<-tbl_df(rbind(y_train,y_test))
subjectDataSet<-tbl_df(rbind(subject_train, subject_test))
names(subjectDataSet)<-"Subject"

# Get variables means or std
X_datasetstd <- X_dataset[, grep("-(mean|std)\\(\\)", read.table("/Users/armingau/UCI HAR Dataset/features.txt")[, 2])]
names(X_datasetstd) <- read.table("/Users/armingau/UCI HAR Dataset/features.txt")[grep("-(mean|std)\\(\\)", read.table("/Users/armingau/UCI HAR Dataset/features.txt")[, 2]), 2]

# Translate Activity Labels for Y_dataset: xxxxx
actlab<-read.table("/Users/armingau/UCI HAR Dataset/activity_labels.txt")
y_dataset<-select(left_join(y_dataset,actlab, by="V1"),V2)
names(y_dataset) <- "Activity"

# Ok, combine dataset and make name
Data<- cbind(subjectDataSet, X_datasetstd, y_dataset)

# Appropriately labels data set with descriptive variable names
names(Data) <- gsub('Acc',"Acceleration",names(Data))
names(Data) <- gsub('GyroJerk',"AngularAcceleration",names(Data))
names(Data) <- gsub('Gyro',"AngularSpeed",names(Data))
names(Data) <- gsub('Mag',"Magnitude",names(Data))
names(Data) <- gsub('^t',"Time",names(Data))
names(Data) <- gsub('^f',"Frequency",names(Data))
names(Data) <- gsub('\\.mean',".Mean",names(Data))
names(Data) <- gsub('\\.std',".Std",names(Data))
names(Data) <- gsub('Freq\\.',"Frequency",names(Data))
names(Data) <- gsub('Freq$',"Frequency",names(Data))
write.table(Data, "Data.txt")

# Creates a second,independent tidy data
Data2 <-group_by(Data , Subject, Activity)
tidyData <- summarise_each(Data2, funs(mean))
write.table(tidyData, "tidyData.txt", row.name=FALSE)


