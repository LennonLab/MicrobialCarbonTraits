################################################################################
# EcoPlate Data Input From Synergy MX                                          #
#                                                                              #
#	Written by M. Muscarella                                                     #
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
  data.in <- read.table(input, skip=skip, header=F, row.names=1)
  data.in <- data.in[,1:12]
  colnames(data.in) <- as.character(seq(1, 12, 1))
  return(data.out)
  }

