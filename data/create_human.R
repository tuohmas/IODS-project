# Tuomas Heikkilä
# 2021-11-24

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