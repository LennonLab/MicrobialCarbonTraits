################################################################################
#                                                                              #
#	Microbial Carbon Traits: Maple                                               #
#   This script produces Maple data file from raw data                         #
#                                                                              #
################################################################################
#                                                                              #
#	Written by: Mario Muscarella                                                 #
#                                                                              #
#	Last update: 2019/06/09                                                      #
#                                                                              #
################################################################################

# Setup Work Environment
rm(list=ls())
setwd("~/GitHub/MicrobialCarbonTraits/")
sem <- function(x){sd(na.omit(x))/sqrt(length(na.omit(x)))}

library("gdata")

file.path <- "./data/Maple/"

file.names <- list.files(path = file.path, all.files=FALSE,
                         full.names=FALSE, ignore.case=FALSE, include.dirs=FALSE)

file.names <- file.names[grep(".xls", file.names)]

strains <- unlist(lapply(strsplit(file.names, split = "\\."), "[[", 1))

HMWF001.maple <- read.xls("./data/Maple/HMWF001.xls")
HMWF003.maple <- read.xls("./data/Maple/HMWF003.xls")
HMWF004.maple <- read.xls("./data/Maple/HMWF004.xls")
HMWF005.maple <- read.xls("./data/Maple/HMWF005.xls")
HMWF006.maple <- read.xls("./data/Maple/HMWF006.xls")
HMWF007.maple <- read.xls("./data/Maple/HMWF007.xls")
HMWF008.maple <- read.xls("./data/Maple/HMWF008.xls")
HMWF009.maple <- read.xls("./data/Maple/HMWF009.xls")
HMWF010.maple <- read.xls("./data/Maple/HMWF010.xls")
HMWF011.maple <- read.xls("./data/Maple/HMWF011.xls")
HMWF013.maple <- read.xls("./data/Maple/HMWF013.xls")
HMWF014.maple <- read.xls("./data/Maple/HMWF014.xls")
HMWF015.maple <- read.xls("./data/Maple/HMWF015.xls")
HMWF016.maple <- read.xls("./data/Maple/HMWF016.xls")
HMWF017.maple <- read.xls("./data/Maple/HMWF017.xls")
HMWF018.maple <- read.xls("./data/Maple/HMWF003.xls")
HMWF019.maple <- read.xls("./data/Maple/HMWF019.xls")
HMWF021.maple <- read.xls("./data/Maple/HMWF021.xls")
HMWF022.maple <- read.xls("./data/Maple/HMWF022.xls")
HMWF023.maple <- read.xls("./data/Maple/HMWF023.xls")
HMWF025.maple <- read.xls("./data/Maple/HMWF025.xls")
HMWF026.maple <- read.xls("./data/Maple/HMWF026.xls")
HMWF028.maple <- read.xls("./data/Maple/HMWF028.xls")
HMWF029.maple <- read.xls("./data/Maple/HMWF029.xls")
HMWF030.maple <- read.xls("./data/Maple/HMWF030.xls")
HMWF031.maple <- read.xls("./data/Maple/HMWF031.xls")
HMWF032.maple <- read.xls("./data/Maple/HMWF032.xls")
HMWF034.maple <- read.xls("./data/Maple/HMWF034.xls")
HMWF035.maple <- read.xls("./data/Maple/HMWF035.xls")
HMWF036.maple <- read.xls("./data/Maple/HMWF036.xls")

pathways <- c(dim(HMWF001.maple)[1], dim(HMWF003.maple)[1], dim(HMWF004.maple)[1], 
              dim(HMWF005.maple)[1], dim(HMWF006.maple)[1], dim(HMWF007.maple)[1], 
              dim(HMWF008.maple)[1], dim(HMWF009.maple)[1], dim(HMWF010.maple)[1], 
              dim(HMWF011.maple)[1], dim(HMWF013.maple)[1], dim(HMWF014.maple)[1], 
              dim(HMWF015.maple)[1], dim(HMWF016.maple)[1], dim(HMWF017.maple)[1], 
              dim(HMWF018.maple)[1], dim(HMWF019.maple)[1], dim(HMWF021.maple)[1], 
              dim(HMWF022.maple)[1], dim(HMWF023.maple)[1], dim(HMWF025.maple)[1], 
              dim(HMWF026.maple)[1], dim(HMWF028.maple)[1], dim(HMWF029.maple)[1], 
              dim(HMWF030.maple)[1], dim(HMWF031.maple)[1], dim(HMWF032.maple)[1], 
              dim(HMWF034.maple)[1], dim(HMWF035.maple)[1], dim(HMWF036.maple)[1])

length(pathways) == length(strains)
length(unique(pathways))

maple.pathways <- matrix(NA, 305, 5)
all.equal(HMWF001.maple$ID, HMWF003.maple$ID)
maple.pathways <- HMWF001.maple[, c(1:3, 5)]

colnames(maple.pathways) <- c("Large category", "Small category", "ID", "Name")

write.table(maple.pathways, "./data/pathways.txt", 
            row.names = F, quote = F, sep = "\t")


MCR <- as.data.frame(matrix(NA, 30, 305))
rownames(MCR) <- strains
colnames(MCR) <- maple.pathways$ID

for(i in 1:30){
  temp.name <- paste(strains[i], "maple", sep = ".")
  temp <- get(temp.name)
  if(all.equal(as.character(temp$ID), colnames(MCR))){
    MCR[i, ] <- temp$MCR....ITR.
  } else {
    stop("Error")
  }
}

Q.val <- as.data.frame(matrix(NA, 30, 305))
rownames(Q.val) <- strains
colnames(Q.val) <- maple.pathways$ID

for(i in 1:30){
  temp.name <- paste(strains[i], "maple", sep = ".")
  temp <- get(temp.name)
  if(all.equal(as.character(temp$ID), colnames(Q.val))){
    Q.val[i, ] <- temp$Mdule.Q.value..ITR.
  } else {
    stop("Error")
  }
}


write.table(MCR, "./data/Maple.MCR.txt", 
            row.names = T, quote = F, sep = "\t")


write.table(MCR, "./data/Maple.Qval.txt", 
            row.names = T, quote = F, sep = "\t")
