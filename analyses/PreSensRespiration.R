################################################################################
#                                                                              #
#  Bacterial RespirationTest Script for Analysis of PreSens Respiration Data   #
#   Version 2.0                                                                #
#  Written By: Mario Muscarella                                                #
#  Last Update: 28 Jan 2014                                                    #
#                                                                              #
#  Use this file to test the PreSens.Respiration fucntion on local machine     #
#  And as a template to create your own analysis                               #
#                                                                              #
################################################################################

setwd('~/GitHub/MicrobialCarbonTraits/analyses')
rm(list=ls())

# Inport the function from source file
source("../bin/PreSensInteractiveRegression.r")

# Samples: A1-A3 = HMWF001+C
#          B1-B3 = HMWF002
#          C1-C3 = HMWF002+C
#          A6    = Blank

# Analysis
PreSens.Respiration("../data/20150430_BacterialRespiration_Oxygen.txt",
                    "../data/20150430_BacterialRespiration_Output.txt")


