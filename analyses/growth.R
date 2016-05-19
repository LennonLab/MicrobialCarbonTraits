################################################################################
#                                                                              #
#	HMWF Isolates Growth Rate                                    #
#   Parameter Estimate Code                                                    #
#                                                                              #
################################################################################
#                                                                              #
#	Written by: M. Muscarella                                                    #
#   Based on growthcurve_code.R Written by: M. Larsen (2013/07/18)             #
#                                                                              #
#	Last update: 2/19/14                                                         #
#                                                                              #
################################################################################

# Load Dependencies
source("../bin/modified_Gomp.r")
# Create Directory For Output
dir.create("../output", showWarnings = FALSE)

# Run Example
growth.modGomp("../data/GrowthCurve_Example.txt", "test", skip=32)


growth.modGomp("../data/GrowthCurve_05222013_Isolates1-21Correct.txt", "HMWF1-21")
growth.modGomp("../data/GrowthCurve_05162013_Isolates4-35.txt", "HMWF4-35")
growth.modGomp("../data/GrowthCurve_")


growth.modGomp("../data/GrowthCurves/GrowthCurve_14hrs_130528_194247.txt", "HMWF130528", skip=50)
growth.modGomp("../data/GrowthCurves/GrowthCurve_18hrs_130520_160724.txt", "HMWF130520", skip=50)
growth.modGomp("../data/GrowthCurves/GrowthCurve_18hrs_130522_155343.txt", "HMWF130522", skip=50)
growth.modGomp("../data/GrowthCurves/GrowthCurve_18hrs_140402_170936.txt", "HMWF140402", skip=50)
