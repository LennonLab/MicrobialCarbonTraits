################################################################################
#                                                                              #
#  Bacterial RespirationTest Script for Analysis of PreSens Respiration Data   #
#   Version 2.0                                                                #
#  Written By: Mario Muscarella                                                #
#  Last Update: 24 Jul 2015                                                    #
#                                                                              #
#  Use this file to test the PreSens.Respiration fucntion on local machine     #
#  And as a template to create your own analysis                               #
#                                                                              #
################################################################################

setwd("~/GitHub/MicrobialCarbonTraits/")
rm(list=ls())

# Inport the function from source file
source("./bin/PreSensInteractiveRegression.r")

# Samples: A1-A3 = HMWF001+C
#          B1-B3 = HMWF002
#          C1-C3 = HMWF002+C
#          A6    = Blank

# Respiration Analysis #########################################################
# Experimental Methods Development Samples
################################################################################
# 4/30/2015 - R2B Media; Chloramphenicol Experiment Test
# Samples: A1-A3 = HMWF001+C
#          B1-B3 = HMWF002
#          C1-C3 = HMWF002+C
#          A6    = Blank
PreSens.Respiration("./data/20150430_BacterialRespiration_Oxygen.txt",
                    "./data/20150430_BacterialRespiration_Output.txt")

# 6/17/2015 - R2B Media
# Carbon Source:
# Samples  : A1-A3: HMWF001, A4-A6: HMWF003, B1-B3: HMWF004, B4-B6: HMWF005,
#            C1-C3: HMWF006, C4-C6: HMWF007, D1-D3: HMWF008, D4-D6: Blank

PreSens.Respiration("./data/20150617_BacterialRespiration_a_MEM_Oxygen.txt",
                    "./data/20150617_BacterialRespiration_a_MEM_Output.txt")

# Respiration Analysis #########################################################
# Carbon Triats Experiment
################################################################################

# 6/25/2015 - Carbon Triats Experiment, M9 Base
# Carbon Source: Glucose
# Samples A: A1-A3: HMWF005, A4-A6: HMWF006, B1-B3: HMWF007, B4-B6: HMWF011,
#            C1-C3: HMWF021, C4-C6: HMWF031, D1-D3: Empty,   D4-D6: Blank
# Samples B: A1-A3: HMWF010, A4-A6: HMWF032, B1-B3: HMWF034, B4-B6: Empty,
#            C1-C3: Empty,   C4-C6: Empty,   D1-D3: Empty,   D4-D6: Blank
PreSens.Respiration("./data/Respiration/20150625_BacterialRespiration_a_MEM_Oxygen.txt",
                    "./data/Respiration/20150625_BacterialRespiration_a_MEM_Output.txt")
PreSens.Respiration("./data/Respiration/20150625_BacterialRespiration_b_MEM_Oxygen.txt",
                    "./data/Respiration/20150625_BacterialRespiration_b_MEM_Output.txt")

# 6/28/2015 - Carbon Triats Experiment, M9 Base
# Carbon Source: Succinate
# Samples A: A1-A3: HMWF005, A4-A6: HMWF006, B1-B3: HMWF007, B4-B6: HMWF011,
#            C1-C3: HMWF021, C4-C6: HMWF031, D1-D3: Empty,   D4-D6: Blank
# Samples B: A1-A3: HMWF010, A4-A6: HMWF032, B1-B3: HMWF034, B4-B6: Empty,
#            C1-C3: Empty,   C4-C6: Empty,   D1-D3: Empty,   D4-D6: Blank
PreSens.Respiration("./data/Respiration/20150628_BacterialRespiration_a_MEM_Oxygen.txt",
                    "./data/Respiration/20150628_BacterialRespiration_a_MEM_Output.txt")
PreSens.Respiration("./data/Respiration/20150628_BacterialRespiration_b_MEM_Oxygen.txt",
                    "./data/Respiration/20150628_BacterialRespiration_b_MEM_Output.txt")

# 6/30/2015 - Carbon Triats Experiment, M9 Base
# Carbon Source: Protocatechuate
# Samples A: A1-A3: HMWF005, A4-A6: HMWF006, B1-B3: HMWF007, B4-B6: HMWF031,
#            C1-C3: Empty, C4-C6: Empty, D1-D3: Empty, D4-D6: Blank
# Samples B: A1-A3: HMWF010, A4-A6: HMWF011, B1-B3: HMWF021, B4-B6: HMWF032,
#            C1-C3: HMWF034, C4-C6: Empty, D1-D3: Empty, D4-D6: Blank
PreSens.Respiration("./data/Respiration/20150630_BacterialRespiration_a_MEM_Oxygen.txt",
                    "./data/Respiration/20150630_BacterialRespiration_a_MEM_Output.txt")
PreSens.Respiration("./data/Respiration/20150630_BacterialRespiration_b_MEM_Oxygen.txt",
                    "./data/Respiration/20150630_BacterialRespiration_b_MEM_Output.txt")

# 7/08/2015 - Carbon Triats Experiment, M9 Base
# Carbon Source: Glucose
# Samples A: A1-A3: HMWF003, A4-A6: HMWF014, B1-B3: HMWF015, B4-B6: HMWF016,
#            C1-C3: HMWF017, C4-C6: HMWF022, D1-D3: HMWF036, D4-D6: Blank
# Samples B: A1-A3: HMWF004, A4-A6: HMWF008, B1-B3: HMWF009, B4-B6: HMWF0018,
#            C1-C3: HMWF023, C4-C6: HMWF025, D1-D3: HMWF029, D4-D6: Blank
PreSens.Respiration("./data/Respiration/20150708_BacterialRespiration_a_MEM_Oxygen.txt",
                    "./data/Respiration/20150708_BacterialRespiration_a_MEM_Output.txt")
PreSens.Respiration("./data/Respiration/20150708_BacterialRespiration_b_MEM_Oxygen.txt",
                    "./data/Respiration/20150708_BacterialRespiration_b_MEM_Output.txt")


# 7/09/2015 - Carbon Triats Experiment, M9 Base
# Carbon Source: Succinate
# Samples A: A1-A3: HMWF004, A4-A6: HMWF014, B1-B3: HMWF016, B4-B6: HMWF017,
#            C1-C3: HMWF018, C4-C6: HMWF029, D1-D3: HMWF036, D4-D6: Blank
# Samples B: A1-A3: HMWF003, A4-A6: HMWF008, B1-B3: HMWF009, B4-B6: HMWF0015,
#            C1-C3: HMWF022, C4-C6: HMWF023, D1-D3: HMWF025, D4-D6: Blank
PreSens.Respiration("./data/Respiration/20150709_BacterialRespiration_a_MEM_Oxygen.txt",
                    "./data/Respiration/20150709_BacterialRespiration_a_MEM_Output.txt")
PreSens.Respiration("./data/Respiration/20150709_BacterialRespiration_b_MEM_Oxygen.txt",
                    "./data/Respiration/20150709_BacterialRespiration_b_MEM_Output.txt")

