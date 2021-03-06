# Project for Getting and Cleaning Data
#### Author : William Brojanigo

## README file

####Create a temp. file name
```{r}
temp<-tempfile(fileext=".zip")
```

####Use download.file() to fetch the file into the temp. file
```{r}
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
```

####Use unzip() to view the files nameand path contained in the archive 
```{r}
unzip(temp, list=T)
```
* UCI HAR Dataset/activity_labels.txt
* UCI HAR Dataset/features.txt
* UCI HAR Dataset/train/X_train.txt
* UCI HAR Dataset/train/y_train.txt
* UCI HAR Dataset/train/subject_train.txt
* UCI HAR Dataset/test/X_test.txt
* UCI HAR Dataset/test/y_test.txt
* UCI HAR Dataset/test/subject_test.txt

####Read and convert the data
```{r}
features<-read.table(unz(temp, "UCI HAR Dataset/features.txt"), header=F)
features<-as.character(features[,2])
activityLabels<-read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"), header=F)
activityLabels<-as.character(activityLabels[,2])
dataTrainX<-read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"), header=F)
dataTrainY<-read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"), header=F)
dataTrainSubject<-read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"), header=F)
dataTestX<-read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"), header=F)
dataTestY<-read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"), header=F)
dataTestSubject<-read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"), header=F)
```

####Remove the temp file via unlink()
```{r}
unlink(temp)
```

####Look at the properties of the above varibles
```{r}
str(features)
str(activityLabels)
str(dataTrainX)
str(dataTrainY)
str(dataTrainSubject)
str(dataTestX)
str(dataTestY)
str(dataTestSubject)
```

####Combine X_train, y_train and subject_train and X_test, y_test and subject_test in two data frames
```{r}
dataTrain<-data.frame(dataTrainSubject, dataTrainY, dataTrainX)
dataTest<-data.frame(dataTestSubject, dataTestY, dataTestX)
```

####Rename the colname of new data frame
```{r}
names(dataTrain)<-c(c('subject', 'activity'), features)
names(dataTest)<-c(c('subject', 'activity'), features)
```

##1.Merges the training and the test sets to create one data set.
```{r}
data<-rbind(dataTrain, dataTest)
```

##2. Extracts only the measurements on the mean and standard deviation for each measurement.
```{r}
dataExtr<-data[,which(colnames(data) %in% c("subject", "activity", grep("mean\\(\\)|std\\(\\)", colnames(data), value=TRUE)))]
```
####Check the structures of the data frame dataExtr
```{r}
str(dataExtr)
```

##3. Uses descriptive activity names to name the activities in the data set.
```{r}
dataExtr$activity<-activityLabels[dataExtr$activity]
```
####Check
```{r}
head(dataExtr$activity,50)
```

##4. Appropriately labels the data set with descriptive variable names.
####Here are the names of the variables in dataExtr
```{r}
names(dataExtr)
```
####Looking for the parts of labels we need to change
```{r}
unique(gsub("\\-(mean|std)\\(\\).*", "", names(dataExtr)[-c(1:2)]))
```
####Names of Feteatures will labelled using descriptive variable names.
* prefix t is replaced by time
* Acc is replaced by Accelerometer
* Gyro is replaced by Gyroscope
* prefix f is replaced by frequency
* Mag is replaced by Magnitude
* BodyBody is replaced by Body
```{r}
names(dataExtr)[-c(1:2)]<-gsub("^t", "time", names(dataExtr)[-c(1:2)])
names(dataExtr)[-c(1:2)]<-gsub("^f", "frequency", names(dataExtr)[-c(1:2)])
names(dataExtr)[-c(1:2)]<-gsub("Acc", "Accelerometer", names(dataExtr)[-c(1:2)])
names(dataExtr)[-c(1:2)]<-gsub("Gyro", "Gyroscope", names(dataExtr)[-c(1:2)])
names(dataExtr)[-c(1:2)]<-gsub("Mag", "Magnitude", names(dataExtr)[-c(1:2)])
names(dataExtr)[-c(1:2)]<-gsub("BodyBody", "Body", names(dataExtr)[-c(1:2)])
```
####Check
```{r}
names(dataExtr)
str(dataExtr)
```

##5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
```{r}
tidyData<-aggregate(. ~ subject + activity, dataExtr, mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]
```
####Write to text file on disk
```{r}
write.table(tidyData, file = "tidyData.txt",row.name=FALSE)
```
