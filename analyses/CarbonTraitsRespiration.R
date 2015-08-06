################################################################################
#                                                                              #
#	Microbial Carbon Traits Bacterial Respiration Experiments                    #
#   Analysis Respiration Data from PreSens Output                              #
#                                                                              #
################################################################################
#                                                                              #
#	Written by: Mario Muscarella                                                 #
#                                                                              #
#	Last update: 2015/08/05                                                      #
#                                                                              #
################################################################################

# Setup Work Environment
rm(list=ls())
setwd("~/GitHub/MicrobialCarbonTraits")
sem <- function(x){sd(na.omit(x))/sqrt(length(na.omit(x)))}
require(reshape)

# Import BR Data
file.path <- "./data/Respiration/"
file.names <- list.files(path = file.path, all.files=FALSE, include.dirs=FALSE,
                         pattern = "\\MEM_Output.txt$", full.names=FALSE,
                         ignore.case=FALSE)

br.names <- rep("NA" , length(file.names))
for (i in 1:length(file.names)){
  br.name <- paste("BR_", substr(file.names[i], 1, 8), "_", i, sep="")
  br.names[i] <- br.name
  temp <- read.csv(paste(file.path, file.names[i], sep= ""), header=T)
  colnames(temp) <- c("Sample", "Start", "End", "Rate", "R2", "P")
  assign(br.name, temp)
}

# Import Cell Count Data
file.path <- "./data/CellCounts/"
file.names <- list.files(path = file.path, all.files=FALSE, include.dirs=FALSE,
                         pattern = "\\CellCounts_MEM.txt$", full.names=FALSE,
                         ignore.case=FALSE)

count.names <- rep("NA" , length(file.names))
for (i in 1:length(count.names)){
  count.name <- paste("Count_", substr(file.names[i], 1, 8), "_", i, sep="")
  count.names[i] <- count.name
  temp <- read.delim(paste(file.path, file.names[i], sep= ""), header=T)
  colnames(temp) <- c("Organism", "Plate", "Colonies")
  assign(count.name, temp)
}

# Combine Each Dataset
BR <- as.list(mget(br.names))
Count <- as.list(mget(count.names))

# Calculate Cells Per mL for each Organisms * Time
for (i in 1:length(count.names)){
  Count[[i]]$Conc <- Count[[i]]$Colonies * 10^(-Count[[i]]$Plate) * 10
  for (j in 1:length(Count[[i]]$Conc)){
    if (Count[[i]]$Conc[j] == 0) {
    Count[[i]]$Conc[j] = NA
    }
  }
}

# Define Resource For Each Dataset
for (i in 1:length(br.names)){
  if (substr(br.names[i], 8, 11) == "0625"){
    BR[[i]] <- cbind(BR[[i]], Resource = "Glucose")
  }
  if (substr(br.names[i], 8, 11) == "0628"){
    BR[[i]] <- cbind(BR[[i]], Resource = "Succinate")
  }
  if (substr(br.names[i], 8, 11) == "0630"){
    BR[[i]] <- cbind(BR[[i]], Resource = "Protocatechuate")
  }
  if (substr(br.names[i], 8, 11) == "0708"){
    BR[[i]] <- cbind(BR[[i]], Resource = "Glucose")
  }
  if (substr(br.names[i], 8, 11) == "0709"){
    BR[[i]] <- cbind(BR[[i]], Resource = "Succinate")
  }
  if (substr(br.names[i], 8, 11) == "0729"){
    BR[[i]] <- cbind(BR[[i]], Resource = "Protocatechuate")
  }
  if (substr(br.names[i], 8, 11) == "0730"){
    BR[[i]] <- cbind(BR[[i]], Resource = "Protocatechuate")
  }
}

# Correct Negative Rates
for (i in 1:length(br.names)){
  for (j in 1:length(BR[[i]]$Rate)){
    if (BR[[i]]$Rate[j] < 0) {
      BR[[i]]$Rate[j] = 0
      }
  }
}

# Create New Data Frame
BR.data <- as.data.frame(matrix(NA, 23, 28))
colnames(BR.data) <- c("Organism", "Conc_Glu", "Conc_Suc", "Conc_Pro", "Glu_1",
                       "Glu_2", "Glu_3", "Suc_1", "Suc_2", "Suc_3", "Pro_1",
                       "Pro_2", "Pro_3", "Glu_1c", "Glu_2c", "Glu_3c", "Suc_1c",
                       "Suc_2c", "Suc_3c", "Pro_1c", "Pro_2c", "Pro_3c", "Glu_mean",
                       "Glu_se", "Suc_mean", "Suc_se", "Pro_mean", "Pro_se")
head(BR.data)

# Add Organisms Names
orgs <- unique(c(levels(BR[[1]]$Sample), levels(BR[[2]]$Sample),
                 levels(BR[[7]]$Sample), levels(BR[[8]]$Sample)))
BR.data$Organism <- sort(orgs[orgs != "Blank"])

# Add Cell Density
GluCount <- rbind(Count[[1]], Count[[4]])
BR.data$Conc_Glu <- GluCount[order(GluCount$Organism),4]

SucCount <- rbind(Count[[2]], Count[[5]])
BR.data$Conc_Suc <- SucCount[order(SucCount$Organism),4]

ProCount <- rbind(Count[[3]], Count[[6]], Count[[7]])
BR.data$Conc_Pro <-ProCount[order(ProCount$Organism),4]

# Add Raw Respiration
GluResp <- rbind(BR[[1]], rbind(BR[[2]]), rbind(BR[[7]], BR[[8]]))
GluResp <- GluResp[GluResp$Sample != "Blank", ]
for (i in BR.data$Organism){
  BR.data[which(BR.data$Organism == i), 5:7] <- GluResp[GluResp$Sample == i, ]$Rate
}

SucResp <- rbind(BR[[3]], rbind(BR[[4]]), rbind(BR[[9]], BR[[10]]))
SucResp <- SucResp[SucResp$Sample != "Blank", ]
for (i in BR.data$Organism){
  BR.data[which(BR.data$Organism == i), 8:10] <- SucResp[SucResp$Sample == i, ]$Rate
}

ProResp <- rbind(BR[[5]], rbind(BR[[6]]), rbind(BR[[11]], BR[[12]]))
ProResp <- ProResp[ProResp$Sample != "Blank", ]
for (i in BR.data$Organism){
  BR.data[which(BR.data$Organism == i), 11:13] <- ProResp[ProResp$Sample == i, ]$Rate
}

# Correct for Cell Concentration and Change Units to Pico molar
head(BR.data)

BR.data[, 14:16] <- round(BR.data[,5:7]   * 10^6 / BR.data$Conc_Glu, 3)
BR.data[, 17:19] <- round(BR.data[,8:10]  * 10^6 / BR.data$Conc_Suc, 3)
BR.data[, 20:22] <- round(BR.data[,11:13] * 10^6 / BR.data$Conc_Pro, 3)

# Calculate Average and SEM
BR.data$Glu_mean <- round(apply(BR.data[, 14:16], 1, mean), 3)
BR.data$Suc_mean <- round(apply(BR.data[, 17:19], 1, mean), 3)
BR.data$Pro_mean <- round(apply(BR.data[, 20:22], 1, mean), 3)

BR.data$Glu_se <- round(apply(BR.data[, 14:16], 1, sem), 3)
BR.data$Suc_se <- round(apply(BR.data[, 17:19], 1, sem), 3)
BR.data$Pro_se <- round(apply(BR.data[, 20:22], 1, sem), 3)

# Export Data
write.csv(BR.data[, c(1, 14:28)], file="./data/CarbonTraits/BR_data.txt",
          quote=FALSE, row.names=FALSE)
