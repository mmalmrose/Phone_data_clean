#script to download and clean some accelerometer data from smartphones.  

#Check to see if the file exist in the current directory, if not, get them
#and unzip
filename <- 'phonedata.zip'
if (!file.exists(filename)) {
    address <-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    download.file(address, filename, method="wget")
    unzip(filename)
    }
# Now that the data exist, read in the training and and test data
#training data. Use read.table instead of read.csv to avoid a names
#mismatch error when combining
train_data <-    read.table("UCI HAR Dataset/train/X_train.txt", sep='')
train_subject <- read.table("UCI HAR Dataset/train/subject_train.txt", sep='')
train_active <-  read.table("UCI HAR Dataset/train/y_train.txt", sep='')
#test data
test_data <-     read.table("UCI HAR Dataset/test/X_test.txt", sep='')
test_subject <-  read.table("UCI HAR Dataset/test/subject_test.txt", sep='')
test_active <-   read.table("UCI HAR Dataset/test/y_test.txt", sep='')

# Read in the activity lables and the features
active_labels <- read.table("UCI HAR Dataset/activity_labels.txt", sep='')
feature_labels <- read.table("UCI HAR Dataset/features.txt", sep='')


#Start combining data frames
testcombo<- cbind(test_subject,  test_data, test_active)
traincombo <- cbind(train_subject, train_data, train_active)
alldata <- rbind(testcombo, traincombo)


#Have a data table that has combined the training and test set
#Now determine which values to extract.
datfeatures <- read.table("UCI HAR Dataset/features.txt", sep='')
colnames(alldata) <- c('subject', as.character(datfeatures[,2]), 'activity')
subsetcols <- grepl('subject|mean|std|activity', colnames(alldata),
    ignore.case=TRUE)
subset_data <- subset(alldata, select=(subsetcols==TRUE))

#Aggregate the data by average of each variable and activity for each test subject
agg_data <- aggregate(subset_data, 
by = list(subset_data[, 'subject'], subset_data[,'activity']),
FUN=mean)

# Now have the subset of data that we are interested in, Now replace the 
# number in the activities column with the activity name using the factor function.
subset_data[, 'activity'] <- factor(subset_data[, 'activity'], 
levels= active_labels[,1], labels = active_labels[,2])
agg_data[, 'activity'] <- factor(agg_data[, 'activity'], 
levels= active_labels[,1], labels = active_labels[,2])
agg_data['Group.1'] = NULL
agg_data['Group.2'] = NULL

#Save agg_data to a text file
write.csv(agg_data, file='tidy.csv')
