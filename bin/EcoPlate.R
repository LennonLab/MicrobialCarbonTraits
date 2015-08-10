################################################################################
# EcoPlate Data Input From Synergy MX                                          #
#                                                                              #
#	Written by M. Muscarella  & Lennon Lab                                       #
#                                                                              #
#	Last update: 8/9/15                                                          #
#                                                                              #
# Features:                                                                    #
#   Reads in the datatable from the symergy mx machine                         #
#   Selects only the matrix of plate data                                      #
#   Converts time to minutes                                                   #
#   Checks the type of all values & changes to numeric if needed               #
#   Outputs data matric {Time, Temp, Well...                                   #
################################################################################

read.ecoplate <- function(input = " ", skip = "32"){
  data <- read.table(input, skip=skip, header=F, row.names=1)
  data <- data[,1:12]
  colnames(data) <- as.character(seq(1, 12, 1))
  return(data)
}

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

