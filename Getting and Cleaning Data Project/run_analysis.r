packages <- c("data.table", "reshape2")
sapply(packages, require, character.only=TRUE, quietly=TRUE)
path <- getwd()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, file.path(path, "dataFiles.zip"))
unzip(zipfile = "dataFiles.zip")

# Load activity labels + features
Labels <- fread(file.path(path, "UCI HAR Dataset/activity_labels.txt")
                , col.names = c("classLabels", "activityName"))
features <- fread(file.path(path, "UCI HAR Dataset/features.txt")
                  , col.names = c("index", "featureNames"))
WantedFeatures <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[WantedFeatures, featureNames]
measurements <- gsub('[()]', '', measurements)

# Load train datasets
train <- fread(file.path(path, "UCI HAR Dataset/train/X_train.txt"))[, WantedFeatures, with = FALSE]
data.table::setnames(train, colnames(train), measurements)
Activities_train <- fread(file.path(path, "UCI HAR Dataset/train/Y_train.txt")
                          , col.names = c("Activity"))
Subjects_train <- fread(file.path(path, "UCI HAR Dataset/train/subject_train.txt")
                        , col.names = c("SubjectNum"))
train <- cbind(Subjects_train, Activities_train, train)

# Load test datasets
test <- fread(file.path(path, "UCI HAR Dataset/test/X_test.txt"))[, WantedFeatures, with = FALSE]
data.table::setnames(test, colnames(test), measurements)
Activities_test <- fread(file.path(path, "UCI HAR Dataset/test/Y_test.txt")
                         , col.names = c("Activity"))
Subjects_test <- fread(file.path(path, "UCI HAR Dataset/test/subject_test.txt")
                       , col.names = c("SubjectNum"))
test <- cbind(Subjects_test, Activities_test, test)

# merge datasets
combined <- rbind(train, test)

# Convert classLabels to activityName basically. More explicit. 
combined[["Activity"]] <- factor(combined[, Activity]
                                 , levels = Labels[["classLabels"]]
                                 , labels = Labels[["activityName"]])

combined[["SubjectNum"]] <- as.factor(combined[, SubjectNum])
combined <- reshape2::melt(data = combined, id = c("SubjectNum", "Activity"))
combined <- reshape2::dcast(data = combined, SubjectNum + Activity ~ variable, fun.aggregate = mean)

data.table::fwrite(x = combined, file = "tidyData.txt", quote = FALSE)