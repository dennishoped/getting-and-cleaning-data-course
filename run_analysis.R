####################################################################################
# Source of data for project: "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
#####################################################################################

#load necessary packages
require(plyr)
require(dplyr)

# Setting Directories and files
#Features
feat<- read.table("features.txt")
dim(feat) 

#Activity labels
act_label<- read.table("activity_label.txt")
head(act_label) 

#Load data set 
dat_X_train<- read.table("X_train.txt")
dat_subject_train<- read.table("subject_train.txt")
dat_y_train<- read.table("y_train.txt")
dat_train<- cbind(dat_subject_train, dat_y_train, dat_X_train)

#Test data
X_test<- read.table("X_test.txt")
subject_test<- read.table("subject_test.txt")
y_test<- read.table("y_test.txt")

dat_test<- cbind(subject_test, y_test, X_test)

#####################################################################################
#STEP 1: MERGES THE TRAINING AND TEST SETS TO CREATE ONE DATASET
#####################################################################################

merged_dat<-rbind(dat_train,dat_test)
varNames<-c("subject","activity_no",as.character(feat$V2))
names(merged_dat)<-varNames

#####################################################################################
#STEP 2: EXCTRACTS THE MEASUREMENTS ON MEAN AND STANDARD DEVIATION
#####################################################################################

sum(duplicated(feat$V2)) 
feat$V2[duplicated(feat$V2)] 
to.remove<-as.character(feat$V2[duplicated(feat$V2)])
drop_dat<-labeled_dat
drop_dat<-drop_dat[, !(colnames(dropDF) %in% to.remove)]
sub_dat<-select(drop_dat,contains("subject"), contains("ACT_TYPE"), contains("MEAN"), contains("SD"))
dim(sub_dat)

#####################################################################################
#STEP 3: USE DESCRIPTIVE ACTIVITY NAMES TO NAME THE ACTIVITIES IN THE DATA SET.
#####################################################################################

table(merged_dat$activity_no) 
lookup<- act_label
names(lookup)<- c("activity_no","activity_type")
labeled_dat<- join(merged_dat,lookup,by='activity_no')

#####################################################################################
#STEP 4: LABEL THE DATA SET WITH DESCRIPTIVE VARIABLE NAMES 
#####################################################################################

table(labeled_datF$activity_type)
head(labeled_dat[labeled_dat$activity_type=="WALKING",1:3])

#####################################################################################
#STEP 5: CREATE A SECOND, INDEPENDENT TIDY DATA SET WITH THE AVERAGE OF EACH VARIABLE FOR EACH ACTIVITY AND EACH SUBJECT.
#####################################################################################
dat_set2<- aggregate(sub_dat, by=list(sub_dat$subject, sub_dat$activity_type),  FUN=mean)
dim(dat_set2)

dat_set2$subject<-NULL
dat_set2$activity_type<-NULL
colnames(dat_set2)[1:2]<-c("subject","activity_type")
str(dat_set2) 

#Write final dataset in a .txt file:
write.table(dat_set2, "tidy_dataset.txt", row.name=FALSE)

#END OF SCRIPT
#####################################################################################
