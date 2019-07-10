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
ecoplate <- read.delim("./data/EcoPlate/eco.data.txt", row.names=1)

# Some Maple Math
maple.2 <- (round(maple, 0) >= 90) * 1
maple.pathways <- rowSums(maple.2)
maple.data <- data.frame(maple.2, maple.pathways)

# Extract EcoPlate
eco.pathways <- data.frame(ecoplate$NumRes)
rownames(eco.pathways) <- rownames(ecoplate)

# Import Phylogeny (already rooted)
tree <- read.tree("./data/Phylogeny/HMWF.proteo.nwk.tre")

# Keep Rooted but Drop Outgroup Branch
tree <- drop.tip(tree, "Aquifex")
tree$edge.length <- tree$edge.length + 10^-7

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
text(4, 13, expression(gamma), cex=1.5)
text(11.5, 17, "Xan.", cex=1)
text(11.5, 12, "Aero.", cex=1)
text(11.5, 7.5, "Pseu.", cex=1)
rect(20, -5, 30, 0.1, col="white", border="white")
text(24.5, -1, "Example")

# Prediction Graphs
# Make Example Plot For Talks
Res1 <- as.data.frame(rep(20, 23))
Res2 <- as.data.frame(rep(10, 23))
Res3 <- as.data.frame(rep(2, 23))
Res <- data.frame(Res1, Res2, Res3)
colnames(Res) <- c("Resource A", "Resource B", "Resource C")
row.names(Res) <- row.names(copynum)

par(mar=c(1,1,1,2) + 0.1)
x <- phylo4d(tree, Res)
table.phylo4d(x, treetype = "phylo", symbol = "colors", show.node = FALSE,
              cex.label = 0.8, scale = FALSE, use.edge.length = FALSE,
              edge.color = "black", edge.width = 3, box = FALSE,
              col=mypalette(25), pch = 15, cex.symbol = 2.5,
              ratio.tree = 0.6, cex.legend = 1.5, center = FALSE,
              show.var.label=TRUE)

text(18.5, 22.5, expression(alpha), cex=1.5)
text(18.5, 19.5, expression(beta), cex=1.5)
text(4, 13, expression(gamma), cex=1.5)
text(11.5, 17, "Xan.", cex=1)
text(11.5, 12, "Aero.", cex=1)
text(11.5, 7.5, "Pseu.", cex=1)
mtext(expression(paste("pmole C cell"^-1, "hr"^-1, "               ")), side = 1, cex = 1.2)



# Make Example Plot For Talks
Res1 <- as.data.frame(rev(c(rep(3, 3), rep(5, 3), rep(12, 3), rep(8, 5), rep(18, 9))))
Res2 <- as.data.frame(rev(c(rep(3, 3), rep(5, 3), rep(12, 3), rep(8, 5), rep(18, 9))))
Res3 <- as.data.frame(rev(c(rep(3, 3), rep(5, 3), rep(12, 3), rep(8, 5), rep(18, 9))))
Res <- data.frame(Res1, Res2, Res3)
colnames(Res) <- c("Resource A", "Resource B", "Resource C")
row.names(Res) <- row.names(copynum)

par(mar=c(1,1,1,2) + 0.1)
x <- phylo4d(tree, Res)
table.phylo4d(x, treetype = "phylo", symbol = "colors", show.node = FALSE,
              cex.label = 0.8, scale = FALSE, use.edge.length = FALSE,
              edge.color = "black", edge.width = 3, box = FALSE,
              col=mypalette(25), pch = 15, cex.symbol = 2.5,
              ratio.tree = 0.6, cex.legend = 1.5, center = FALSE,
              show.var.label=TRUE)

text(18.5, 22.5, expression(alpha), cex=1.5)
text(18.5, 19.5, expression(beta), cex=1.5)
text(4, 13, expression(gamma), cex=1.5)
text(11.5, 17, "Xan.", cex=1)
text(11.5, 12, "Aero.", cex=1)
text(11.5, 7.5, "Pseu.", cex=1)
mtext(expression(paste("pmole C cell"^-1, "hr"^-1, "               ")), side = 1, cex = 1.2)








# Example of phylosignal
phylosignal(as.matrix(EX), tree)
phylosig(tree,as.matrix(EX),method="lambda",test=T)

################################################################################
# Example Data Using CopyNumber
par(mar=c(1,1,1,2) + 0.1)
colnames(copynum) <- "Example"
x <- phylo4d(tree, copynum)
table.phylo4d(x, treetype = "phylo", symbol = "colors", show.node = FALSE,
              cex.label = 0.8, scale = FALSE, use.edge.length = FALSE,
              edge.color = "black", edge.width = 3, box = FALSE,
              col=mypalette(25), pch = 15, cex.symbol = 2.5,
              ratio.tree = 0.75, cex.legend = 1.5, center = FALSE,
              show.var.label=TRUE)

text(18.5, 22.5, expression(alpha), cex=1.5)
text(18.5, 19.5, expression(beta), cex=1.5)
text(4, 13, expression(gamma), cex=1.5)
text(11.5, 17, "Xan.", cex=1)
text(11.5, 12, "Aero.", cex=1)
text(11.5, 7.5, "Pseu.", cex=1)
rect(20, -8, 30, 0.2, col="white", border="white")
text(24.5, -2, "16S rRNA\nCopy Number")

# Example of phylosignal
phylosignal(as.matrix(copynum), tree)
phylosig(tree,as.matrix(copynum),method="lambda",test=T)




# Genomic and Ecoplate Plot
traits <- as.data.frame(matrix(NA, length(tree$tip.label), 2))
row.names(traits) <- tree$tip.label
colnames(traits) <- c("EcoPlate", "Maple")

for (i in row.names(traits)){
  if(i %in% row.names(eco.pathways)){
    traits[which(row.names(traits) == i ), 1] <- eco.pathways[which(row.names(eco.pathways) == i), 1]
  } else {
    traits[which(row.names(traits) == i ), 1] <- min(eco.pathways)
  }
  if(i %in% names(maple.pathways)){
    traits[which(row.names(traits) == i ), 2] <- maple.pathways[which(names(maple.pathways) == i)]
  } else {
    traits[which(row.names(traits) == i ), 2] <- min(maple.pathways)
  }
}


par(mar=c(1,1,1,2) + 0.1)
x <- phylo4d(tree, traits)
table.phylo4d(x, treetype = "phylo", symbol = "colors", show.node = FALSE,
              cex.label = 0.8, scale = FALSE, use.edge.length = FALSE,
              edge.color = "black", edge.width = 3, box = FALSE,
              col=mypalette(25), pch = 15, cex.symbol = 2.5,
              ratio.tree = 0.60, cex.legend = 1.5, center = FALSE)
text(18.5, 22.5, expression(alpha), cex=1.5)
text(18.5, 19.5, expression(beta), cex=1.5)
text(4, 13, expression(gamma), cex=1.5)
text(11.5, 17, "Xan.", cex=1)
text(11.5, 12, "Aero.", cex=1)
text(11.5, 7.5, "Pseu.", cex=1)
mtext(expression(paste("pmole C cell"^-1, "hr"^-1, "                ")), side = 1, cex = 1.2)


# Import Phylogeny (already rooted)
tree1000 <- read.tree("./data/Phylogeny/RAxML_1000bootstrap.HMWF.tre")

# Reorder Traits
tree1000[[1]] <- drop.tip(tree1000[[1]], "Aquifex")
traits <- as.matrix(traits[match(tree1000[[1]]$tip.label, row.names(traits)), ])

# Blomberg's K - EcoPlate
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
prob1 <- length(which(bloms1[, 2] > 0.05)) / 1000


# Blomberg's K - Maple Pathways
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


# Mantel Test
# Read Alignment File {seqinr}
read.aln <- read.alignment(file = "./data/Phylogeny/HMWF_16S_long.filter.proteo.sina2.fasta", format = "fasta")
p.DNAbin <- as.DNAbin(read.aln)
# Create Distance Matrix with "raw" Model {ape}
seq.dist.raw <- dist.dna(p.DNAbin, model = "F84", pairwise.deletion = FALSE)

ecoplate2 <- ecoplate

p.DNAbin2 <- p.DNAbin[row.names(p.DNAbin) %in% intersect(row.names(ecoplate), row.names(p.DNAbin)), ]
seq.dist.raw <- dist.dna(p.DNAbin2, model = "F84", pairwise.deletion = FALSE)

ecoplate2 <- ecoplate[row.names(ecoplate) %in% intersect(row.names(ecoplate), row.names(p.DNAbin)), ]


eco.dist <- dist(ecoplate2)
mantel(eco.dist, seq.dist.raw)



p.DNAbin2 <- p.DNAbin[row.names(p.DNAbin) %in% intersect(row.names(maple), row.names(p.DNAbin)), ]
seq.dist.raw <- dist.dna(p.DNAbin2, model = "F84", pairwise.deletion = FALSE)

maple2 <- maple[row.names(maple) %in% intersect(row.names(maple), row.names(p.DNAbin)), ]


maple.dist <- dist(maple2)
mantel(maple.dist, seq.dist.raw, method="spearman")


map.dist <- dist(maple)


