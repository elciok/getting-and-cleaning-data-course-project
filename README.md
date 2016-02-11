
The script run_analysis.R uses as input, data collected from the accelerometers from the Samsung Galaxy S smartphone, documented in this page: [Human Activity Recognition Using Smartphones Data Set](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones). The script computes and creates a new data set with averages for averages and standard deviations of measurements from the original data.

Before running the script
--------------------------

You need to install the dplyr package before running code from run_analysis.R. Your workspace directory should be set to the root of this project where you can find run_analysis.R.

Steps performed by the script
------------------------------

When it starts, the script creates a folder "data" in your workspace, downloads and unzips the source data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip.

Then it reads activity labels and feature names from activity_labels.txt and features.txt, both file contained in the original zip file. Tha activity labels are going to be used to set meaningful names for activities in the resulting data and the feature names are useful to set names for every column in the source measurements data. I replaced all hyphens and parenthesis with dots to make it easier to read but still keep it possible to know which column from the original dataset it is refering to.

The measurements, subjects and activities files from training and testing sets are merged into the same data frame. Data from training and testing folders are combined by rows. Subjects, activities and measurements are combined by columns. Subjects data are read as factors because this column is used to group data.

Only columns with name containing "mean" or "std" were kept from the measurements data, because we are only interested in computing means for measurements means and standard deviations. This rule using column names was checked by looking at the list of feature names.

Activity labels are combined with this data frame by joining the activity label data with the "activity_id" column created from the activities files. This gives us descriptive activity names.

We create a new dataset computing averages for each measurement grouped by activity and subject. This operation keeps data in a wide format, with a column for each measurement column in the intermediate dataset. This way, each line is a record for averages of means and standard deviations for measurements from a pair of activity and subject. This is the data set we save to a file named result.txt.

Resulting dataset
------------------

The script creates a data file named result.txt in your worskpace directory. All columns in the data file created are described in CodeBook.md, which can be found in this repository.

You can view the data using the following code:

	result <- read.table("./result.txt", header = TRUE) 
	View(result)