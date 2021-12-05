# Tuomas Heikkilä
# 2021-11-24

# Data from http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human1.txt

library(tidyverse)

# Read the "Human development" data and assign it to hd
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

# Read the Read the "“"Gender inequality" data and assign it to gii
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# explore hd
str(hd)
summary(hd)

# explore gii
str(gii)
summary(gii)

# Renaming columns with lowercase + snakecase and desriptive names 
colnames(hd) <- c("hdi_rank", "country", "hdi", "life_exp_birth", 
                  "edu_expected", "edu_mean", "gni_per_capita", "gni_hdi_rank")
colnames(gii) <- c("gii_rank", "country", "gii", "mat_mortality", 
                   "adol_birth_rate", "repr", "edu2f", "edu2m", "lab_f", 
                   "lab_m")

# Introduce to new variables to gii: 
# a) ratio of Female and Male populations with secondary education; and
# b) ratio of labour force participation of females and males in each country
gii <- mutate(gii, edu2_f2m = edu2f / edu2m) %>% mutate(lab_f2m = 
                                                          lab_f / lab_m)

gii

# Join together datasets by country to form data.table "human"
human <- inner_join(hd, gii, by = "country")

# Dataset consists now of 195 observations and 19 variables
glimpse(human)

# Save datatable to data folder
write.table(human, "human.csv", sep = ";", col.names = T, row.names = F)

# CONTINUING WITH THE SCRIPT ON EXERCICE 5 #####################################

library(tidyverse)
library(stringr)

# Optional: reading previously created human.csv from github
 human <- read.table(
  "https://raw.githubusercontent.com/tuohmas/IODS-project/master/data/human.csv",
           header = TRUE, sep = ";")

# Glimpse data and str
glimpse(human)
str(human)

# There are 195 observations (countries) and 19 variables

# GNI per capita column has been stored as a character object due to thousand
# separator (,)
str(human$gni_per_capita)

# remove the commas from GNI and print out a numeric version of it
human$gni_per_capita <- str_replace(human$gni_per_capita, pattern=",", replace ="") %>% as.numeric

# Exclude unneeded variables. columns to keep
keep <- c("country", "edu2_f2m", "lab_f2m", "life_exp_birth", "edu_expected", "gni_per_capita", "mat_mortality", "adol_birth_rate", "repr")

# select the 'keep' columns
human <- dplyr::select(human, one_of(keep))

# print out a completeness indicator of the 'human' data
complete.cases(human)

# print out the data along with a completeness indicator as the last column
human$comp <- complete.cases(human)
human

# filter out all rows with NA values and remove comp indicator
human <- filter(human, comp)
human <- dplyr::select(human, -comp)

# Looking from human tail
tail(human, n = 8)

# Last 7 rows have been dedicated to regions (and the world) rather than counties

# define the last indice we want to keep
last <- nrow(human) - 7

# choose everything until the last 7 observations
human <- human[1:last, ]

# add countries as rownames
rownames(human) <- human_$Country

# remove the Country variable
human <- dplyr::select(human, -country)

# explore human structure
str(human)

# data has 155 observations and 8 variables, as it should.

# overwrite old human csv
write.table(human, "data/human.csv", sep = ";", row.names = F, col.names = T)
