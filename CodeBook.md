# Project for Getting and Cleaning Data
#### Author : William Brojanigo

## Code Book file

#####One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

#####Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Description of the original data
The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. and the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) - both using a low pass Butterworth filter.

The body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag).

A Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).

#### Description of abbreviations of measurements

* leading t or f is based on time or frequency measurements.
* Body = related to body movement.
* Gravity = acceleration of gravity
* Acc = accelerometer measurement
* Gyro = gyroscopic measurements
* Jerk = sudden movement acceleration
* Mag = magnitude of movement
* mean and SD are calculated for each subject for each activity for each mean and SD measurements.

The units given are g's for the accelerometer and rad/sec for the gyro and g/sec and rad/sec/sec for the corresponding jerks.

These signals were used to estimate variables of the feature vector for each pattern:
'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions. They total 33 measurements including the 3 dimensions - the X,Y, and Z axes.

* tBodyAcc-XYZ
* tGravityAcc-XYZ
* tBodyAccJerk-XYZ
* tBodyGyro-XYZ
* tBodyGyroJerk-XYZ
* tBodyAccMag
* tGravityAccMag
* tBodyAccJerkMag
* tBodyGyroMag
* tBodyGyroJerkMag
* fBodyAcc-XYZ
* fBodyAccJerk-XYZ
* fBodyGyro-XYZ
* fBodyAccMag
* fBodyAccJerkMag
* fBodyGyroMag
* fBodyGyroJerkMag

The set of variables that were estimated from these signals are:

* mean(): Mean value
* std(): Standard deviation

### Data Set Information:

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

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


### Description of the "tidyData" dataset

##### The "tidyData" dataset includes the average of each variable for each activity and each subject. 10299 instances are split into 180 groups (30 subjects and 6 activities) and 66 mean and standard deviation features are averaged for each group. The resulting data table has 180 rows and 68 columns - 33 Mean variables + 33 Standard deviation variables + 1 Subject( 1 of of the 30 test subjects) + ActivityName. The tidy data set's first row is the header containing the names for each column.

##### Thanks to str() function we can list and describe all the variables of our "tidyData" dataset 

```{r}
str(tidyData)
```

```{r}
#'data.frame':   180 obs. of  68 variables:
# $ subject                                       : int  1 1 1 1 1 1 2 2 2 2 ...
# $ activity                                      : chr  "LAYING" "SITTING" "STANDING" "WALKING" ...
# $ timeBodyAccelerometer-mean()-X                : num  0.222 0.261 0.279 0.277 0.289 ...
# $ timeBodyAccelerometer-mean()-Y                : num  -0.04051 -0.00131 -0.01614 -0.01738 -0.00992 ...
# $ timeBodyAccelerometer-mean()-Z                : num  -0.113 -0.105 -0.111 -0.111 -0.108 ...
# $ timeBodyAccelerometer-std()-X                 : num  -0.928 -0.977 -0.996 -0.284 0.03 ...
# $ timeBodyAccelerometer-std()-Y                 : num  -0.8368 -0.9226 -0.9732 0.1145 -0.0319 ...
# $ timeBodyAccelerometer-std()-Z                 : num  -0.826 -0.94 -0.98 -0.26 -0.23 ...
# $ timeGravityAccelerometer-mean()-X             : num  -0.249 0.832 0.943 0.935 0.932 ...
# $ timeGravityAccelerometer-mean()-Y             : num  0.706 0.204 -0.273 -0.282 -0.267 ...
# $ timeGravityAccelerometer-mean()-Z             : num  0.4458 0.332 0.0135 -0.0681 -0.0621 ...
# $ timeGravityAccelerometer-std()-X              : num  -0.897 -0.968 -0.994 -0.977 -0.951 ...
# $ timeGravityAccelerometer-std()-Y              : num  -0.908 -0.936 -0.981 -0.971 -0.937 ...
# $ timeGravityAccelerometer-std()-Z              : num  -0.852 -0.949 -0.976 -0.948 -0.896 ...
# $ timeBodyAccelerometerJerk-mean()-X            : num  0.0811 0.0775 0.0754 0.074 0.0542 ...
# $ timeBodyAccelerometerJerk-mean()-Y            : num  0.003838 -0.000619 0.007976 0.028272 0.02965 ...
# $ timeBodyAccelerometerJerk-mean()-Z            : num  0.01083 -0.00337 -0.00369 -0.00417 -0.01097 ...
# $ timeBodyAccelerometerJerk-std()-X             : num  -0.9585 -0.9864 -0.9946 -0.1136 -0.0123 ...
# $ timeBodyAccelerometerJerk-std()-Y             : num  -0.924 -0.981 -0.986 0.067 -0.102 ...
# $ timeBodyAccelerometerJerk-std()-Z             : num  -0.955 -0.988 -0.992 -0.503 -0.346 ...
# $ timeBodyGyroscope-mean()-X                    : num  -0.0166 -0.0454 -0.024 -0.0418 -0.0351 ...
# $ timeBodyGyroscope-mean()-Y                    : num  -0.0645 -0.0919 -0.0594 -0.0695 -0.0909 ...
# $ timeBodyGyroscope-mean()-Z                    : num  0.1487 0.0629 0.0748 0.0849 0.0901 ...
# $ timeBodyGyroscope-std()-X                     : num  -0.874 -0.977 -0.987 -0.474 -0.458 ...
# $ timeBodyGyroscope-std()-Y                     : num  -0.9511 -0.9665 -0.9877 -0.0546 -0.1263 ...
# $ timeBodyGyroscope-std()-Z                     : num  -0.908 -0.941 -0.981 -0.344 -0.125 ...
# $ timeBodyGyroscopeJerk-mean()-X                : num  -0.1073 -0.0937 -0.0996 -0.09 -0.074 ...
# $ timeBodyGyroscopeJerk-mean()-Y                : num  -0.0415 -0.0402 -0.0441 -0.0398 -0.044 ...
# $ timeBodyGyroscopeJerk-mean()-Z                : num  -0.0741 -0.0467 -0.049 -0.0461 -0.027 ...
# $ timeBodyGyroscopeJerk-std()-X                 : num  -0.919 -0.992 -0.993 -0.207 -0.487 ...
# $ timeBodyGyroscopeJerk-std()-Y                 : num  -0.968 -0.99 -0.995 -0.304 -0.239 ...
# $ timeBodyGyroscopeJerk-std()-Z                 : num  -0.958 -0.988 -0.992 -0.404 -0.269 ...
# $ timeBodyAccelerometerMagnitude-mean()         : num  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
# $ timeBodyAccelerometerMagnitude-std()          : num  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
# $ timeGravityAccelerometerMagnitude-mean()      : num  -0.8419 -0.9485 -0.9843 -0.137 0.0272 ...
# $ timeGravityAccelerometerMagnitude-std()       : num  -0.7951 -0.9271 -0.9819 -0.2197 0.0199 ...
# $ timeBodyAccelerometerJerkMagnitude-mean()     : num  -0.9544 -0.9874 -0.9924 -0.1414 -0.0894 ...
# $ timeBodyAccelerometerJerkMagnitude-std()      : num  -0.9282 -0.9841 -0.9931 -0.0745 -0.0258 ...
# $ timeBodyGyroscopeMagnitude-mean()             : num  -0.8748 -0.9309 -0.9765 -0.161 -0.0757 ...
# $ timeBodyGyroscopeMagnitude-std()              : num  -0.819 -0.935 -0.979 -0.187 -0.226 ...
# $ timeBodyGyroscopeJerkMagnitude-mean()         : num  -0.963 -0.992 -0.995 -0.299 -0.295 ...
# $ timeBodyGyroscopeJerkMagnitude-std()          : num  -0.936 -0.988 -0.995 -0.325 -0.307 ...
# $ frequencyBodyAccelerometer-mean()-X           : num  -0.9391 -0.9796 -0.9952 -0.2028 0.0382 ...
# $ frequencyBodyAccelerometer-mean()-Y           : num  -0.86707 -0.94408 -0.97707 0.08971 0.00155 ...
# $ frequencyBodyAccelerometer-mean()-Z           : num  -0.883 -0.959 -0.985 -0.332 -0.226 ...
# $ frequencyBodyAccelerometer-std()-X            : num  -0.9244 -0.9764 -0.996 -0.3191 0.0243 ...
# $ frequencyBodyAccelerometer-std()-Y            : num  -0.834 -0.917 -0.972 0.056 -0.113 ...
# $ frequencyBodyAccelerometer-std()-Z            : num  -0.813 -0.934 -0.978 -0.28 -0.298 ...
# $ frequencyBodyAccelerometerJerk-mean()-X       : num  -0.9571 -0.9866 -0.9946 -0.1705 -0.0277 ...
# $ frequencyBodyAccelerometerJerk-mean()-Y       : num  -0.9225 -0.9816 -0.9854 -0.0352 -0.1287 ...
# $ frequencyBodyAccelerometerJerk-mean()-Z       : num  -0.948 -0.986 -0.991 -0.469 -0.288 ...
# $ frequencyBodyAccelerometerJerk-std()-X        : num  -0.9642 -0.9875 -0.9951 -0.1336 -0.0863 ...
# $ frequencyBodyAccelerometerJerk-std()-Y        : num  -0.932 -0.983 -0.987 0.107 -0.135 ...
# $ frequencyBodyAccelerometerJerk-std()-Z        : num  -0.961 -0.988 -0.992 -0.535 -0.402 ...
# $ frequencyBodyGyroscope-mean()-X               : num  -0.85 -0.976 -0.986 -0.339 -0.352 ...
# $ frequencyBodyGyroscope-mean()-Y               : num  -0.9522 -0.9758 -0.989 -0.1031 -0.0557 ...
# $ frequencyBodyGyroscope-mean()-Z               : num  -0.9093 -0.9513 -0.9808 -0.2559 -0.0319 ...
# $ frequencyBodyGyroscope-std()-X                : num  -0.882 -0.978 -0.987 -0.517 -0.495 ...
# $ frequencyBodyGyroscope-std()-Y                : num  -0.9512 -0.9623 -0.9871 -0.0335 -0.1814 ...
# $ frequencyBodyGyroscope-std()-Z                : num  -0.917 -0.944 -0.982 -0.437 -0.238 ...
# $ frequencyBodyAccelerometerMagnitude-mean()    : num  -0.8618 -0.9478 -0.9854 -0.1286 0.0966 ...
# $ frequencyBodyAccelerometerMagnitude-std()     : num  -0.798 -0.928 -0.982 -0.398 -0.187 ...
# $ frequencyBodyAccelerometerJerkMagnitude-mean(): num  -0.9333 -0.9853 -0.9925 -0.0571 0.0262 ...
# $ frequencyBodyAccelerometerJerkMagnitude-std() : num  -0.922 -0.982 -0.993 -0.103 -0.104 ...
# $ frequencyBodyGyroscopeMagnitude-mean()        : num  -0.862 -0.958 -0.985 -0.199 -0.186 ...
# $ frequencyBodyGyroscopeMagnitude-std()         : num  -0.824 -0.932 -0.978 -0.321 -0.398 ...
# $ frequencyBodyGyroscopeJerkMagnitude-mean()    : num  -0.942 -0.99 -0.995 -0.319 -0.282 ...
# $ frequencyBodyGyroscopeJerkMagnitude-std()     : num  -0.933 -0.987 -0.995 -0.382 -0.392 ...
```

##### Thanks to summary() function we can have some more information about variables of our "tidyData" dataset 

```{r}
summary(tidyData)
```

```{r}
    subject       activity        
 Min.   : 1.0   Length:180        
 1st Qu.: 8.0   Class :character  
 Median :15.5   Mode  :character  
 Mean   :15.5                     
 3rd Qu.:23.0                     
 Max.   :30.0                     
 timeBodyAccelerometer-mean()-X
 Min.   :0.2216                
 1st Qu.:0.2712                
 Median :0.2770                
 Mean   :0.2743                
 3rd Qu.:0.2800                
 Max.   :0.3015                
 timeBodyAccelerometer-mean()-Y
 Min.   :-0.040514             
 1st Qu.:-0.020022             
 Median :-0.017262             
 Mean   :-0.017876             
 3rd Qu.:-0.014936             
 Max.   :-0.001308             
 timeBodyAccelerometer-mean()-Z
 Min.   :-0.15251              
 1st Qu.:-0.11207              
 Median :-0.10819              
 Mean   :-0.10916              
 3rd Qu.:-0.10443              
 Max.   :-0.07538              
 timeBodyAccelerometer-std()-X
 Min.   :-0.9961              
 1st Qu.:-0.9799              
 Median :-0.7526              
 Mean   :-0.5577              
 3rd Qu.:-0.1984              
 Max.   : 0.6269              
 timeBodyAccelerometer-std()-Y
 Min.   :-0.99024             
 1st Qu.:-0.94205             
 Median :-0.50897             
 Mean   :-0.46046             
 3rd Qu.:-0.03077             
 Max.   : 0.61694             
 timeBodyAccelerometer-std()-Z
 Min.   :-0.9877              
 1st Qu.:-0.9498              
 Median :-0.6518              
 Mean   :-0.5756              
 3rd Qu.:-0.2306              
 Max.   : 0.6090              
 timeGravityAccelerometer-mean()-X
 Min.   :-0.6800                  
 1st Qu.: 0.8376                  
 Median : 0.9208                  
 Mean   : 0.6975                  
 3rd Qu.: 0.9425                  
 Max.   : 0.9745                  
 timeGravityAccelerometer-mean()-Y
 Min.   :-0.47989                 
 1st Qu.:-0.23319                 
 Median :-0.12782                 
 Mean   :-0.01621                 
 3rd Qu.: 0.08773                 
 Max.   : 0.95659                 
 timeGravityAccelerometer-mean()-Z
 Min.   :-0.49509                 
 1st Qu.:-0.11726                 
 Median : 0.02384                 
 Mean   : 0.07413                 
 3rd Qu.: 0.14946                 
 Max.   : 0.95787                 
 timeGravityAccelerometer-std()-X
 Min.   :-0.9968                 
 1st Qu.:-0.9825                 
 Median :-0.9695                 
 Mean   :-0.9638                 
 3rd Qu.:-0.9509                 
 Max.   :-0.8296                 
 timeGravityAccelerometer-std()-Y
 Min.   :-0.9942                 
 1st Qu.:-0.9711                 
 Median :-0.9590                 
 Mean   :-0.9524                 
 3rd Qu.:-0.9370                 
 Max.   :-0.6436                 
 timeGravityAccelerometer-std()-Z
 Min.   :-0.9910                 
 1st Qu.:-0.9605                 
 Median :-0.9450                 
 Mean   :-0.9364                 
 3rd Qu.:-0.9180                 
 Max.   :-0.6102                 
 timeBodyAccelerometerJerk-mean()-X
 Min.   :0.04269                   
 1st Qu.:0.07396                   
 Median :0.07640                   
 Mean   :0.07947                   
 3rd Qu.:0.08330                   
 Max.   :0.13019                   
 timeBodyAccelerometerJerk-mean()-Y
 Min.   :-0.0386872                
 1st Qu.: 0.0004664                
 Median : 0.0094698                
 Mean   : 0.0075652                
 3rd Qu.: 0.0134008                
 Max.   : 0.0568186                
 timeBodyAccelerometerJerk-mean()-Z
 Min.   :-0.067458                 
 1st Qu.:-0.010601                 
 Median :-0.003861                 
 Mean   :-0.004953                 
 3rd Qu.: 0.001958                 
 Max.   : 0.038053                 
 timeBodyAccelerometerJerk-std()-X
 Min.   :-0.9946                  
 1st Qu.:-0.9832                  
 Median :-0.8104                  
 Mean   :-0.5949                  
 3rd Qu.:-0.2233                  
 Max.   : 0.5443                  
 timeBodyAccelerometerJerk-std()-Y
 Min.   :-0.9895                  
 1st Qu.:-0.9724                  
 Median :-0.7756                  
 Mean   :-0.5654                  
 3rd Qu.:-0.1483                  
 Max.   : 0.3553                  
 timeBodyAccelerometerJerk-std()-Z
 Min.   :-0.99329                 
 1st Qu.:-0.98266                 
 Median :-0.88366                 
 Mean   :-0.73596                 
 3rd Qu.:-0.51212                 
 Max.   : 0.03102                 
 timeBodyGyroscope-mean()-X
 Min.   :-0.20578          
 1st Qu.:-0.04712          
 Median :-0.02871          
 Mean   :-0.03244          
 3rd Qu.:-0.01676          
 Max.   : 0.19270          
 timeBodyGyroscope-mean()-Y
 Min.   :-0.20421          
 1st Qu.:-0.08955          
 Median :-0.07318          
 Mean   :-0.07426          
 3rd Qu.:-0.06113          
 Max.   : 0.02747          
 timeBodyGyroscope-mean()-Z
 Min.   :-0.07245          
 1st Qu.: 0.07475          
 Median : 0.08512          
 Mean   : 0.08744          
 3rd Qu.: 0.10177          
 Max.   : 0.17910          
 timeBodyGyroscope-std()-X
 Min.   :-0.9943          
 1st Qu.:-0.9735          
 Median :-0.7890          
 Mean   :-0.6916          
 3rd Qu.:-0.4414          
 Max.   : 0.2677          
 timeBodyGyroscope-std()-Y
 Min.   :-0.9942          
 1st Qu.:-0.9629          
 Median :-0.8017          
 Mean   :-0.6533          
 3rd Qu.:-0.4196          
 Max.   : 0.4765          
 timeBodyGyroscope-std()-Z
 Min.   :-0.9855          
 1st Qu.:-0.9609          
 Median :-0.8010          
 Mean   :-0.6164          
 3rd Qu.:-0.3106          
 Max.   : 0.5649          
 timeBodyGyroscopeJerk-mean()-X
 Min.   :-0.15721              
 1st Qu.:-0.10322              
 Median :-0.09868              
 Mean   :-0.09606              
 3rd Qu.:-0.09110              
 Max.   :-0.02209              
 timeBodyGyroscopeJerk-mean()-Y
 Min.   :-0.07681              
 1st Qu.:-0.04552              
 Median :-0.04112              
 Mean   :-0.04269              
 3rd Qu.:-0.03842              
 Max.   :-0.01320              
 timeBodyGyroscopeJerk-mean()-Z
 Min.   :-0.092500             
 1st Qu.:-0.061725             
 Median :-0.053430             
 Mean   :-0.054802             
 3rd Qu.:-0.048985             
 Max.   :-0.006941             
 timeBodyGyroscopeJerk-std()-X
 Min.   :-0.9965              
 1st Qu.:-0.9800              
 Median :-0.8396              
 Mean   :-0.7036              
 3rd Qu.:-0.4629              
 Max.   : 0.1791              
 timeBodyGyroscopeJerk-std()-Y
 Min.   :-0.9971              
 1st Qu.:-0.9832              
 Median :-0.8942              
 Mean   :-0.7636              
 3rd Qu.:-0.5861              
 Max.   : 0.2959              
 timeBodyGyroscopeJerk-std()-Z
 Min.   :-0.9954              
 1st Qu.:-0.9848              
 Median :-0.8610              
 Mean   :-0.7096              
 3rd Qu.:-0.4741              
 Max.   : 0.1932              
 timeBodyAccelerometerMagnitude-mean()
 Min.   :-0.9865                      
 1st Qu.:-0.9573                      
 Median :-0.4829                      
 Mean   :-0.4973                      
 3rd Qu.:-0.0919                      
 Max.   : 0.6446                      
 timeBodyAccelerometerMagnitude-std()
 Min.   :-0.9865                     
 1st Qu.:-0.9430                     
 Median :-0.6074                     
 Mean   :-0.5439                     
 3rd Qu.:-0.2090                     
 Max.   : 0.4284                     
 timeGravityAccelerometerMagnitude-mean()
 Min.   :-0.9865                         
 1st Qu.:-0.9573                         
 Median :-0.4829                         
 Mean   :-0.4973                         
 3rd Qu.:-0.0919                         
 Max.   : 0.6446                         
 timeGravityAccelerometerMagnitude-std()
 Min.   :-0.9865                        
 1st Qu.:-0.9430                        
 Median :-0.6074                        
 Mean   :-0.5439                        
 3rd Qu.:-0.2090                        
 Max.   : 0.4284                        
 timeBodyAccelerometerJerkMagnitude-mean()
 Min.   :-0.9928                          
 1st Qu.:-0.9807                          
 Median :-0.8168                          
 Mean   :-0.6079                          
 3rd Qu.:-0.2456                          
 Max.   : 0.4345                          
 timeBodyAccelerometerJerkMagnitude-std()
 Min.   :-0.9946                         
 1st Qu.:-0.9765                         
 Median :-0.8014                         
 Mean   :-0.5842                         
 3rd Qu.:-0.2173                         
 Max.   : 0.4506                         
 timeBodyGyroscopeMagnitude-mean()
 Min.   :-0.9807                  
 1st Qu.:-0.9461                  
 Median :-0.6551                  
 Mean   :-0.5652                  
 3rd Qu.:-0.2159                  
 Max.   : 0.4180                  
 timeBodyGyroscopeMagnitude-std()
 Min.   :-0.9814                 
 1st Qu.:-0.9476                 
 Median :-0.7420                 
 Mean   :-0.6304                 
 3rd Qu.:-0.3602                 
 Max.   : 0.3000                 
 timeBodyGyroscopeJerkMagnitude-mean()
 Min.   :-0.99732                     
 1st Qu.:-0.98515                     
 Median :-0.86479                     
 Mean   :-0.73637                     
 3rd Qu.:-0.51186                     
 Max.   : 0.08758                     
 timeBodyGyroscopeJerkMagnitude-std()
 Min.   :-0.9977                     
 1st Qu.:-0.9805                     
 Median :-0.8809                     
 Mean   :-0.7550                     
 3rd Qu.:-0.5767                     
 Max.   : 0.2502                     
 frequencyBodyAccelerometer-mean()-X
 Min.   :-0.9952                    
 1st Qu.:-0.9787                    
 Median :-0.7691                    
 Mean   :-0.5758                    
 3rd Qu.:-0.2174                    
 Max.   : 0.5370                    
 frequencyBodyAccelerometer-mean()-Y
 Min.   :-0.98903                   
 1st Qu.:-0.95361                   
 Median :-0.59498                   
 Mean   :-0.48873                   
 3rd Qu.:-0.06341                   
 Max.   : 0.52419                   
 frequencyBodyAccelerometer-mean()-Z
 Min.   :-0.9895                    
 1st Qu.:-0.9619                    
 Median :-0.7236                    
 Mean   :-0.6297                    
 3rd Qu.:-0.3183                    
 Max.   : 0.2807                    
 frequencyBodyAccelerometer-std()-X
 Min.   :-0.9966                   
 1st Qu.:-0.9820                   
 Median :-0.7470                   
 Mean   :-0.5522                   
 3rd Qu.:-0.1966                   
 Max.   : 0.6585                   
 frequencyBodyAccelerometer-std()-Y
 Min.   :-0.99068                  
 1st Qu.:-0.94042                  
 Median :-0.51338                  
 Mean   :-0.48148                  
 3rd Qu.:-0.07913                  
 Max.   : 0.56019                  
 frequencyBodyAccelerometer-std()-Z
 Min.   :-0.9872                   
 1st Qu.:-0.9459                   
 Median :-0.6441                   
 Mean   :-0.5824                   
 3rd Qu.:-0.2655                   
 Max.   : 0.6871                   
 frequencyBodyAccelerometerJerk-mean()-X
 Min.   :-0.9946                        
 1st Qu.:-0.9828                        
 Median :-0.8126                        
 Mean   :-0.6139                        
 3rd Qu.:-0.2820                        
 Max.   : 0.4743                        
 frequencyBodyAccelerometerJerk-mean()-Y
 Min.   :-0.9894                        
 1st Qu.:-0.9725                        
 Median :-0.7817                        
 Mean   :-0.5882                        
 3rd Qu.:-0.1963                        
 Max.   : 0.2767                        
 frequencyBodyAccelerometerJerk-mean()-Z
 Min.   :-0.9920                        
 1st Qu.:-0.9796                        
 Median :-0.8707                        
 Mean   :-0.7144                        
 3rd Qu.:-0.4697                        
 Max.   : 0.1578                        
 frequencyBodyAccelerometerJerk-std()-X
 Min.   :-0.9951                       
 1st Qu.:-0.9847                       
 Median :-0.8254                       
 Mean   :-0.6121                       
 3rd Qu.:-0.2475                       
 Max.   : 0.4768                       
 frequencyBodyAccelerometerJerk-std()-Y
 Min.   :-0.9905                       
 1st Qu.:-0.9737                       
 Median :-0.7852                       
 Mean   :-0.5707                       
 3rd Qu.:-0.1685                       
 Max.   : 0.3498                       
 frequencyBodyAccelerometerJerk-std()-Z
 Min.   :-0.993108                     
 1st Qu.:-0.983747                     
 Median :-0.895121                     
 Mean   :-0.756489                     
 3rd Qu.:-0.543787                     
 Max.   :-0.006236                     
 frequencyBodyGyroscope-mean()-X
 Min.   :-0.9931                
 1st Qu.:-0.9697                
 Median :-0.7300                
 Mean   :-0.6367                
 3rd Qu.:-0.3387                
 Max.   : 0.4750                
 frequencyBodyGyroscope-mean()-Y
 Min.   :-0.9940                
 1st Qu.:-0.9700                
 Median :-0.8141                
 Mean   :-0.6767                
 3rd Qu.:-0.4458                
 Max.   : 0.3288                
 frequencyBodyGyroscope-mean()-Z
 Min.   :-0.9860                
 1st Qu.:-0.9624                
 Median :-0.7909                
 Mean   :-0.6044                
 3rd Qu.:-0.2635                
 Max.   : 0.4924                
 frequencyBodyGyroscope-std()-X
 Min.   :-0.9947               
 1st Qu.:-0.9750               
 Median :-0.8086               
 Mean   :-0.7110               
 3rd Qu.:-0.4813               
 Max.   : 0.1966               
 frequencyBodyGyroscope-std()-Y
 Min.   :-0.9944               
 1st Qu.:-0.9602               
 Median :-0.7964               
 Mean   :-0.6454               
 3rd Qu.:-0.4154               
 Max.   : 0.6462               
 frequencyBodyGyroscope-std()-Z
 Min.   :-0.9867               
 1st Qu.:-0.9643               
 Median :-0.8224               
 Mean   :-0.6577               
 3rd Qu.:-0.3916               
 Max.   : 0.5225               
 frequencyBodyAccelerometerMagnitude-mean()
 Min.   :-0.9868                           
 1st Qu.:-0.9560                           
 Median :-0.6703                           
 Mean   :-0.5365                           
 3rd Qu.:-0.1622                           
 Max.   : 0.5866                           
 frequencyBodyAccelerometerMagnitude-std()
 Min.   :-0.9876                          
 1st Qu.:-0.9452                          
 Median :-0.6513                          
 Mean   :-0.6210                          
 3rd Qu.:-0.3654                          
 Max.   : 0.1787                          
 frequencyBodyAccelerometerJerkMagnitude-mean()
 Min.   :-0.9940                               
 1st Qu.:-0.9770                               
 Median :-0.7940                               
 Mean   :-0.5756                               
 3rd Qu.:-0.1872                               
 Max.   : 0.5384                               
 frequencyBodyAccelerometerJerkMagnitude-std()
 Min.   :-0.9944                              
 1st Qu.:-0.9752                              
 Median :-0.8126                              
 Mean   :-0.5992                              
 3rd Qu.:-0.2668                              
 Max.   : 0.3163                              
 frequencyBodyGyroscopeMagnitude-mean()
 Min.   :-0.9865                       
 1st Qu.:-0.9616                       
 Median :-0.7657                       
 Mean   :-0.6671                       
 3rd Qu.:-0.4087                       
 Max.   : 0.2040                       
 frequencyBodyGyroscopeMagnitude-std()
 Min.   :-0.9815                      
 1st Qu.:-0.9488                      
 Median :-0.7727                      
 Mean   :-0.6723                      
 3rd Qu.:-0.4277                      
 Max.   : 0.2367                      
 frequencyBodyGyroscopeJerkMagnitude-mean()
 Min.   :-0.9976                           
 1st Qu.:-0.9813                           
 Median :-0.8779                           
 Mean   :-0.7564                           
 3rd Qu.:-0.5831                           
 Max.   : 0.1466                           
 frequencyBodyGyroscopeJerkMagnitude-std()
 Min.   :-0.9976                          
 1st Qu.:-0.9802                          
 Median :-0.8941                          
 Mean   :-0.7715                          
 3rd Qu.:-0.6081                          
 Max.   : 0.2878                          
```
