################################################################################
#                                                                              #
#	Microbial Carbon Traits: Bacterial Growth Efficiency                         #
#                                                                              #
################################################################################
#                                                                              #
#	Written by: Mario Muscarella                                                 #
#                                                                              #
#	Last update: 2015/07/27                                                      #
#                                                                              #
################################################################################

# Setup Work Environment
rm(list=ls())
setwd("~/GitHub/MicrobialCarbonTraits/")
se <- function(x){sd(x)/sqrt(length(x))}


# Import Bacterial Production Data
bp.glu1 <- read.delim("./data/Production/20150625_BacterialProduction_MEM.txt", header=T)
bp.glu2 <- read.delim("./data/Production/20150708_BacterialProduction_MEM.txt", header=T)
bp.suc1 <- read.delim("./data/Production/20150628_BacterialProdcution_MEM.txt", header=T)
bp.suc2 <- read.delim("./data/Production/20150709_BacterialProduction_MEM.txt", header=T)
bp.pro1 <- read.delim("./data/Production/20150630_BacterialProduction_MEM.txt", header=T)


# Import Bacterial Respiration Data
br.glu1 <- read.csv("./data/Respiration/20150625_BacterialRespiration_a_MEM_Output.txt", header=T)
br.glu2 <- read.csv("./data/Respiration/20150708_BacterialRespiration_a_MEM_Output.txt", header=T)
br.suc1 <- read.csv("./data/Respiration/")
br.suc2
br.pro1

# Import Cell Abundance Data
