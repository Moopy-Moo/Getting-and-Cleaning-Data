train_subject<-read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE,col.names="subject")
train_data <- read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train_label <- read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/train/y_train.txt", sep="", header=FALSE,col.names="label")
test_subject <- read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE,col.names="subject")
test_data<-read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test_label<-read.csv("C:/Users/jwang/Desktop/coursera/data science/UCI HAR Dataset/test/y_test.txt", sep="", header=FALSE,col.names="label")
# labels correspond to activity_label, containing WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

# data sets loaded in, now combining by rows
x<-rbind(train_data,test_data)
y<-rbind(train_label,test_label)
total_subject<-rbind(train_subject,test_subject)

#extract only the measurements on the mean and standard deviation by pattern in names
features <- read.table("features.txt")
names(features)<-c("feat_id","feat_name")
pattern_features<-grep("-mean\\(\\)|-std\\(\\)",features$feat_name)
x<-x[,pattern_features]
names(x)<-gsub("\\(\\)","",(features[pattern_features,2]))

# relabel the activities
# activities<-read.csv("activity_labels.txt")
# names(activities)<-c("act_id","act_name")
# for whatever reason mine only reads as five variables, so I will do the following instead (maybe a little dumb but it works)
activities<-data.frame("act_id"=1:6,"act_name"=c("walking","walking_upstairs","walking_downstairs","sitting","standing","laying"))
y[,1]=activities[y[,1],2]
names(y)<-"activities"
names(total_subject)<-"subject"
tidy<-cbind(total_subject,y,x)
ntidy<-gsub("tBody","time-Body",names(tidy),ignore.case=FALSE)
ntidy<-gsub("tGravity","time-Gravity",ntidy,ignore.case=FALSE)
ntidy<-gsub("Mag","Magnitude",ntidy,ignore.case=FALSE)
ntidy<-gsub("Gyro","Gyroscope",ntidy,ignore.case=FALSE)
ntidy<-gsub("Acc","Accelerometer",ntidy,ignore.case=FALSE)
ntidy<-gsub("fBody","fastFourierTransform-body",ntidy,ignore.case=FALSE)
ntidy<-gsub("BodyBody","Body",ntidy,ignore.case=FALSE)
colnames(tidy)<-ntidy
# now the abbreviations have been expanded

# second tidy data set
tidy_2<-aggregate(tidy[,3:ncol(tidy)],by=list(subject=tidy$subject,activities=tidy$activities),mean)

# save tidy_2 as a txt file
write.table(format(tidy_2,scientific=T),"tidy_2.txt",row.names = F, col.names = F, quote=2)