## Getting and Cleaning Data (getdata-008) Course Project

# Descarga el archivo de datos
archivo <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(archivo, "getdata-projectfiles-UCI HAR Dataset.zip", method = "wget", quiet = FALSE)
unzip(zipfile = "getdata-projectfiles-UCI HAR Dataset.zip", list = FALSE, overwrite = TRUE)

#Instala paquetes requeridos para el procesamiento de los datos
install.packages("data.table")
install.packages("reshape2")

#Habilita paquetes requeridos para el procesamiento de los datos
require("data.table")
require("reshape2")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]
extract_features <- grepl("mean|std", features)

Xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
names(Xtest) = features
Xtest = Xtest[,extract_features]

ytest[,2] = activity_labels[ytest[,1]]
names(ytest) = c("Activity_ID", "Activity_Label")
names(subject_test) = "subject"

test_data_set <- cbind(as.data.table(subject_test), ytest, Xtest)

Xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")

subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

names(Xtrain) = features

Xtrain = Xtrain[,extract_features]

ytrain[,2] = activity_labels[ytrain[,1]]
names(ytrain) = c("Activity_ID", "Activity_Label")
names(subject_train) = "subject"

train_data_set <- cbind(as.data.table(subject_train), ytrain, Xtrain)

data_set = rbind(test_data_set, train_data_set)

id_labels = c("subject", "Activity_ID", "Activity_Label")
data_set_labels = setdiff(colnames(data_set), id_labels)
melt_data = melt(data_set, id = id_labels, measure.vars = data_set_labels)

data_limpia = dcast(melt_data, subject + Activity_Label ~ variable, mean)

write.table(data_limpia, file = "./tidy_data_set.txt", row.name=FALSE)
