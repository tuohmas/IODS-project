# Tuomas Heikkilä
# 2021-11-08
# Data wrangling part of Exercise 2: create learning2014 dataset

# Clean up environment

rm(list = ls())
ls()

# Set working directory

setwd("~/R/IODS-project/data")

# Make necessary packages available

require(dplyr)

# Read data table from an tab-delimited text file via URL 

lrn2014 <-  read.table(
  "https://www.mv.helsinki.fi/home/kvehkala/JYTmooc/JYTOPKYS3-data.txt",
  sep = "\t", header = TRUE)

# View data
View(lrn2014)

# Look at the dimensions and the structure of the data
dim(lrn2014)
str(lrn2014)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06", "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- dplyr::select(lrn2014, one_of(deep_questions))
lrn2014$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(lrn2014, one_of(surface_questions))
lrn2014$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(lrn2014, one_of(strategic_questions))
lrn2014$stra <- rowMeans(strategic_columns)

# see the stucture of the new dataset
str(lrn2014)

# Create a dataframe learning201 by keeping only certain variables
keep_columns <- c("gender","Age","Attitude", "deep", "stra", "surf", "Points")

learning2014 <- select(lrn2014, one_of(keep_columns))

# print out the column names of the data
colnames(learning2014)

# lowercase Age and Points
colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[7] <- "points"
colnames(learning2014)

# filter out observations where the exam points variable is zero
learning2014 <- filter(learning2014, points > 0)

# Make sure the final dataset consists of 166 observations and 7 variables

dim(learning2014)

# Export dataset as csv

write.csv(learning2014, file = "learning2014.csv", row.names = F)

# Read output to make sure it works

learning2014 <- read.csv("learning2014.csv")

View(learning2014)

# Clean up the environment

rm(list = ls())
ls()