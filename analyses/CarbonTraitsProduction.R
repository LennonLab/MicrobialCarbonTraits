################################################################################
#                                                                              #
#	Microbial Carbon Traits Bacterial Production Experiments                     #
#   Analysis Production Data from Leucine Experiment                           #
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

# Import BP Data
file.path <- "./data/Production/"
file.names <- list.files(path = file.path, all.files=FALSE, include.dirs=FALSE,
                         pattern = "\\Production_MEM.txt$", full.names=FALSE,
                         ignore.case=FALSE)

# Remove first
file.names <- file.names[-1]

bp.names <- rep("NA" , length(file.names))
for (i in 1:length(file.names)){
  bp.name <- paste("BP_", substr(file.names[i], 1, 8), "_", i, sep="")
  bp.names[i] <- bp.name
  temp <- read.delim(paste(file.path, file.names[i], sep= ""), header=T)
  colnames(temp) <- c("Sample", "CPM")
  assign(bp.name, temp)
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
BP <- as.list(mget(bp.names))
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
for (i in 1:length(bp.names)){
  if (substr(bp.names[i], 8, 11) == "0625"){
    BP[[i]] <- cbind(BP[[i]], Resource = "Glucose")
  }
  if (substr(bp.names[i], 8, 11) == "0628"){
    BP[[i]] <- cbind(BP[[i]], Resource = "Succinate")
  }
  if (substr(bp.names[i], 8, 11) == "0630"){
    BP[[i]] <- cbind(BP[[i]], Resource = "Protocatechuate")
  }
  if (substr(bp.names[i], 8, 11) == "0708"){
    BP[[i]] <- cbind(BP[[i]], Resource = "Glucose")
  }
  if (substr(bp.names[i], 8, 11) == "0709"){
    BP[[i]] <- cbind(BP[[i]], Resource = "Succinate")
  }
  if (substr(bp.names[i], 8, 11) == "0729"){
    BP[[i]] <- cbind(BP[[i]], Resource = "Protocatechuate")
  }
  if (substr(bp.names[i], 8, 11) == "0730"){
    BP[[i]] <- cbind(BP[[i]], Resource = "Protocatechuate")
  }
}


# BP Calculations
for (i in 1:length(bp.names)){
  BP[[i]]$DPM <- BP[[i]]$CPM/0.64
  BP[[i]]$DPMc <- BP[[i]]$DPM - 2000/0.64 # Fix later
  BP[[i]]$Leucine <- ((BP[[i]]$DPMc / 2.2e12) / 153) / 1000
  # DPM*1Ci/2.2e12DPM *1mmolLeu/153Ci * 1molLeu/1000mmol
  BP[[i]]$Leucine.per <- (BP[[i]]$Leucine * (1/1) * (1/0.0015))
  # Leu incorporated * 1/time (hrs) * 1/vol (L)
  BP[[i]]$Protein <- ( BP[[i]]$Leucine.per / 0.073 ) * 131.2
  # mol leu * 1 mol protein/0.073 mol leu * 131.2 g protein/1mol protein
  BP[[i]]$Carbon <- BP[[i]]$Protein * (1/0.63) * (0.54/1) * (10^6)
  # g protein * 1 g DW/0.63 g Pro * 0.54 g C/1g DW = gC/l/hr  * 10^6 = ugC/L/Hr
  BP[[i]]$Carbon.uM <- BP[[i]]$Carbon * 0.083333 # conversion of g to m
  BP[[i]]$Carbon.pM <- BP[[i]]$Carbon.uM * 10^6
}

# Create New Data Frame
BP.data <- as.data.frame(matrix(NA, 23, 28))
colnames(BP.data) <- c("Organism", "Conc_Glu", "Conc_Suc", "Conc_Pro", "Glu_1",
                       "Glu_2", "Glu_3", "Suc_1", "Suc_2", "Suc_3", "Pro_1",
                       "Pro_2", "Pro_3", "Glu_1c", "Glu_2c", "Glu_3c", "Suc_1c",
                       "Suc_2c", "Suc_3c", "Pro_1c", "Pro_2c", "Pro_3c", "Glu_mean",
                       "Glu_se", "Suc_mean", "Suc_se", "Pro_mean", "Pro_se")
head(BP.data)

# Add Organisms Names
orgs <- unique(c(levels(BP[[1]]$Sample), levels(BP[[4]]$Sample)))
for (i in 1:length(orgs)){
  orgs[i] <- strsplit(orgs[[i]], "_")[[1]][1]
}
orgs <- unique(orgs[orgs != "Background"])
BP.data$Organism <- sort(orgs[orgs != "Voucher"])

# Add Cell Density
GluCount <- rbind(Count[[1]], Count[[4]])
BP.data$Conc_Glu <- GluCount[order(GluCount$Organism),4]

SucCount <- rbind(Count[[2]], Count[[5]])
BP.data$Conc_Suc <- SucCount[order(SucCount$Organism),4]

ProCount <- rbind(Count[[3]], Count[[6]], Count[[7]])
BP.data$Conc_Pro <-ProCount[order(ProCount$Organism),4]

# Add Raw Production
GluProd <- rbind(BP[[1]], BP[[4]])
GluProd <- GluProd[GluProd$Sample != "Background", ]
GluProd <- GluProd[GluProd$Sample != "Voucher", ]
for (i in BP.data$Organism){
  BP.data[which(BP.data$Organism == i), 5:7] <- GluProd[GluProd$Sample == i, ]$Carbon.pM
}

SucProd <- rbind(BP[[2]], BP[[5]])
SucProd <- SucProd[SucProd$Sample != "Background", ]
SucProd <- SucProd[SucProd$Sample != "Voucher", ]
for (i in BP.data$Organism){
  BP.data[which(BP.data$Organism == i), 8:10] <- SucProd[SucProd$Sample == i, ]$Carbon.pM
}

ProProd <- rbind(BP[[3]], BP[[6]])
ProProd <- ProProd[ProProd$Sample != "Background", ]
ProProd <- ProProd[ProProd$Sample != "Voucher", ]
for (i in BP.data$Organism){
  BP.data[which(BP.data$Organism == i), 11:13] <- ProProd[ProProd$Sample == i, ]$Carbon.pM
}

# Correct for Cell Concentration
BP.data[, 14:16] <- round(BP.data[,5:7]  / (BP.data$Conc_Glu), 3)
BP.data[, 17:19] <- round(BP.data[,8:10]  / (BP.data$Conc_Suc), 3)
BP.data[, 20:22] <- round(BP.data[,11:13] / (BP.data$Conc_Pro), 3)

# Calculate Average and SEM
BP.data$Glu_mean <- round(apply(BP.data[, 14:16], 1, mean), 3)
BP.data$Suc_mean <- round(apply(BP.data[, 17:19], 1, mean), 3)
BP.data$Pro_mean <- round(apply(BP.data[, 20:22], 1, mean), 3)

BP.data$Glu_se <- round(apply(BP.data[, 14:16], 1, sem), 3)
BP.data$Suc_se <- round(apply(BP.data[, 17:19], 1, sem), 3)
BP.data$Pro_se <- round(apply(BP.data[, 20:22], 1, sem), 3)

# Export Data
write.csv(BP.data[, c(1, 14:28)], file="./data/CarbonTraits/BP_data.txt",
          quote=FALSE, row.names=FALSE)
