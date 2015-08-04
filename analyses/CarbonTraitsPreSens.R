################################################################################
#                                                                              #
#  Microbial Carbon Traits PreSens Respiration Analysis                        #
#                                                                              #
#  Written By: Mario Muscarella                                                #
#  Last Update: 03 Aug 2015                                                    #
#                                                                              #
#  This script analyzes the raw respiration data for the carbon traits         #
#  Experiment. The input for each day is that PreSens Oxygen output file.      #
#  This file needs to be a .txt file with O2 in uM.                            #
#                                                                              #
################################################################################

# Set working environment
setwd("~/GitHub/MicrobialCarbonTraits/")
rm(list=ls())

# Inport the function from source file
source("./bin/PreSensRespiration.R")

# Analyze the raw data and save output for each experiment
# Note: headers include experimental description for each experiment

# 6/25/2015 A - Carbon Traits Experiment, M9 Base
# Carbon Source: Glucose
# Samples - A: HMWF005, HMWF006; B: HMWF007, HMWF011;
#           C: HMWF021, HMWF031; D: Empty, Blank
input   <- "./data/Respiration/20150625_BacterialRespiration_a_MEM_Oxygen.txt"
output  <- "./data/Respiration/20150625_BacterialRespiration_a_MEM_Output.txt"
in.name <- c(rep("HMWF005", 3), rep("HMWF006", 3), rep("HMWF007", 3),
             rep("HMWF011", 3), rep("HMWF021", 3), rep("HMWF031", 3),
             rep("Empty",   3), rep("Blank",   3))
PreSens.Respiration2(infile = input, outfile = output, start = 0.5,
                     end = 1.5, name.in = in.name)

# 6/25/2015 B - Carbon Traits Experiment, M9 Base
# Carbon Source: Glucose
# Samples - A: HMWF010, HMWF032; B: HMWF034, Empty;
#           C: Empty, Empty; D: Empty, Blank
input   <- "./data/Respiration/20150625_BacterialRespiration_b_MEM_Oxygen.txt"
output  <- "./data/Respiration/20150625_BacterialRespiration_b_MEM_Output.txt"
in.name <- c(rep("HMWF010", 3), rep("HMWF032", 3), rep("HMWF034", 3),
             rep("Empty",   3), rep("Empty",   3), rep("Empty",   3),
             rep("Empty",   3), rep("Blank",   3))
PreSens.Respiration2(infile = input, outfile = output, start = 0.2,
                     end = 1.2, name.in = in.name)

# 6/28/2015 A - Carbon Traits Experiment, M9 Base
# Carbon Source: Succinate
# Samples - A: HMWF005, HMWF006; B: HMWF007, HMWF011;
#           C: HMWF021, HMWF031; D: Empty, Blank
input   <- "./data/Respiration/20150628_BacterialRespiration_a_MEM_Oxygen.txt"
output  <- "./data/Respiration/20150628_BacterialRespiration_a_MEM_Output.txt"
in.name <- c(rep("HMWF005", 3), rep("HMWF006", 3), rep("HMWF007", 3),
             rep("HMWF011", 3), rep("HMWF021", 3), rep("HMWF031", 3),
             rep("Empty",   3), rep("Blank",   3))
PreSens.Respiration2(infile = input, outfile = output, start = 0.2,
                     end = 1.2, name.in = in.name)

# 6/28/2015 B - Carbon Traits Experiment, M9 Base
# Carbon Source: Succinate
# Samples - A: HMWF010, HMWF032; B: HMWF034, Empty;
#           C: Empty, Empty; D: Empty, Blank
input   <- "./data/Respiration/20150628_BacterialRespiration_b_MEM_Oxygen.txt"
output  <- "./data/Respiration/20150628_BacterialRespiration_b_MEM_Output.txt"
in.name <- c(rep("HMWF010", 3), rep("HMWF032", 3), rep("HMWF034", 3),
             rep("Empty",   3), rep("Empty",   3), rep("Empty",   3),
             rep("Empty",   3), rep("Blank",   3))
PreSens.Respiration2(infile = input, outfile = output, start = 0.2,
                     end = 1.2, name.in = in.name)

# 6/30/2015 A - Carbon Traits Experiment, M9 Base
# Carbon Source: Protocatechuate
# Samples - A: HMWF005, HMWF006; B: HMWF007, HMWF031;
#           C: Empty, Empty: D: Empty, Blank
input   <- "./data/Respiration/20150630_BacterialRespiration_a_MEM_Oxygen.txt"
output  <- "./data/Respiration/20150630_BacterialRespiration_a_MEM_Output.txt"
in.name <- c(rep("HMWF005", 3), rep("HMWF006", 3), rep("HMWF007", 3),
             rep("HMWF031", 3), rep("Empty",   3), rep("Empty",   3),
             rep("Empty",   3), rep("Blank",   3))
PreSens.Respiration2(infile = input, outfile = output, start = 0.2,
                     end = 1.2, name.in = in.name)

# 6/30/2015 B - Carbon Traits Experiment, M9 Base
# Carbon Source: Protocatechuate
# Samples - A: HMWF010, HMWF011; B: HMWF021, HMWF032;
#           C: HMWF034, Empty; D: Empty, Blank
input   <- "./data/Respiration/20150630_BacterialRespiration_b_MEM_Oxygen.txt"
output  <- "./data/Respiration/20150630_BacterialRespiration_b_MEM_Output.txt"
in.name <- c(rep("HMWF010", 3), rep("HMWF011", 3), rep("HMWF021", 3),
             rep("HMWF032", 3), rep("HMWF034", 3), rep("Empty",   3),
             rep("Empty",   3), rep("Blank",   3))
PreSens.Respiration2(infile = input, outfile = output, start = 0.2,
                     end = 1.2, name.in = in.name)

# 7/08/2015 A - Carbon Traits Experiment, M9 Base
# Carbon Source: Glucose
# Samples - A: HMWF003, HMWF014; B: HMWF015, HMWF016;
#           C: HMWF017, HMWF022, D: HMWF036, Blank
input   <- "./data/Respiration/20150708_BacterialRespiration_a_MEM_Oxygen.txt"
output  <- "./data/Respiration/20150708_BacterialRespiration_a_MEM_Output.txt"
in.name <- c(rep("HMWF003", 3), rep("HMWF014", 3), rep("HMWF015", 3),
             rep("HMWF016", 3), rep("HMWF017", 3), rep("HMWF022", 3),
             rep("HMWF036", 3), rep("Blank", 3))
PreSens.Respiration2(infile = input, outfile = output, start = 0,
                     end = 1, name.in = in.name)

# 7/08/2015 B - Carbon Traits Experiment, M9 Base
# Carbon Source: Glucose
# Samples - A: HMWF004, HMWF008; B: HMWF009, HMWF018;
#           C: HMWF023, HMWF025; D: HMWF029, Blank
input   <- "./data/Respiration/20150708_BacterialRespiration_b_MEM_Oxygen.txt"
output  <- "./data/Respiration/20150708_BacterialRespiration_b_MEM_Output.txt"
in.name <- c(rep("HMWF004", 3), rep("HMWF008", 3), rep("HMWF009", 3),
             rep("HMWF018", 3), rep("HMWF023", 3), rep("HMWF025", 3),
             rep("HMWF029", 3), rep("Blank",   3))
PreSens.Respiration2(infile = input, outfile = output, start = 0,
                     end = 1, name.in = in.name)

# 7/09/2015 A - Carbon Traits Experiment, M9 Base
# Carbon Source: Succinate
# Samples - A: HWMF004, HMWF014; B: HMWF016, HMWF017;
#           C: HMWF018, HMWF029; D: HMWF036, Blank
input   <- "./data/Respiration/20150709_BacterialRespiration_a_MEM_Oxygen.txt"
output  <- "./data/Respiration/20150709_BacterialRespiration_a_MEM_Output.txt"
in.name <- c(rep("HWMF004", 3), rep("HMWF014", 3), rep("HMWF016", 3),
             rep("HMWF017", 3), rep("HMWF018", 3), rep("HMWF029", 3),
             rep("HMWF036", 3), rep("Blank", 3))
PreSens.Respiration2(infile = input, outfile = output, start = 0.1,
                     end = 1.1, name.in = in.name)

# 7/09/2015 B - Carbon Traits Experiment, M9 Base
# Carbon Source: Succinate
# Samples - A: HMWF003, HMWF008; B: HMWF009, HMWF015;
#           C: HMWF022, HMWF023; D: HMWF025, Blank
input   <- "./data/Respiration/20150709_BacterialRespiration_b_MEM_Oxygen.txt"
output  <- "./data/Respiration/20150709_BacterialRespiration_b_MEM_Output.txt"
in.name <- c(rep("HMWF003", 3), rep("HMWF008", 3), rep("HMWF009", 3),
             rep("HMWF015", 3), rep("HMWF022", 3), rep("HMWF023", 3),
             rep("HMWF025", 3), rep("Blank", 3))
PreSens.Respiration2(infile = input, outfile = output, start = 0,
                     end = 1, name.in = in.name)

# 7/29/2015 - Carbon Traits Experiment, M9 Base
# Carbon Source: Protocatechuate
# Samples A: HMWF003, HMWF013; B: HMWF015, HMWF016;
#         C: HMWF017, HMWF022; D: HMWF036, Blank
input  <-  "./data/Respiration/20150729_BacterialRespiration_a_MEM_Oxygen.txt"
output <-  "./data/Respiration/20150729_BacterialRespiration_a_MEM_Output.txt"
in.name <- c(rep("HMWF003", 3), rep("HMWF013", 3), rep("HMWF015", 3),
             rep("HMWF016", 3), rep("HMWF017", 3), rep("HMWF022", 3),
             rep("HMWF036", 3), rep("Blank", 3))
PreSens.Respiration2(infile = input, outfile = output, start = 0,
                     end = 1, name.in = in.name)

# 7/30/2015 - Carbon Traits Experiment, M9 Base
# Carbon Source: Protocatechuate
# Samples - A: HMWF004, HMWF008; B: HMWF009, HMWF018;
#           C: HMWF023, HMWF035; D: HMWF029, Blank
input  <-  "./data/Respiration/20150730_BacterialRespiration_a_MEM_Oxygen.txt"
output <-  "./data/Respiration/20150730_BacterialRespiration_a_MEM_Output.txt"
in.name <- c(rep("HMWF004", 3), rep("HMWF008", 3), rep("HMWF009", 3),
             rep("HHMWF018", 3), rep("HMWF023", 3), rep("HMWF035", 3),
             rep("HMWF029", 3), rep("Blank", 3))
PreSens.Respiration2(infile = input, outfile = output, start = 0,
                     end = 1, name.in = in.name)
