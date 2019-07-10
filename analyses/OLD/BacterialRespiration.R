################################################################################
#                                                                              #
#	Microbial Carbon Traits Bacterial Respiration Experiments                    #
#   Analysis Respiration Data from PreSens Output                              #
#                                                                              #
################################################################################
#                                                                              #
#	Written by: Mario Muscarella                                                 #
#                                                                              #
#	Last update: 2015/05/22                                                      #
#                                                                              #
################################################################################

# Setup Work Environment
rm(list=ls())
setwd("~/GitHub/MicrobialCarbonTraits/analyses")
se <- function(x){sd(x)/sqrt(length(x))}

# April 30 2015 Experiment: Chloramphenicol Experiment 1 #######################
# Experimental Description: Checking the effects of chloramphenicol on BR
#                           The expectation is this forces basal metabolism
#
################################################################################
br_oxy <- read.csv("../data/20150430_BacterialRespiration_Output.txt", header=T)

HMWF001 <- NA
HMWF001C <- br_oxy[1:3, 4]
HMWF002 <- br_oxy[4:6, 4]
HMWF002C <- br_oxy[7:9, 4]

mean_HMWF001 <- mean(HMWF001)
mean_HMWF001C <- mean(HMWF001C)
mean_HMWF002 <- mean(HMWF002)
mean_HMWF002C <- mean(HMWF002C)

se_HMWF001 <- se(HMWF001)
se_HMWF001C <- se(HMWF001C)
se_HMWF002 <- se(HMWF002)
se_HMWF002C <- se(HMWF002C)

trt.bp <- c("HMWF001  ", "HMWF001  \nMaintenance",
            "HMWF002  ", "HMWF002  \nMaintenance")
mean.bp <- c(mean_HMWF001, mean_HMWF001C, mean_HMWF002, mean_HMWF002C)
se.bp <- c(se_HMWF001, se_HMWF001C, se_HMWF002, se_HMWF002C)

par(mar=c(6,5,0.5,0.5), oma=c(1,1,1,1)+0.1, lwd=2)
bp_plot <- barplot(mean.bp, names.arg=trt.bp, ylim=c(0,20),
                   col="gray",lwd=3, yaxt="n", xaxt="n")
arrows(x0 = bp_plot, y0 = mean.bp, y1 = mean.bp - se.bp, angle = 90,
       length=0.1, lwd = 2)
arrows(x0 = bp_plot, y0 = mean.bp, y1 = mean.bp + se.bp, angle = 90,
       length=0.1, lwd = 2)
axis(side = 2, labels=T, lwd.ticks=2, las=2, lwd=2)
text(bp_plot, par("usr")[3], labels = trt.bp, srt = 45, adj = c(1,1.5),
     xpd = TRUE, cex=1)
mtext(expression(paste("BR (",mu,"M O"[2]," Hr"^-1, ")", sep="")), side = 2,
      cex = 1.5, line = 3)

# Full Data
trts <- rep(trt.bp[2:4], each=3)
bps <- c(HMWF001C, HMWF002, HMWF002C)

# PostHoc Test
require(agricolae)
div.carbs <- lm(bps ~ trts)
anova(div.carbs)
TukeyHSD(aov(div.carbs))
hsd <- HSD.test(div.carbs, "trts")
hsd
div.carbs.m <- lm(bps ~ trts - 1)
summary(div.carbs.m)

# Percent Respiration Required For Maintenance
# HMWF001.d <- (max(mean_HMWF001C, 0)/mean_HMWF001) * 100
HMWF002.d <- (max(mean_HMWF002C, 0)/mean_HMWF002) * 100
