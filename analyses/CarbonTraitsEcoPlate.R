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


cutoff <- function(avg= "avg.water", sd = "sd.water", vals){

  # should also return the error
  # mean, error, sd, should be based on resource qualified as being used

  cutoff <- 2*sd
  num <- 0

  for (val in vals){
    if (val >= avg+cutoff){
      num = num + 1
    }
  }
  return(num)
}

file.path <- "./data/cleaned/"

file.names <- list.files(path = file.path, all.files=FALSE,
                         full.names=FALSE, ignore.case=FALSE, include.dirs=FALSE)

# read in ancestor files and grab average water use value
# Length must equal number of strain IDs in folder
water.vals <- vector(mode="list", length=4)
# create a list of unique identifiers by combining the id and duration
# All strains in the data folder must be on this line
names(water.vals) <- c('0711.24', '0711.48', '0723.48', '0703.48')


for (name in file.names){
  file.name.info <- strsplit(name, "\\.") # split file name
  sp.id <- file.name.info[[1]][2] # organism ID
  AorD <- file.name.info[[1]][3] # ancestral or derived
  duration <- file.name.info[[1]][6] # 24 or 48 hrs

  if (AorD == 'A'){ # if the strain is ancestral...
    new.name <- paste(sp.id, duration, sep='.')
    dat <- as.matrix(read.table(paste(file.path, name, sep='')))
    avg <- mean(dat[1,1], dat[1,5], dat[1,9])
    index <- match(new.name, names(water.vals))
    water.vals[[index]] <- avg
  }
}



file.path <- "./data/cleaned/"

file.name.data <- c()
for (name in file.names){
  file.name.info <- strsplit(name, "\\.") # split file name
  file.name.info <- file.name.info[[1]][-7]
  sp.id <- file.name.info[[2]] # organism ID
  AorD <- file.name.info[[3]] # ancestral or derived
  duration <- file.name.info[[6]] # 24 or 48 hrs
  data <- as.matrix(read.table(paste(file.path, name, sep='')))

  # Calculate the mean, and sd reading for water
  avg.water <- mean(c(data[1,1], data[1,5], data[1,9]))
  sd.water <- sd(c(data[1,1], data[1,5], data[1,9]))

  # if it's an ancestor file, do not normalize
  if (AorD == 'D'){
    # Remove the background
    # background <- 0.042
    new.name <- paste(sp.id, duration, sep='.')
    index <- match(new.name, names(water.vals))
    norm.val <- water.vals[[index]]

    # Remove background and Normalize the data
    data <- round(data * (norm.val/avg.water), digits = 3)
  }

  i1.vals <- as.numeric(data[,1:4])
  i1.vals <- i1.vals[-1] # removing the single water value
  i1.num <- cutoff(avg.water, sd.water, i1.vals)
  i1.mean <- mean(i1.vals)
  i1.sd <- sd(i1.vals)
  i1.err <- i1.sd/sqrt(length(i1.vals))

  i2.vals <- as.numeric(data[,5:8])
  i2.vals <- i2.vals[-1]
  i2.num <- cutoff(avg = avg.water, sd = sd.water, i2.vals)
  i2.mean <- mean(i2.vals)
  i2.sd <- sd(i2.vals)
  i2.err <- i1.sd/sqrt(length(i2.vals))

  i3.vals <- as.numeric(data[,9:12])
  i3.vals <- i3.vals[-1]
  i3.num <- cutoff(avg = avg.water, sd = sd.water, i3.vals)
  i3.mean <- mean(i3.vals)
  i3.sd <- sd(i3.vals)
  i3.err <- i3.sd/sqrt(length(i3.vals))

  file.name.info <- c(file.name.info, i1.mean, i1.sd, i1.err, i1.num)
  file.name.info <- c(file.name.info, i2.mean, i2.sd, i2.err, i2.num)
  file.name.info <- c(file.name.info, i3.mean, i3.sd, i3.err, i3.num)
  file.name.data <- rbind(file.name.data, file.name.info)
}

sd.water <- sd(c(data[1,1], data[1,5], data[1,9]))
avg.water <- mean(c(data[1,1], data[1,5], data[1,9]))

dat.frame <- data.frame(matrix(unlist(file.name.data),
                               nrow=length(file.names), byrow=FALSE), stringsAsFactors=TRUE)
dat.frame <- setNames(dat.frame, c('data', 'strain', 'evo.type',
                                   'plate', 'plate.replicate', 'duration',
                                   'i1.mean', 'i1.sd', 'i1.err', 'i1.num.resources',
                                   'i2.mean', 'i2.sd', 'i2.err', 'i2.num.resources',
                                   'i3.mean', 'i3.sd', 'i3.err', 'i3.num.resources'))

resource.names <- as.matrix(read.table("./ecoplate.info/resource_matrix.txt"))
mol.groups <- as.matrix(read.table("./ecoplate.info/moleculetype_matrix.txt"))




se <- function(x){sd(x)/sqrt(length(x))}

# First, we need to get our data into a useable table to produce the bargraphs
# Subset the data frame to include data from the first 24 hrs

tp.48 <- subset(dat.frame, dat.frame$duration == 48)
tp.48.dat <- tp.48[,c(2:3, 5, 10, 14, 18)]

m1.48 <- melt(tp.48.dat, id = c("strain","evo.type","plate.replicate"))

# Convert values into numbers
m1.48$value <- as.numeric(as.character(m1.48$value))

# Cast data to produce the mean number of resources for each isolate + sem
use.means <- as.data.frame(cast(m1.48, evo.type + plate.replicate ~ strain, mean))
use.sem <- as.data.frame(cast(m1.48, evo.type + plate.replicate ~ strain, se))





