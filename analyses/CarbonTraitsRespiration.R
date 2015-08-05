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
se <- function(x){sd(x)/sqrt(length(x))}
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



