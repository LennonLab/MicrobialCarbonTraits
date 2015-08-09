################################################################################
#                                                                              #
#	Microbial Carbon Traits: Resource Breadth                                    #
#   This script produces EcoPlate and MAPLE Graphs                             #
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

# Import Data Sets
copynum <- read.delim("./data/CopyNumber/16SrRNA.txt", row.names=1)
pathways <- read.delim("./data/Maple/pathways.txt", row.names=1)
maple <- read.delim("./data/Maple/maple.txt", row.names=1)
# ecoplate <- read.delim()


# Import Phylogeny (already rooted)
tree <- read.tree("./data/Phylogeny/RAxML_1000bootstrap.HMWF.consensus.tre")

# Keep Rooted but Drop Outgroup Branch
tree <- drop.tip(tree, "Aquifex")

# Define Color Palette
mypalette <- colorRampPalette(brewer.pal(9, "YlOrRd"), bias = 2)

# Make Example Plot For Talks
EX <- as.data.frame(rnorm(23, 5, 2))
colnames(EX) <- "Example"
row.names(EX) <- row.names(copynum)

par(mar=c(1,1,1,2) + 0.1)
x <- phylo4d(tree, EX)
table.phylo4d(x, treetype = "phylo", symbol = "colors", show.node = FALSE,
              cex.label = 0.8, scale = FALSE, use.edge.length = FALSE,
              edge.color = "black", edge.width = 3, box = FALSE,
              col=mypalette(25), pch = 15, cex.symbol = 2.5,
              ratio.tree = 0.75, cex.legend = 1.5, center = FALSE,
              show.var.label=TRUE)

rect(0, -6, 15, -2, col="white", border="white")
text(7.5, -3.5, "Low                    High", cex = 1.2)
text(18.5, 22.5, expression(alpha), cex=1.5)
text(18.5, 19.5, expression(beta), cex=1.5)
text(4, 12.5, expression(gamma), cex=1.5)
text(11.5, 17, "Xan.", cex=1)
text(11.5, 12.5, "Aero.", cex=1)
text(11.5, 5, "Pseu.", cex=1)
rect(20, -5, 30, 0.1, col="white", border="white")
text(24.5, -1, "Example")

# Example of phylosignal
phylosignal(as.matrix(EX), tree)
phylosig(tree,as.matrix(EX),method="lambda",test=T)











# Genomic and Ecoplate Plot
traits <- cbind(copynum, pathways)

# Reorder Traits
traits <- as.matrix(traits[match(tree$tip.label, row.names(traits)), ])

par(mar=c(1,1,1,2) + 0.1)
x <- phylo4d(tree, traits)
table.phylo4d(x, treetype = "phylo", symbol = "colors", show.node = FALSE,
              cex.label = 0.8, scale = TRUE, use.edge.length = FALSE,
              edge.color = "black", edge.width = 3, box = FALSE,
              col=mypalette(25), pch = 15, cex.symbol = 2.5,
              ratio.tree = 0.60, cex.legend = 1.5, center = FALSE)


# Import Phylogeny (already rooted)
tree1000 <- read.tree("./data/Phylogeny/RAxML_1000bootstrap.HMWF.tre")

# Reorder Traits
tree1000[[1]] <- drop.tip(tree1000[[1]], "Aquifex")
traits <- as.matrix(traits[match(tree1000[[1]]$tip.label, row.names(traits)), ])

# Blomberg's K - Copy Number
bloms1 <- matrix(NA, 1000, 2)
colnames(bloms1) <- c("K", "P")
for (i in 1:1000){
  tree1000[[i]] <- drop.tip(tree1000[[i]], "Aquifex")
  tree1000[[i]]$edge.length <- tree1000[[i]]$edge.length + 10^-7
  output <- phylosignal(traits[, 1], tree1000[[i]])
  bloms1[i, 1] <- output[[1]]
  bloms1[i, 2] <- output[[4]]
}

avgK1 <- colMeans(bloms1)[1]
prob1 <- which(bloms1[, 2] > 0.05) / 1000


# Blomberg's K - Pathways
bloms2 <- matrix(NA, 1000, 2)
colnames(bloms2) <- c("K", "P")
for (i in 1:1000){
  tree1000[[i]] <- drop.tip(tree1000[[i]], "Aquifex")
  tree1000[[i]]$edge.length <- tree1000[[i]]$edge.length + 10^-7
  output <- phylosignal(traits[, 2], tree1000[[i]])
  bloms2[i, 1] <- output[[1]]
  bloms2[i, 2] <- output[[4]]
}

avgK2 <- colMeans(bloms2)[1]
prob2 <- length(which(bloms2[, 2] > 0.05)) / 1000





