## Step 1
## Read data.
test.subject <- read.table("test/subject_test.txt", col.names="subject")
test.labels <- read.table("test/y_test.txt", col.names="label")
test.dataset <- read.table("test/X_test.txt")
train.subject <- read.table("train/subject_train.txt", col.names="subject") 
train.labels <- read.table("train/y_train.txt", col.names="label") 
train.dataset <- read.table("train/X_train.txt") 

## Training and test datasets are merged to create one data set
mergedData <- rbind(cbind(test.subject, test.labels, test.dataset), 
              cbind(train.subject, train.labels, train.dataset)) 

## Step 2
## Read features file
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)
## Retain only the features of mean and standard deviation
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

## Extracts only the measurements on the mean and standard deviation for each measurement
## increment by 2 because mergedData has subjects and labels columns in the beginning 
mergedData.mean.std <- mergedData[, c(1, 2, features.mean.std$V1+2)]

## Step 3
## Read activity labels
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
##Rreplace labels in mergedData with label names
mergedData.mean.std$label <- labels[mergedData.mean.std$label, 2]

## Step 4
## Make a list of the current column names and feature names
good.colnames <- c("subject", "label", features.mean.std$V2)
# Tidy the list by removing every non-alphabetic character and converting to lowercase 
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))
# then use the list as column names for data 
colnames(mergedData.mean.std) <- good.colnames

## Step 5
# Find the mean for each combination of subject and label in mergedData
aggr.data <- aggregate(mergedData.mean.std[, 3:ncol(mergedData.mean.std)], 
                       by=list(subject = mergedData.mean.std$subject,  
                       label = mergedData.mean.std$label), mean) 

## Write the data for course upload
write.table(format(aggr.data, scientific=T), "tidyAverage.txt", 
                   row.names=F, col.names=F, quote=2) 

