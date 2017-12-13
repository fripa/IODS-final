#### Data wrangling for final assignment ####
#Frida Gyllenberg, december 13th, 2017

# libraries
library(tidyverse)
library(ggplot2)
library(GGally)
library(corrplot)
library(stats)

# reading in the data
learning <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header = T)

learning %>% glimpse # the data looks ok, no problems reading in
learning %>% dim # 183 observations and 60 variables, i.e. a lot of variables
learning %>% str # all variables are intergerns except gender that is an binary factor variable

## to make the data more easy to comprehend, I will start with computing new variables out of the different topics of questions, by first selecting all columns measuring the same dimension and then creating a new variable as a mean of these columns. This was done earlier in the course.

colnames(learning)

# making the variables deep, surf, and stra

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging
deep_columns <- select(learning, one_of(deep_questions))
learning$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging
surface_columns <- select(learning, one_of(surface_questions))
learning$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging
strategic_columns <- select(learning, one_of(strategic_questions))
learning$stra <-rowMeans(strategic_columns)

colnames(learning)

# Next I will make a subset of the data, dropping out the variables for the questions that were used to compute the new dimension-variables stra, surf and deep. Also, I will exclude observations where Points is 0

learn <- subset(learning, Points!=0, c(gender, Age, Attitude, deep, stra, surf, Points))
dim(learn) # 166 observations of 7 variables
colnames(learn)
learn %>% glimpse

## For the logistic regression I need to compute a binary outcome variable. I choose to make a new logical column "high_points", by computing first the average and then defining everything above average as high and everything below average as low. 

learn$Points %>% mean##22.7
learn <- mutate(learn, high_points = Points > 22)

#I can now use this data to ananlyse the relationsship of both binary and continous explanatory variables on the binary outcome of scoring high or low points in the exam.

# save as .rds in repository
saveRDS(learn, file= "learn.Rds")

