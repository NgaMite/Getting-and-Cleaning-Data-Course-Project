### Library
library(dplyr)

### Assigning DataFrames
features <- read.table("./UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("./UCI HAR Dataset/activity_labels.txt", col.names = c("n","activity"))
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("./UCI HAR Dataset/test/x_test.txt",col.names = features$functions)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",col.names = "code")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",col.names = "subject")
x_train <- read.table("./UCI HAR Dataset/train/x_train.txt", col.names = features$functions)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", col.names = "code")

###1. Merging Data
X <- rbind(x_train,x_test)
Y <- rbind(y_train,y_test)
Subject <- rbind(subject_train,subject_test)
Merged_Data <- cbind(Subject,X,Y)

###2. Select mean and standard deviations
Tidy_Data <- select(Merged_Data,subject,code,contains("mean"),contains("std"))

###3. Uses descriptive activity names to name the activities in the data set
Tidy_Data$code <- activities[Tidy_Data$code, 2]

###4. Using descriptive names
names(Tidy_Data)[2] = "activity"
names(Tidy_Data)<-gsub("Acc", "Accelerometer", names(Tidy_Data))
names(Tidy_Data)<-gsub("Gyro", "Gyroscope", names(Tidy_Data))
names(Tidy_Data)<-gsub("BodyBody", "Body", names(Tidy_Data))
names(Tidy_Data)<-gsub("Mag", "Magnitude", names(Tidy_Data))
names(Tidy_Data)<-gsub("^t", "Time", names(Tidy_Data))
names(Tidy_Data)<-gsub("^f", "Frequency", names(Tidy_Data))
names(Tidy_Data)<-gsub("tBody", "TimeBody", names(Tidy_Data))
names(Tidy_Data)<-gsub("-mean()", "Mean", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-std()", "STD", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("-freq()", "Frequency", names(Tidy_Data), ignore.case = TRUE)
names(Tidy_Data)<-gsub("angle", "Angle", names(Tidy_Data))
names(Tidy_Data)<-gsub("gravity", "Gravity", names(Tidy_Data))

### From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

FinalData <- Tidy_Data %>%
  group_by(subject,activity) %>%
  summarise_all(funs(mean))
write.table(FinalData,"Final Data.txt", row.names = FALSE)
            