################################################################################
#                                                                              #
#	Microbial Carbon Traits: EcoPlate                                    #
#   This script produces EcoPlate and MAPLE Graphs                             #
#                                                                              #
################################################################################
#                                                                              #
#	Written by: Mario Muscarella                                                 #
#                                                                              #
#	Last update: 2015/08/06                                                      #
#                                                                              #
################################################################################

# Setup Work Environment
rm(list=ls())
setwd("~/GitHub/MicrobialCarbonTraits")
sem <- function(x){sd(na.omit(x))/sqrt(length(na.omit(x)))}

source("./bin/EcoPlate.R")

file.path <- "./data/EcoPlate/"

file.names <- list.files(path = file.path, all.files=FALSE,
                         full.names=FALSE, ignore.case=FALSE, include.dirs=FALSE)

file.names <- file.names[grep("HMWF*", file.names)]

strains <- c()
for (name in file.names){
  file.name.info <- strsplit(name, "\\_") # split file name
  sp.id <- file.name.info[[1]][1]
  strains <- c(strains, sp.id)
  time <- strsplit(file.name.info[[1]][2], "\\.")[[1]][1]
  # Read in only T2 samles
  if (time == "T2"){
    data <- read.ecoplate(input = paste(file.path, name, sep=""), skip=32)
    assign(sp.id, data)
  } else {
  }}

strains <- unique(strains)
resource.names <- as.matrix(read.table("./bin/resource_matrix.txt"))
mol.groups <- as.matrix(read.delim("./bin/moleculetype_matrix.txt", header=F))
resources <- levels(as.factor(resource.names))
r.names <- as.factor(resource.names)[1:32]
c.grouping <- as.factor(mol.groups)[1:32]
group.res <- data.frame(r.names, c.grouping)[-1, ]
resources <- resources[resources != "Water"]

eco.data <- as.data.frame(matrix(NA, nrow = length(strains), ncol = 33))
colnames(eco.data) <- c("Strain", resources, "NumRes")
eco.data$Strain <- strains

for (i in strains){
  data <- get(i)
  avg.water <- mean(c(data[1,1], data[1,5], data[1,9]))
  sd.water <- sd(c(data[1,1], data[1,5], data[1,9]))
  data.corr <- round(data - (avg.water + 1.96 * sd.water), 3)
  data.corr[data.corr <= 0] <- 0
  for (j in resources){
    data.r <- which(eco.data$Strain  == i)
    data.c <- which(colnames(eco.data) == j)
    eco.data[data.r , data.c] <- round(mean(data.corr[resource.names == j]), 3)
    eco.data$NumRes[data.r] <- sum(as.numeric(eco.data[data.r, 2:32]) > 0)
  }
}

write.csv(eco.data, "./data/EcoPlate/eco.data.txt", quote=FALSE, row.names=FALSE)




