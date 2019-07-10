################################################################################
#                                                                              #
#  HMWF Isolates Growth Rate                                                   #
#   Parameter Estimate Code                                                    #
#                                                                              #
################################################################################
#                                                                              #
#	Written by: M. Muscarella                                                    #
#                                                                              #
#	Last update: 18 May 2016                                                     #
#                                                                              #
################################################################################


rm(list=ls())
setwd("~/GitHub/MicrobialCarbonTraits/analyses")
se <- function(x, ...){sd(x, na.rm = TRUE)/sqrt(length(na.omit(x)))}

#g.conv <- read.delim("../data/ABS-Cells.txt", header = T)

ratesA <- read.csv("../output/HMWF130522.txt")
ratesA$Isolate <- c("HMWF007", "HMWF018", "HMWF001",            "HMWF006", "HMWF013", "HMWF005", "HMWF017",
                    "HMWF014", "HMWF019", "HMWF015", "HMWF016", "HMWF011", "Control", "HMWF021", "HMWF003",
                    "HMWF014",            "HMWF003", "HMWF015", "HMWF001", "HMWF017", "HMWF007", "HMWF021",
                    "HMWF013", "HMWF006", "HMWF011", "HMWF019", "Control", "HMWF018", "HMWF016", "HMWF005",
                    "HMWF016", "HMWF001", "Control", "HMWF007", "HMWF017", "HMWF015", "HMWF011", "HMWF006",
                    "HMWF005", "HMWF003", "HMWF014",            "HMWF021", "HMWF013")


ratesB <- read.csv("../output/HMWF130520.txt")
ratesB$Isolate <- c("HMWF030", "HMWF022", "HMWF035", "HMWF004", "HMWF009", "HMWF029", "HMWF032", "HMWF023",
                    "HMWF028", "HMWF031",            "HMWF010", "Control", "HMWF025", "HMWF026", "HMWF034",
                               "HMWF022", "HMWF023", "Control", "HMWF032", "HMWF004", "HMWF031", "HMWF010",
                    "HMWF034", "HMWF026", "HMWF029", "HMWF028", "HMWF009", "HMWF035", "HMWF030", "HMWF025",
                    "HMWF029", "HMWF035", "HMWF030", "HMWF028", "Control", "HMWF032", "HMWF025", "HMWF031",
                    "HMWF026", "HMWF034", "HMWF010", "HMWF022", "HMWF004", "HMWF009")

ratesC <- read.csv("../output/HMWF130528.txt")
ratesC$Isolate <- c("HMWF008", "HMWF010", "HMWF026", "HMWF010",
                    "HMWF005", "HMWF023", "HMWF019", "HMWF026",
                    "HMWF017", "HMWF005", "HMWF008",
                    "HMWF026", "HMWF019", "HMWF036", "HMWF023",
                    "HMWF023", "HMWF005", "HMWF019", "HMWF026", "HMWF008", "HMWF010",
                    "HMWF008", "HMWF036")



# Remove controls & Calculate Mean Rate
ratesA <- subset(ratesA, ratesA$Isolate != "Control")
umaxA <- round(tapply(ratesA$umax, ratesA$Isolate, mean), 3)

ratesB <- subset(ratesB, ratesB$Isolate != "Control")
umaxB <- round(tapply(ratesB$umax, ratesB$Isolate, mean), 3)

ratesC <- subset(ratesC, ratesC$Isolate != "Control")
umaxC <- round(tapply(ratesC$umax, ratesC$Isolate, mean), 3)

umax <- c(umaxA, umaxB, umaxC)
umax[umax < 0] <-  NA
umax[umax > 0.4] <-  NA
umax <- as.matrix(umax)
umax <- cbind(rownames(umax), umax)
colnames(umax) <- c("isolate", "umax")

write.csv(umax, "../data/GrowthCurves/umax.txt", quote = F, row.names = F)




umax <- read.delim("../data/umax.txt", header=T)

umax$rate.c <- umax$umax * umax$conv
umax$double <- log(2)/umax$rate.c



ecolog <- read.delim("../data/ecolog.txt", fill=T)

umax$breadth <- specnumber(ecolog)
diver <- diversity(ecolog, "shannon")


plot(umax$breadth, umax$umax, xlab = "Resource Breadth",
     ylab = expression(paste("Growth Rate (ABS hr"^" -1",")")), las=1)


expression(paste("Carbon Loading (g" %.% "m"^"-2",")"))
