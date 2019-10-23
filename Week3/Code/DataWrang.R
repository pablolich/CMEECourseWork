################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################
require(reshape2)

############# Load the dataset ###############
# header = false because the raw data don't have real headers
MyData <- as.matrix(read.csv("../data/PoundHillData.csv",header = F), stringsAsFactors = F) 

# header = true because we do have metadata headers
MyMetaData <- read.csv("../data/PoundHillMetaData.csv",header = T, sep=";", stringsAsFactors = F)

MyData[MyData == ""] = 0
MyData <- t(MyData) 
head(MyData)
TempData <- as.data.frame(MyData[-1,],stringsAsFactors = F)

colnames(TempData) <- MyData[1,] #Assign the column names of the original data
head(TempData)

rownames(TempData) <- NULL
head(TempData)

MyWrangledData <- melt(TempData, id=c("Cultivation", "Block", "Plot", "Quadrat"), 
                       variable.name = "Species", value.name = "Count")
head(MyWrangledData); tail(MyWrangledData)
############# Convert from wide to long format  ###############

MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])

str(MyWrangledData)
head(MyWrangledData)
dim(MyWrangledData)
