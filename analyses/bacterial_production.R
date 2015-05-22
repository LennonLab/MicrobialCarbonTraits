################################################################################
#                                                                              #
#	Microbial Carbon Traits Bacterial Production Experiments                     #
#   Analysis Luecine Bacterial Production Data                                 #
#                                                                              #
################################################################################
#                                                                              #
#	Written by: Mario Muscarella                                                 #
#                                                                              #
#	Last update: 2015/05/21                                                      #
#                                                                              #
################################################################################

# Setup Work Environment
rm(list=ls())
setwd("~/GitHub/MicrobialCarbonTraits/analyses")
se <- function(x){sd(x)/sqrt(length(x))}

# June 14 2014 Experiment: Catechol ############################################
# Experimental Description: Effect of catechol concentrations on Jordan River
#
################################################################################
bp_cpm <- read.delim("../data/20140616_CatecholExperiment.txt", header=T)

KC <- bp_cpm$CPM[1:4]
trt_Blank <- bp_cpm$CPM[5:7]
trt_0mgC <- bp_cpm$CPM[8:10]
trt_1mgC <- bp_cpm$CPM[11:13]
trt_5mgC <- bp_cpm$CPM[14:16]

mean_KC <- mean(KC)
mean_Blank <- mean(trt_Blank)
mean_0mgC <- mean(trt_0mgC)
mean_1mgC <- mean(trt_1mgC)
mean_5mgC <- mean(trt_5mgC)

se_KC <- se(KC)
se_Blank <- se(trt_Blank)
se_0mgC <- se(trt_0mgC)
se_1mgC <- se(trt_1mgC)
se_5mgC <- se(trt_5mgC)

trt.bp <- c("Kill Control", "Blank", "0 mg C/L", "1 mg C/L", "5 mg C/L")
mean.bp <- c(mean_KC, mean_Blank, mean_0mgC, mean_1mgC, mean_5mgC)
se.bp <- c(se_KC, se_Blank, se_0mgC, se_1mgC, se_5mgC)

par(mar=c(2,6,0.5,0.5), oma=c(1,1,1,1)+0.1, lwd=2)
bp_plot <- barplot(mean.bp, names.arg=trt.bp, ylim=c(0,200000),
                   col="gray",lwd=3, yaxt="n")
arrows(x0 = bp_plot, y0 = mean.bp, y1 = mean.bp - se.bp, angle = 90,
       length=0.1, lwd = 2)
arrows(x0 = bp_plot, y0 = mean.bp, y1 = mean.bp + se.bp, angle = 90,
       length=0.1, lwd = 2)
axis(side = 2, labels=T, lwd.ticks=2, las=2, lwd=2)
mtext("CPM", side = 2, cex = 1.5, line = 4.5)


# June 19 2014 Experiment: Catechol ############################################
# Experimental Description: Effect of catechol concentrations on Jordan River
#                           Using more refined concentrations
#
################################################################################
bp_cpm <- read.delim("../data/20140619_CatecholExperiment.txt", header=T)

KC <- bp_cpm$CPM[22:24]
trt_Blank <- bp_cpm$CPM[19:21]
trt_0mgC <- bp_cpm$CPM[16:18]
trt_0.0001mgC <- bp_cpm$CPM[13:15]
trt_0.001mgC <- bp_cpm$CPM[10:12]
trt_0.01mgC <- bp_cpm$CPM[7:9]
trt_0.1mgC <- bp_cpm$CPM[4:6]
trt_1mgC <- bp_cpm$CPM[1:3]

mean_KC <- mean(KC)
mean_Blank <- mean(trt_Blank)
mean_0mgC <- mean(trt_0mgC)
mean_0.0001mgC <- mean(trt_0.0001mgC)
mean_0.001mgC <- mean(trt_0.001mgC)
mean_0.01mgC <- mean(trt_0.01mgC)
mean_0.1mgC <- mean(trt_0.1mgC)
mean_1mgC <- mean(trt_1mgC)

se_KC <- se(KC)
se_Blank <- se(trt_Blank)
se_0mgC <- se(trt_0mgC)
se_0.0001mgC <- se(trt_0.0001mgC)
se_0.001mgC <- se(trt_0.001mgC)
se_0.01mgC <- se(trt_0.01mgC)
se_0.1mgC <- se(trt_0.1mgC)
se_1mgC <- se(trt_1mgC)

trt.bp <- c("Kill Control", "Blank", "0 mg C/L", "0.0001 mg C/L",
            "0.001 mg C/L", "0.01 mg C/L", "0.1 mg C/L", "1 mg C/L")
mean.bp <- c(mean_KC, mean_Blank, mean_0mgC, mean_0.0001mgC,
             mean_0.001mgC, mean_0.01mgC, mean_0.1mgC, mean_1mgC)
se.bp <- c(se_KC, se_Blank, se_0mgC, se_0.0001mgC, se_0.001mgC,
           se_0.01mgC, se_0.1mgC, se_1mgC)

par(mar=c(6,6,0.5,0.5), oma=c(1,1,1,1)+0.1, lwd=2)
bp_plot <- barplot(mean.bp, names.arg=trt.bp, ylim=c(0,200000),
                   col="gray",lwd=3, yaxt="n", xaxt="n")
arrows(x0 = bp_plot, y0 = mean.bp, y1 = mean.bp - se.bp, angle = 90,
       length=0.1, lwd = 2)
arrows(x0 = bp_plot, y0 = mean.bp, y1 = mean.bp + se.bp, angle = 90,
       length=0.1, lwd = 2)
axis(side = 2, labels=T, lwd.ticks=2, las=2, lwd=2)
text(bp_plot, par("usr")[3], labels = trt.bp, srt = 45, adj = c(1.1,1.5),
     xpd = TRUE, cex=1)
mtext("CPM", side = 2, cex = 1.5, line = 4.5)

# Response Curve
cv.mean.bp <- c(trt_0mgC, trt_0.0001mgC, trt_0.001mgC,
                trt_0.01mgC, trt_0.1mgC, trt_1mgC)
cv.conc.bp <- c(0,0,0, 0.0001,0.0001,0.0001, 0.001,0.001,0.001,
                0.01,0.01,0.01, 0.1,0.1,0.1, 1.0,1.0,1.0)

par(mar=c(5,6,0.5,0.5), oma=c(1,1,1,1)+0.1, lwd=2)
plot(cv.conc.bp, cv.mean.bp, log="x", yaxt="n", xaxt="n", ylab="", xlab="")
axis(side = 2, labels=T, lwd.ticks=2, las=2, lwd=2)
x.ticks <- seq(-4, 1, by=1)
x.labels <- sapply(x.ticks, function(i) as.expression(bquote(10^ .(i))))
axis(1, at=c(0.0001, 0.001, 0.01, 0.1, 1.0, 0), labels=x.labels)
mtext(expression(paste("Catechol (mg C L"^" -1",")",
  sep="")), side = 1, cex = 1.5, line = 3.5)
mtext("CPM", side = 2, cex = 1.5, line = 4.5)
axis(side = 1, labels=F, lwd.ticks=2)
axis(side = 2, labels=F, lwd.ticks=2)
axis(side = 1, tck=0.01, labels=F, lwd.ticks=2)
axis(side = 2, tck=0.01, labels=F, lwd.ticks=2)
axis(side = 3, tck=0.01, labels=F, lwd.ticks=2)
axis(side = 4, tck=0.01, labels=F, lwd.ticks=2)

lines(lowess(cv.conc.bp, cv.mean.bp))

# fit non-linear model - haven't figured this out yet
#require(nmle)
#mod <- nls(cv.mean.bp ~ a*exp(-cv.conc.bp) + b, start = list(a = 0, b = 0))
#mod2 <- gnls(cv.mean.bp ~ K/(1+exp(Co+r*cv.conc.bp)))

# add fitted curve
#lines(cv.conc.bp, predict(mod, int="p", se.fit=T, list(x = cv.conc.bp)))

## Defining grid of z values
## (100 values ensures a smooth curve in your case)
#zValues <- seq(0.0001, 1, length.out = 1000)

## Adding predicted values corresponding to the grid values
#lines(zValues, predict(mod2, data.frame(cv.conc.bp = zValues)))



# August 1 2014 Experiment: Diverse Carbon Resources ###########################
# Experimental Description: Effect of different carbon resources on
#                           Jordan River Bacterial Production
#                           Control = no carbon added
#
################################################################################
bp_cpm <- read.delim("../data/20140801_BPExperiment.txt", header=T)

KC <- bp_cpm$CPM[3:5]
ctrl <- bp_cpm$CPM[6:8]
glu <- bp_cpm$CPM[9:11]
sal <- bp_cpm$CPM[12:14]
pro <- bp_cpm$CPM[15:17]
sig <- bp_cpm$CPM[18:20]
suw <- bp_cpm$CPM[21:23]

mean_KC <- mean(KC)
mean_ctrl <- mean(ctrl)
mean_glu <- mean(glu)
mean_sal <- mean(sal)
mean_pro <- mean(pro)
mean_sig <- mean(sig)
mean_suw <- mean(suw)

se_KC <- se(KC)
se_ctrl <- se(ctrl)
se_glu <- se(glu)
se_sal <- se(sal)
se_pro <- se(pro)
se_sig <- se(sig)
se_suw <- se(suw)

trt.bp <- c("Kill Control", "Control", "D-Glucose", "Salicylate",
            "Protocatechuate", "Sigma Humics", "Suwannee River")
mean.bp <- c(mean_KC, mean_ctrl, mean_glu, mean_sal, mean_pro, mean_sig, mean_suw)
se.bp <- c(se_KC, se_ctrl, se_glu, se_sal, se_pro, se_sig, se_suw)

par(mar=c(6,6,0.5,0.5), oma=c(1,1,1,1)+0.1, lwd=2)
bp_plot <- barplot(mean.bp, names.arg=trt.bp, ylim=c(0,75000),
                   col="gray",lwd=3, yaxt="n", xaxt="n")
arrows(x0 = bp_plot, y0 = mean.bp, y1 = mean.bp - se.bp, angle = 90,
       length=0.1, lwd = 2)
arrows(x0 = bp_plot, y0 = mean.bp, y1 = mean.bp + se.bp, angle = 90,
       length=0.1, lwd = 2)
axis(side = 2, labels=T, lwd.ticks=2, las=2, lwd=2)
text(bp_plot, par("usr")[3], labels = trt.bp, srt = 45, adj = c(1.1,1.5),
     xpd = TRUE, cex=1)
mtext("CPM", side = 2, cex = 1.5, line = 4.5)

# Full Data
trts <- rep(trt.bp, each=3)
bps <- c(KC, ctrl, glu, sal, pro, sig, suw)

# PostHoc Test
require(agricolae)
div.carbs <- lm(bps ~ trts)
anova(div.carbs)
TukeyHSD(aov(div.carbs))
hsd <- HSD.test(div.carbs, "trts")
hsd

# April 30 2015 Experiment: Leucine Titration ##################################
# Experimental Description: Optimizing the final concentration of Leucine
#                           in BP experiments for cultures
#
################################################################################
bp_cpm <- read.delim("../data/20150430_LeucineConcentration.txt", header=T)

kills <- bp_cpm[11:13,]
kill.lm <- lm(CPM ~ Leucine, data = kills)
plot(CPM ~ Leucine, data = kills)
abline(kill.lm)
summary(kill.lm) # Not significant, just use mean
kill.mean <- mean(kills$CPM)

samps <- bp_cpm[1:10,]
par(mar=c(4,6,0.5,0.5), oma=c(1,1,1,1)+0.1, lwd=2)
plot(CPM ~ Leucine, data = samps, ylim=c(0,30000), pch=16, cex.lab = 1.5,
     ylab = "", xlab = "Leucine Concentration (uM)", yaxt="n", xaxt="n")
axis(side = 1, labels=T, lwd.ticks=2, las=1, lwd=2)
axis(side = 2, labels=T, lwd.ticks=2, las=2, lwd=2)
mtext("BP (CPM)", side = 2, cex = 1.5, line = 4.5)

linModel <- lm(CPM ~ Leucine, data = samps)
summary(linModel)  # Significant - Crap!!!!!
abline(linModel, lty = 2, col="red")

# Fit Curve with MM Equation
# (http://strata.uga.edu/6370/lecturenotes/nonlinearRegression.html)
# mmModel <- nls(CPM ~ (Vm*Leucine)/(K*Leucine), start=list(Vm=214, K=10000),
#                data = samps)


# April 30 2015 Experiment: Chloramphenicol Experiment 1 #######################
# Experimental Description: Checking the effects of chloramphenicol on BP
#                           The expectation is that it stops BP
#
################################################################################
bp_cpm <- read.delim("../data/20150430_ChloramphenicolExperiment.txt", header=T)

HMWF001 <- bp_cpm$CPM[1:3] - bp_cpm$CPM[13]
HMWF001C <- bp_cpm$CPM[4:6] - bp_cpm$CPM[14]
HMWF002 <- bp_cpm$CPM[7:9] - bp_cpm$CPM[15]
HMWF002C <- bp_cpm$CPM[10:12] - bp_cpm$CPM[16]

mean_HMWF001 <- mean(HMWF001)
mean_HMWF001C <- mean(HMWF001C)
mean_HMWF002 <- mean(HMWF002)
mean_HMWF002C <- mean(HMWF002C)

se_HMWF001 <- se(HMWF001)
se_HMWF001C <- se(HMWF001C)
se_HMWF002 <- se(HMWF002)
se_HMWF002C <- se(HMWF002C)

trt.bp <- c("HMWF001", "HMWF001C", "HMWF002", "HMWF002C")
mean.bp <- c(mean_HMWF001, mean_HMWF001C, mean_HMWF002, mean_HMWF002C)
se.bp <- c(se_HMWF001, se_HMWF001C, se_HMWF002, se_HMWF002C)

par(mar=c(5,6,0.5,0.5), oma=c(1,1,1,1)+0.1, lwd=2)
bp_plot <- barplot(mean.bp, names.arg=trt.bp, ylim=c(0,75000),
                   col="gray",lwd=3, yaxt="n", xaxt="n")
arrows(x0 = bp_plot, y0 = mean.bp, y1 = mean.bp - se.bp, angle = 90,
       length=0.1, lwd = 2)
arrows(x0 = bp_plot, y0 = mean.bp, y1 = mean.bp + se.bp, angle = 90,
       length=0.1, lwd = 2)
axis(side = 2, labels=T, lwd.ticks=2, las=2, lwd=2)
text(bp_plot, par("usr")[3], labels = trt.bp, srt = 45, adj = c(1.1,1.5),
     xpd = TRUE, cex=1)
mtext("BP (CPM)", side = 2, cex = 1.5, line = 4.5)

# Full Data
trts <- rep(trt.bp, each=3)
bps <- c(HMWF001, HMWF001C, HMWF002, HMWF002C)

# PostHoc Test
require(agricolae)
div.carbs <- lm(bps ~ trts)
anova(div.carbs)
TukeyHSD(aov(div.carbs))
hsd <- HSD.test(div.carbs, "trts")
hsd
div.carbs.m <- lm(bps ~ trts - 1)
summary(div.carbs.m)

# Percent Decrease in BP
HMWF001.d <- (1 - max(mean_HMWF001C, 0)/mean_HMWF001) * 100
HMWF002.d <- (1 - max(mean_HMWF002C, 0)/mean_HMWF002) * 100
