## Procedure for generating the file

* Download and unzip https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
if it does not currently exist in the current working directory.
* Using the read.table() function read the training and test data as well as 
the appropriate identifying labels into separate tables
* combine into a single table
* Using the subset() and grepl() functions, extract a new data table containing
only the mean and standard deviation of the measurements
* Using the aggregate() function, get the average of each of the measurements
    for each of the 6 activities for each subject
* Using write.csv(), save the output to 'tidy.csv'
