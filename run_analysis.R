temp<-tempfile(fileext=".zip")

download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)

unzip(temp, list=T)

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

unlink(temp)

str(features)
str(activityLabels)
str(dataTrainX)
str(dataTrainY)
str(dataTrainSubject)
str(dataTestX)
str(dataTestY)
str(dataTestSubject)

dataTrain<-data.frame(dataTrainSubject, dataTrainY, dataTrainX)
dataTest<-data.frame(dataTestSubject, dataTestY, dataTestX)

names(dataTrain)<-c(c('subject', 'activity'), features)
names(dataTest)<-c(c('subject', 'activity'), features)

data<-rbind(dataTrain, dataTest)

dataExtr<-data[,which(colnames(data) %in% c("subject", "activity", grep("mean\\(\\)|std\\(\\)", colnames(data), value=TRUE)))]
str(dataExtr)

dataExtr$activity<-activityLabels[dataExtr$activity]
head(dataExtr$activity,50)

names(dataExtr)
unique(gsub("\\-(mean|std)\\(\\).*", "", names(dataExtr)[-c(1:2)]))

names(dataExtr)[-c(1:2)]<-gsub("^t", "time", names(dataExtr)[-c(1:2)])
names(dataExtr)[-c(1:2)]<-gsub("^f", "frequency", names(dataExtr)[-c(1:2)])
names(dataExtr)[-c(1:2)]<-gsub("Acc", "Accelerometer", names(dataExtr)[-c(1:2)])
names(dataExtr)[-c(1:2)]<-gsub("Gyro", "Gyroscope", names(dataExtr)[-c(1:2)])
names(dataExtr)[-c(1:2)]<-gsub("Mag", "Magnitude", names(dataExtr)[-c(1:2)])
names(dataExtr)[-c(1:2)]<-gsub("BodyBody", "Body", names(dataExtr)[-c(1:2)])
names(dataExtr)
str(dataExtr)

tidyData<-aggregate(. ~ subject + activity, dataExtr, mean)
tidyData<-tidyData[order(tidyData$subject,tidyData$activity),]
write.table(tidyData, file = "tidyData.txt",row.name=FALSE)

