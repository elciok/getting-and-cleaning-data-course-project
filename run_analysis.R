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

# compute mean of every measurement by activity and subject
dataMeans <- data %>% 
  select(-activity_id) %>% # remove activity id
  group_by(activity_label, subject) %>% #group by activity and subject
  summarize_each(funs(mean)) # compute mean for each column

# rename columns to append meanOf to measurements column names
columns <- colnames(dataMeans)
for (i in seq_along(columns)){
  if (!columns[i] %in% c("activity_label", "subject")){
    columns[i] <- paste("meanOf", columns[i], sep=".")
  }
}
colnames(dataMeans) <- columns

# writes resulting file
write.table(dataMeans, "./result.txt")