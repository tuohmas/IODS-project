# Tuomas Heikkilä
# tuomas.k.heikkila@helsinki.fi
# 2021-12-07

library(tidyverse)

# Read the BPRS and RATS data sets 
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep  ="\t", header = T)

# Look at the (column) names
names(BPRS)
names(RATS)

# Look at the structure
str(BPRS)
str(RATS)

# Print out summaries of the variables
summary(BPRS)
summary(RATS)

# SUMMARY OF THE DATA SETS #####################################################

# BPRS data consists of "40 male subjects who were randomly assigned to one of 
# two treatment groups and each subject was rated on the brief psychiatric 
# rating scale (BPRS) BPRS) measured before treatment began (week 0) and then at
# weekly intervals for eight weeks. The BPRS assesses the level of 18 symptom 
# constructs such as hostility, suspiciousness, hallucinations and grandiosity; 
# each of these is rated from one (not present) to seven (extremely severe). 
# The scale is used to evaluate patients suspected of having schizophrenia. 
# (Vehkalahti and Everitt, 2019, p. 157, taken from Davis, 2002)

# In short form, BPRS variables are:
# $treatment : weather participant is assigned to treatment group 1 or 2
## $subject : unbique identifier
## $week0 : baseline measurment before treatment
## $week1 - week8 : weekly measure 1-8 weeks after the treatment. 

# Basing from weekly summaries alone, there seems to be a trend of decreasing
# means of measurements week after week.

# RATS is a nutrition study conducted in three groups of rats (Crowder and Hand,
# 1990).

# In short form, RATS variables are:
# $ID : unique indentifier
# $Group :  1-3, each put on a different diets.
# $WD1 - WD64 : rat body weight (in grams), measured repeatedly over 9-week 
# period.
################################################################################

# BRPS, PRELIMINARY VISUAL INSPECTION OF THE DATA ##############################

# Convert categorical variables in eacch data set to factors
BPRS$treatment <- BPRS$treatment %>% factor()
BPRS$subject <- BPRS$subject %>% factor()

RATS$ID <- RATS$ID %>% factor()
RATS$Group <- RATS$Group %>% factor() 

# Convert BPRS to long form
BPRSL <-  BPRS %>% 
  
  # Gather all columns except for treatment and subject
  tidyr::gather(key = weeks, value = bprs, -treatment, -subject) %>%

# Extract the week number
  mutate(week = as.integer(substr(BPRSL$weeks, 5, 5)))

# Take a glimpse at the BPRSL data
glimpse(BPRSL)

# Convert RATS to long form
RATSL <- RATS %>% 
  
  # Gather all columns except for ID and Group
  tidyr::gather(key = WD, value = Weight, -ID, -Group) %>% 
  
  # Extract the week number
  mutate(Time = as.integer(substr(WD, 3, 5)))

# Glimpse the data
glimpse(RATSL)

# Write data in long form local data repo and then push to Git
write.table(BPRSL, "data/bprsl.csv", sep = ";", 
            col.names = T, row.names = F)

write.table(RATSL, "data/ratsl.csv", sep = ";", 
            col.names = T, row.names = F) 