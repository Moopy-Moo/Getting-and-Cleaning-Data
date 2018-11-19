train<-read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE,col.names="subject")
train_data <- read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train_label <- read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE,col.names="label")
test <- read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE,col.names="subject")
test_data<-read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test_label<-read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE,col.names="label")
# data sets loaded in, now combining by column then rows
x<-cbind(test,test_label,test_data)
y<-cbind(train,train_label,train_data)
data<-rbind(x,y)
#extract only the measurements on the mean and standard deviation
features <- read.table("features.txt")
pattern_features<-features[grep("mean\\(\\)|std\\(\\)",features$V2),]
tidy<-data[,c(1,2,pattern_features$V1+2)]
# relabel the activities
activities<-read.csv("activity_labels.txt", stringsAsFactors = FALSE)
ntidy<-gsub("tBody","time-Body",names(tidy),ignore.case=FALSE)
ntidy<-gsub("tGravity","time-Gravity",ntidy,ignore.cases=FALSE)
ntidy<-gsub("Mag","Magnitude",ntidy,ignore.case=FALSE)
ntidy<-gsub("Gyro","Gyroscope",ntidy,ignore.case=FALSE)
ntidy<-gsub("Acc","Accelerometer",ntidy,ignore.case=FALSE)
ntidy<-gsub("fBody","fastFourierTransform-body",ntidy,ignore.case=FALSE)
ntidy<-gsub("Freq","Frequency",ntidy,ignore.case=FALSE)
ntidy<-gsub("BodyBody","Body",ntidy,ignore.case=FALSE)
colnames(tidy)<-ntidy

# second tidy data set
tidy_2<-aggregate(tidy[,3:ncol(tidy)],by=list(subject=tidy$subject,label=tidy$label),mean)
# save tidy_2 as a txt file
write.table(format(tidy_2,scientific=T),"tidy_2.txt",row.names = F, col.names = F, quote=2)