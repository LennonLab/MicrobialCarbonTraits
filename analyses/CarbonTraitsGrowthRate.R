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

rm(list=ls())
setwd("~/GitHub/MicrobialCarbonTraits/analyses")
se <- function(x, ...){sd(x, na.rm = TRUE)/sqrt(length(na.omit(x)))}

# Load Dependencies
source("../bin/modified_Gomp.r")
# Create Directory For Output
dir.create("../data/GrowthCurves/output", showWarnings = FALSE)

# Run Examples
#growth.modGomp("../data/GrowthCurve_Example.txt", "test", skip=32)
#growth.modGomp("../data/GrowthCurve_05222013_Isolates1-21Correct.txt", "HMWF1-21")
#growth.modGomp("../data/GrowthCurve_05162013_Isolates4-35.txt", "HMWF4-35")
#growth.modGomp("../data/GrowthCurve_")

# Experimental Data
growth.modGomp("../data/GrowthCurves/GrowthCurve_14hrs_130528_194247.txt", "HMWF130528", skip=50)
growth.modGomp("../data/GrowthCurves/GrowthCurve_18hrs_130520_160724.txt", "HMWF130520", skip=50)
growth.modGomp("../data/GrowthCurves/GrowthCurve_18hrs_130522_155343.txt", "HMWF130522", skip=50)
growth.modGomp("../data/GrowthCurves/GrowthCurve_18hrs_140402_170936.txt", "HMWF140402", skip=50)


#g.conv <- read.delim("./data/ABS-Cells.txt", header = T)

ratesA <- read.csv("../data/GrowthCurves/output/HMWF130522.txt")
ratesA$Isolate <- c("HMWF007", "HMWF018", "HMWF001",            "HMWF006", "HMWF013", "HMWF005", "HMWF017",
                    "HMWF014", "HMWF019", "HMWF015", "HMWF016", "HMWF011", "Control", "HMWF021", "HMWF003",
                    "HMWF014",            "HMWF003", "HMWF015", "HMWF001", "HMWF017", "HMWF007", "HMWF021",
                    "HMWF013", "HMWF006", "HMWF011", "HMWF019", "Control", "HMWF018", "HMWF016", "HMWF005",
                    "HMWF016", "HMWF001", "Control", "HMWF007", "HMWF017", "HMWF015", "HMWF011", "HMWF006",
                    "HMWF005", "HMWF003", "HMWF014",            "HMWF021", "HMWF013")


ratesB <- read.csv("../data/GrowthCurves/output/HMWF130520.txt")
ratesB$Isolate <- c("HMWF030", "HMWF022", "HMWF035", "HMWF004", "HMWF009", "HMWF029", "HMWF032", "HMWF023",
                    "HMWF028", "HMWF031",            "HMWF010", "Control", "HMWF025", "HMWF026", "HMWF034",
                               "HMWF022", "HMWF023", "Control", "HMWF032", "HMWF004", "HMWF031", "HMWF010",
                    "HMWF034", "HMWF026", "HMWF029", "HMWF028", "HMWF009", "HMWF035", "HMWF030", "HMWF025",
                    "HMWF029", "HMWF035", "HMWF030", "HMWF028", "Control", "HMWF032", "HMWF025", "HMWF031",
                    "HMWF026", "HMWF034", "HMWF010", "HMWF022", "HMWF004", "HMWF009")

ratesC <- read.csv("../data/GrowthCurves/output/HMWF130528.txt")
ratesC$Isolate <- c("HMWF008", "HMWF010", "HMWF026", "HMWF010",
                    "HMWF005", "HMWF023", "HMWF019", "HMWF026",
                    "HMWF017", "HMWF005", "HMWF008",
                    "HMWF026", "HMWF019", "HMWF036", "HMWF023",
                    "HMWF023", "HMWF005", "HMWF019", "HMWF026", "HMWF008", "HMWF010",
                    "HMWF008", "HMWF036")



# Remove controls & Calculate Mean Rate
ratesA <- subset(ratesA, ratesA$Isolate != "Control")
ratesA$umax[which(ratesA$umax > 0.5)] <- NA
ratesA$umax[which(ratesA$umax < 0)] <- NA
umaxA <- round(tapply(ratesA$umax, ratesA$Isolate, mean, na.rm = T), 3)

ratesB <- subset(ratesB, ratesB$Isolate != "Control")
ratesB$umax[which(ratesB$umax > 0.5)] <- NA
ratesB$umax[which(ratesB$umax < 0)] <- NA
umaxB <- round(tapply(ratesB$umax, ratesB$Isolate, mean, na.rm = T), 3)

ratesC <- subset(ratesC, ratesC$Isolate != "Control")
ratesC$umax[which(ratesC$umax > 0.5)] <- NA
ratesC$umax[which(ratesC$umax < 0)] <- NA
umaxC <- round(tapply(ratesC$umax, ratesC$Isolate, mean, na.rm = T), 3)

umax <- c(umaxA, umaxB, umaxC)
umax[umax < 0] <-  NA
umax[umax > 0.4] <-  NA
umax <- as.matrix(umax)
umax <- cbind(rownames(umax), umax)
colnames(umax) <- c("isolate", "umax")

write.csv(umax, "../data/umax.txt", quote = F, row.names = F)

# Remove Temp Files
unlink("../data/GrowthCurves/temp", recursive = TRUE)
