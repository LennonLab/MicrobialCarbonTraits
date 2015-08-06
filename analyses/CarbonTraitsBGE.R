################################################################################
#                                                                              #
#	Microbial Carbon Traits: Bacterial Growth Efficiency                         #
#   This script produces BR, BP, and BGE Graphs                                #
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

# Import Data
BP <- read.csv(file="./data/CarbonTraits/BP_data.txt")
BR <- read.csv(file="./data/CarbonTraits/BR_data.txt")

# Import Phylogeny
