library(dplyr)
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("c", "a"))
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("num","functions"))
sub_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "sub")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "c")
sub_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "sub")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "c")

X_data <- rbind(x_train, x_test)
Y_data <- rbind(y_train, y_test)
Sub_data <- rbind(sub_train, sub_test)
Merged_data <- cbind(Sub_data, Y_data, X_data)

tidy_data <- Merged_data %>% select(sub,c, contains("mean"), contains("std"))

tidy_data[,2]<-activities[tidy_data[,2],2]

names(tidy_data)[2] = "activity"
names(tidy_data)<-gsub("Acc", "Accelerometer", names(tidy_data))
names(tidy_data)<-gsub("Gyro", "Gyroscope", names(tidy_data))
names(tidy_data)<-gsub("BodyBody", "Body", names(tidy_data))
names(tidy_data)<-gsub("Mag", "Magnitude", names(tidy_data))
names(tidy_data)<-gsub("^t", "Time", names(tidy_data))
names(tidy_data)<-gsub("^f", "Frequency", names(tidy_data))
names(tidy_data)<-gsub("tBody", "TimeBody", names(tidy_data))
names(tidy_data)<-gsub("-mean()", "Mean", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-std()", "STD", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("-freq()", "Frequency", names(tidy_data), ignore.case = TRUE)
names(tidy_data)<-gsub("angle", "Angle", names(tidy_data))
names(tidy_data)<-gsub("gravity", "Gravity", names(tidy_data))

final_data <- tidy_data %>% group_by(sub, activity) %>% summarise_all(funs(mean))
