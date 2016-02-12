library(dplyr)

# Downloads zip file if it is not in data folder and extracts data 
if (!file.exists("./data")) {dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
if (!file.exists("./data/hardataset.zip")) { download.file(fileUrl, destfile="./data/hardataset.zip") }
unzip("./data/hardataset.zip", exdir="./data")

# read activity and feature names
activity_labels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", header = FALSE, col.names = c("activity_id", "activity_label"))
features <- read.table("./data/UCI HAR Dataset/features.txt", header = FALSE, col.names = c("feature_id", "feature_name")) %>%
  mutate(feature_name = gsub("[-\\(\\)]+", ".", feature_name)) %>% #replace hyphens and parenthesis with dots
  mutate(feature_name = gsub("\\.+$", "", feature_name)) # supress dots at the end of the name

# merge train and test data
test_data <- read.table("./data/UCI HAR Dataset/test/X_test.txt", header = FALSE, col.names = features$feature_name)
train_data <- read.table("./data/UCI HAR Dataset/train/X_train.txt", header = FALSE, col.names = features$feature_name)
data <- rbind(test_data, train_data)

# merge train and test subject data
test_subjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", header = FALSE, col.names = c("subject"), colClasses=c("factor"))
train_subjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", header = FALSE, col.names = c("subject"), colClasses=c("factor"))
subjects <- rbind(test_subjects, train_subjects)

# merge train and test activity data
test_activities <- read.table("./data/UCI HAR Dataset/test/y_test.txt", header = FALSE, col.names = c("activity_id"))
train_activities <- read.table("./data/UCI HAR Dataset/train/y_train.txt", header = FALSE, col.names = c("activity_id"))
activities <- rbind(test_activities, train_activities)

# get only the measurements on the mean and standard deviation for each measurement
data <- select(data, grep("(std|mean)", features$feature_name))

# merge with activities and subjects data
data <- cbind(data, activities, subjects)
data <- inner_join(data, activity_labels, by = "activity_id")

# rename columns to descriptive names
data <- rename(data, mean_of_body_acceleration_on_x = tBodyAcc.mean.X,
               mean_of_body_acceleration_on_y = tBodyAcc.mean.Y,
               mean_of_body_acceleration_on_z = tBodyAcc.mean.Z,
               standard_deviation_of_body_acceleration_on_x = tBodyAcc.std.X,
               standard_deviation_of_body_acceleration_on_y = tBodyAcc.std.Y,
               standard_deviation_of_body_acceleration_on_z = tBodyAcc.std.Z,
               mean_of_gravity_acceleration_on_x = tGravityAcc.mean.X,
               mean_of_gravity_acceleration_on_y = tGravityAcc.mean.Y,
               mean_of_gravity_acceleration_on_z = tGravityAcc.mean.Z,
               standard_deviation_of_gravity_acceleration_on_x = tGravityAcc.std.X,
               standard_deviation_of_gravity_acceleration_on_y = tGravityAcc.std.Y,
               standard_deviation_of_gravity_acceleration_on_z = tGravityAcc.std.Z,
               mean_of_jerk_body_acceleration_on_x = tBodyAccJerk.mean.X,
               mean_of_jerk_body_acceleration_on_y = tBodyAccJerk.mean.Y,
               mean_of_jerk_body_acceleration_on_z = tBodyAccJerk.mean.Z,
               standard_deviation_of_jerk_body_acceleration_on_x = tBodyAccJerk.std.X,
               standard_deviation_of_jerk_body_acceleration_on_y = tBodyAccJerk.std.Y,
               standard_deviation_of_jerk_body_acceleration_on_z = tBodyAccJerk.std.Z,
               mean_of_angular_velocity_on_x = tBodyGyro.mean.X,
               mean_of_angular_velocity_on_y = tBodyGyro.mean.Y,
               mean_of_angular_velocity_on_z = tBodyGyro.mean.Z,
               standard_deviation_of_angular_velocity_on_x = tBodyGyro.std.X,
               standard_deviation_of_angular_velocity_on_y = tBodyGyro.std.Y,
               standard_deviation_of_angular_velocity_on_z = tBodyGyro.std.Z,
               mean_of_jerk_angular_velocity_on_x = tBodyGyroJerk.mean.X,
               mean_of_jerk_angular_velocity_on_y = tBodyGyroJerk.mean.Y,
               mean_of_jerk_angular_velocity_on_z = tBodyGyroJerk.mean.Z,
               standard_deviation_of_jerk_angular_velocity_on_x = tBodyGyroJerk.std.X,
               standard_deviation_of_jerk_angular_velocity_on_y = tBodyGyroJerk.std.Y,
               standard_deviation_of_jerk_angular_velocity_on_z = tBodyGyroJerk.std.Z,
               mean_of_magnitude_body_acceleration = tBodyAccMag.mean,
               standard_deviation_of_magnitude_body_acceleration = tBodyAccMag.std,
               mean_of_magnitude_gravity_acceleration = tGravityAccMag.mean,
               standard_deviation_of_magnitude_gravity_acceleration = tGravityAccMag.std,
               mean_of_magnitude_jerk_body_acceleration = tBodyAccJerkMag.mean,
               standard_deviation_of_magnitude_jerk_body_acceleration = tBodyAccJerkMag.std,
               mean_of_magnitude_angular_velocity = tBodyGyroMag.mean,
               standard_deviation_of_magnitude_angular_velocity = tBodyGyroMag.std,
               mean_of_magnitude_jerk_angular_velocity = tBodyGyroJerkMag.mean,
               standard_deviation_of_magnitude_jerk_angular_velocity = tBodyGyroJerkMag.std,
               mean_on_frequency_domain_of_body_acceleration_on_x = fBodyAcc.mean.X,
               mean_on_frequency_domain_of_body_acceleration_on_y = fBodyAcc.mean.Y,
               mean_on_frequency_domain_of_body_acceleration_on_z = fBodyAcc.mean.Z,
               standard_deviation_on_frequency_domain_of_body_acceleration_on_x = fBodyAcc.std.X,
               standard_deviation_on_frequency_domain_of_body_acceleration_on_y = fBodyAcc.std.Y,
               standard_deviation_on_frequency_domain_of_body_acceleration_on_z = fBodyAcc.std.Z,
               weighted_average_frequency_body_acceleration_on_x = fBodyAcc.meanFreq.X,
               weighted_average_frequency_body_acceleration_on_y = fBodyAcc.meanFreq.Y,
               weighted_average_frequency_body_acceleration_on_z = fBodyAcc.meanFreq.Z,
               mean_on_frequency_domain_of_jerk_body_acceleration_on_x = fBodyAccJerk.mean.X,
               mean_on_frequency_domain_of_jerk_body_acceleration_on_y = fBodyAccJerk.mean.Y,
               mean_on_frequency_domain_of_jerk_body_acceleration_on_z = fBodyAccJerk.mean.Z,
               standard_deviation_on_frequency_domain_of_jerk_body_acceleration_on_x = fBodyAccJerk.std.X,
               standard_deviation_on_frequency_domain_of_jerk_body_acceleration_on_y = fBodyAccJerk.std.Y,
               standard_deviation_on_frequency_domain_of_jerk_body_acceleration_on_z = fBodyAccJerk.std.Z,
               weighted_average_frequency_jerk_body_acceleration_on_x = fBodyAccJerk.meanFreq.X,
               weighted_average_frequency_jerk_body_acceleration_on_y = fBodyAccJerk.meanFreq.Y,
               weighted_average_frequency_jerk_body_acceleration_on_z = fBodyAccJerk.meanFreq.Z,
               mean_on_frequency_domain_of_angular_velocity_on_x = fBodyGyro.mean.X,
               mean_on_frequency_domain_of_angular_velocity_on_y = fBodyGyro.mean.Y,
               mean_on_frequency_domain_of_angular_velocity_on_z = fBodyGyro.mean.Z,
               standard_deviation_on_frequency_domain_of_angular_velocity_on_x = fBodyGyro.std.X,
               standard_deviation_on_frequency_domain_of_angular_velocity_on_y = fBodyGyro.std.Y,
               standard_deviation_on_frequency_domain_of_angular_velocity_on_z = fBodyGyro.std.Z,
               weighted_average_frequency_angular_velocity_on_x = fBodyGyro.meanFreq.X,
               weighted_average_frequency_angular_velocity_on_y = fBodyGyro.meanFreq.Y,
               weighted_average_frequency_angular_velocity_on_z = fBodyGyro.meanFreq.Z,
               mean_on_frequency_domain_of_magnitude_body_acceleration = fBodyAccMag.mean,
               standard_deviation_on_frequency_domain_of_magnitude_body_acceleration = fBodyAccMag.std,
               weighted_average_frequency_of_magnitude_body_acceleration = fBodyAccMag.meanFreq,
               mean_on_frequency_domain_of_jerk_body_acceleration = fBodyBodyAccJerkMag.mean,
               standard_deviation_on_frequency_domain_of_jerk_body_acceleration = fBodyBodyAccJerkMag.std,
               weighted_average_frequency_of_jerk_body_acceleration = fBodyBodyAccJerkMag.meanFreq,
               mean_on_frequency_domain_of_magnitude_angular_velocity = fBodyBodyGyroMag.mean,
               standard_deviation_on_frequency_domain_of_magnitude_angular_velocity = fBodyBodyGyroMag.std,
               weighted_average_frequency_of_magnitude_angular_velocity = fBodyBodyGyroMag.meanFreq,
               mean_on_frequency_domain_of_magnitude_jerk_angular_velocity = fBodyBodyGyroJerkMag.mean,
               standard_deviation_on_frequency_domain_of_magnitude_jerk_angular_velocity = fBodyBodyGyroJerkMag.std,
               weighted_average_frequency_of_magnitude_jerk_angular_velocity = fBodyBodyGyroJerkMag.meanFreq
               )

# compute mean of every measurement by activity and subject
dataMeans <- data %>% 
  select(-activity_id) %>% # remove activity id
  group_by(activity_label, subject) %>% #group by activity and subject
  summarize_each(funs(mean)) # compute mean for each column

# writes resulting file
write.table(dataMeans, "./result.txt", row.name=FALSE)