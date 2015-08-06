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
#require("muscle")
require("ape")
#require("seqinr")
require("phylobase")
require("adephylo")
require("geiger")
require("picante")
require("stats")
require("RColorBrewer")
#require("caper")

sem <- function(x){sd(na.omit(x))/sqrt(length(na.omit(x)))}

# Import Data
BP <- read.csv(file="./data/CarbonTraits/BP_data.txt")
BR <- read.csv(file="./data/CarbonTraits/BR_data.txt")

BP$Organism == BR$Organism

BGE <- as.data.frame(matrix(NA, 23, 4))
colnames(BGE) <- c("Organism", "BGE_Glu", "BGE_Suc", "BGE_Pro")
BGE$Organism <- BP$Organism

BGE$BGE_Glu <- round(BP$Glu_mean / (BP$Glu_mean + BR$Glu_mean), 5)
BGE$BGE_Suc <- round(BP$Suc_mean / (BP$Suc_mean + BR$Suc_mean), 5)
BGE$BGE_Pro <- round(BP$Pro_mean / (BP$Pro_mean + BR$Pro_mean), 5)


# Import Phylogeny (already rooted)
tree <- read.tree("./data/Phylogeny/HMWF.proteo.cons.nwk")

# Keep Rooted but Drop Outgroup Branch
tree <- drop.tip(tree, "Aquifex")

# Make Plot
# Define Color Palette
mypalette <- colorRampPalette(brewer.pal(9, "YlOrRd"))

# Map Carbon Respiration Traits {adephylo}
Resp <- BR[,c(11, 13, 15)]
Resp[is.na(Resp)] <- 0
Resp[Resp > 500] <- 500
colnames(Resp) <- c("Glucose", "Succinate", "Protocatechuate")
rownames(Resp) <- BR$Organism

par(mar=c(1,1,1,2) + 0.1)
x <- phylo4d(tree, Resp)
table.phylo4d(x, treetype = "phylo", symbol = "colors", show.node = FALSE,
              cex.label = 0.8, scale = FALSE, use.edge.length = FALSE,
              edge.color = "black", edge.width = 3, box = FALSE,
              col=mypalette(25), pch = 15, cex.symbol = 2.5,
              ratio.tree = 0.60, cex.legend = 1.5, center = FALSE)

# Map Carbon Production Traits {adephylo}
Prod <- BP[,c(11, 13, 15)]
Prod[is.na(Prod)] <- 0
Prod[Prod < 0] <- 0
Prod[Prod > 10] <- 10
colnames(Prod) <- c("Glucose", "Succinate", "Protocatechuate")
rownames(Prod) <- BP$Organism

par(mar=c(1,1,1,2) + 0.1)
x <- phylo4d(tree, Prod)
table.phylo4d(x, treetype = "phylo", symbol = "colors", show.node = FALSE,
              cex.label = 0.8, scale = FALSE, use.edge.length = FALSE,
              edge.color = "black", edge.width = 3, box = FALSE,
              col=mypalette(25), pch = 15, cex.symbol = 2.5,
              ratio.tree = 0.60, cex.legend = 1.5, center = FALSE)

# Map Carbon BGE Traits {adephylo}
BGE2 <- BGE[,2:4]
BGE2[is.na(BGE2)] <- 0
BGE2[BGE2 < 0] <- 0
BGE2[BGE2 > 0.9] <- 0
colnames(BGE2) <- c("Glucose", "Succinate", "Protocatechuate")
rownames(BGE2) <- BGE$Organism

par(mar=c(1,1,1,2) + 0.1)
x <- phylo4d(tree, BGE2)
table.phylo4d(x, treetype = "phylo", symbol = "colors", show.node = FALSE,
              cex.label = 0.8, scale = FALSE, use.edge.length = FALSE,
              edge.color = "black", edge.width = 3, box = FALSE,
              col=mypalette(25), pch = 15, cex.symbol = 2.5,
              ratio.tree = 0.60, cex.legend = 1.5, center = FALSE)














# Visualize Trees With Different Levels of  Phylogenetic Signal {geiger}
nj.lambda.5 <- rescale(nj.rooted, "lambda", 0.5)
nj.lambda.0 <- rescale(nj.rooted, "lambda", 0)

layout(matrix(c(1,2,3), 1, 3), width = c(1, 1, 1))
par(mar=c(1,0.5,2,0.5)+0.1)
plot(nj.rooted, main = "lambda = 1", cex = 0.7, adj = 0.5)
plot(nj.lambda.5, main = "lamba = 0.5", cex = 0.7, adj = 0.5)
plot(nj.lambda.0, main = "lamba = 0",  cex = 0.7, adj = 0.5)






# Generate Test Statistics for Comparing Phylogenetic Signal {geiger}
fitContinuous(nj.rooted, nb, model = "lambda")
fitContinuous(nj.lambda.0, nb, model = "lambda")



# First, Correct for Zero Branch-Lengths on Our Tree
nj.rooted$edge.length <- nj.rooted$edge.length + 10^-7

# Calculate Phylogenetic Signal for Growth on All Phosphorus Resources
# First, Create a Blank Output Matrix
p.phylosignal <- matrix(NA, 6, 18)
colnames(p.phylosignal) <- colnames(p.growth.std)
rownames(p.phylosignal) <- c("K", "PIC.var.obs", "PIC.var.mean",
                             "PIC.var.P", "PIC.var.z", "PIC.P.BH")

# Use a For Loop to Calculate Blomberg's K for Each Resource
for (i in 1:18){
  x <- as.matrix(p.growth.std[ ,i, drop = FALSE])
  out <- phylosignal(x, nj.rooted)
  p.phylosignal[1:5, i] <- round(t(out), 3)
}

# Use the BH Correction on P-values:
p.phylosignal[6, ] <- round(p.adjust(p.phylosignal[4, ], method = "BH"), 3)


# Calcualate Phylogenetic Signal for Niche Breadth
signal.nb <- phylosignal(nb, nj.rooted)
