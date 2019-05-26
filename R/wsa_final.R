# Getting starting time
start_time <- Sys.time()

###############################################################
## Part 1: Setting up working directory, files and libraries ##
###############################################################

# Setting working directory
setwd("C:\\Users\\Maxime\\Documents\\UNIL 2018-2019\\2. Printemps\\Webscale Analytics\\Projet\\Données")

# Getting PGA Tour data from csv file
data_file <- read.csv(file="pgatour_cleaned.csv", header=TRUE, sep=",")

# Loading libraries
library(car)
library(RcmdrMisc)
library(multcomp)
library(FactoMineR)
library(paran)



#########################################
## Part 2: Creating subsets and factor ##
#########################################

# Subset of 2007-2016
data_ten <- data_file[which(data_file$Year>=2007 & data_file$Year<=2016),]

# Subset of 2016
data_sixteen <- data_file[which(data_file$Year == 2016),]

# Subset of 2017
data_seventeen <- data_file[which(data_file$Year == 2017),]

# Subset containing 2007, 2012 and 2017
data_anova <- subset(data_file, subset=Year == 2007 | Year == 2012 | Year == 2017)

# Creating year factor for data_anova subset
data_anova <- within(data_anova, {
  YearF <- as.factor(Year)
})

# Creating a standardized 2017 subset for clustering
data_seventeen_z <- as.data.frame(scale(data_seventeen[,c(3,4,5,6,7,8,9,10,11,12,13,15)]))
# Adding names column to the standardized dataframe
data_seventeen_z$NAME = data_seventeen$NAME

# Numeric subset for Principal Component Analysis
data_pca <- data_seventeen[,c(2,3,4,5,6,7,8,9,10,11,12,13,15)]
row.names(data_pca) <- as.character(data_pca$NAME)
data_pca$NAME <- NULL



###################################
## Part 3: Dataset quick summary ##
###################################

# Full dataset summary (mean, median, ...)
summary(data_file)

# Full dataset correlation matrix with p-value for each correlation
rcorr.adjust(data_file[,c("DRIVE_DISTANCE","FWY_.","GIR_.","MONEY","POINTS",
                          "ROUNDS","SCORING","SG_P","SG_T","SG_TTG","TOP.10","X1ST")], type="pearson",
             use="complete")



##########################
## Part 4: Scatter plot ##
##########################

# Preparing pdf file to save the scatter plot
pdf("C:\\Users\\Maxime\\Documents\\UNIL 2018-2019\\2. Printemps\\Webscale Analytics\\Projet\\scatterplot.pdf", width=7, height=7, paper='special')

# Scatter plot: driving distance - # of top 10
scatterplot(TOP.10~DRIVE_DISTANCE, regLine=TRUE, smooth=FALSE, 
            boxplots=FALSE, data=data_file, legend=TRUE, xlab="TOP 10", ylab="Driving distance", main="Scatter plot Top 10 - Driving distance")

# Saving pdf file
dev.off()



#########################################################################################################
## Part 5: ANOVA to see if there's a difference between 2007, 2012 and 2017 concerning the prize money ##
#########################################################################################################

# Computing ANOVA model Money ~ Year
AnovaModel.1 <- aov(MONEY ~ YearF, data=data_anova)

# ANOVA model values
summary(AnovaModel.1)

# Post-hoc pairwise tests
local({
  .Pairs <- glht(AnovaModel.1, linfct = mcp(YearF = "Tukey"))
  print(summary(.Pairs))
})



########################
## Part 6: Clustering ##
########################

# Clustering based on all the numerical variables for 2017
HClust.1 <- hclust(dist(model.matrix(~-1 +   DRIVE_DISTANCE+FWY_.+GIR_.+MONEY+POINTS+ROUNDS+SCORING+SG_P+SG_T+SG_TTG+TOP.10+X1ST, data_seventeen_z)) , method= "ward.D")

# Preparing pdf file to save the clustering
pdf("C:\\Users\\Maxime\\Documents\\UNIL 2018-2019\\2. Printemps\\Webscale Analytics\\Projet\\clusterting.pdf", width=30, height=7, paper='special')

# Clustering's plot
plot(HClust.1, main= "Cluster Dendrogram for PGA Tour 2017", xlab= "Players names", sub="Method=ward; Distance=euclidian", labels=data_seventeen_z$NAME)

# Saving pdf file
dev.off()



#################################
## Part 7: Linear regression ##
#################################

# Full linear model
full_linear_model <- lm(POINTS ~ ROUNDS + SCORING + DRIVE_DISTANCE + FWY_. + GIR_. + SG_P + SG_TTG + SG_T + TOP.10 + X1ST, data = data_ten)

# Model summary
summary(full_linear_model)

# Significative variables are:
# - ROUNDS (p =~ 0.002)
# - SCORING (p < 0.001)
# - DRIVE_DISTANCE (p =~ 0.031)
# - TOP.10 (p < 0.01)

# Reduced linear model
min_linear_model <- lm(POINTS ~ ROUNDS + SCORING + GIR_. + TOP.10 + X1ST, data = data_ten)

# Reduced model summary
summary(min_linear_model)

# ANOVA to compare the two models
# The reduced model summary is sufficient (p < 0.001)
anova(min_linear_model, full_linear_model)

# Predicting 2017 PGA Tour ranking
# Creating dataframe containing only predicting variables
min_data_frame <- data_seventeen[,c(3,4,5,7,12,13)]

# Predict values for 2017 with full model
full_data_frame <- data_seventeen[,c(3,4,5,6,7,8,9,10,11,12,13)]
seventeen_full_predict <- predict(full_linear_model, full_data_frame)
write.csv(seventeen_full_predict, file = "seventeen_final_full.csv")

# Predict values for 2017
seventeen_predict <- predict(min_linear_model, min_data_frame)
# Saving values in a csv file
write.csv(seventeen_predict, file = "seventeen_final_min.csv")



##########################################
## Part 8: Principal Component Analysis ##
##########################################

# Preparing pdf file to save the parallel analysis
pdf("C:\\Users\\Maxime\\Documents\\UNIL 2018-2019\\2. Printemps\\Webscale Analytics\\Projet\\parallel_analysis.pdf", width=10, height=10, paper='special')

# Parallel analysis to find out how much components should be retained
paran(data_pca, graph=TRUE, centile=95)
# 3 components should be retained

# Saving pdf file
dev.off()

# Preparing pdf file to save the PCA
pdf("C:\\Users\\Maxime\\Documents\\UNIL 2018-2019\\2. Printemps\\Webscale Analytics\\Projet\\pca.pdf", width=15, height=10, paper='special')

# Large view of pca
#pdf("C:\\Users\\Maxime\\Documents\\UNIL 2018-2019\\2. Printemps\\Webscale Analytics\\Projet\\pca_large.pdf", width=20, height=10, paper='special')

# Principal component analysis
PCA(data_pca, scale.unit = TRUE, ncp = 3, ind.sup = NULL,
    quanti.sup = NULL, quali.sup = NULL, row.w = NULL,
    col.w = NULL, graph = TRUE, axes = c(1,2))

# Saving pdf file
dev.off()




# Getting end time
end_time <- Sys.time()

# Getting time needed to run the statistical analysis
time_spent <- end_time - start_time
print(time_spent)