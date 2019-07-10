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
tree <- read.tree("./data/Phylogeny/HMWF.proteo.nwk.tre")

# Keep Rooted but Drop Outgroup Branch
tree <- drop.tip(tree, "Aquifex")
tree$edge.length <- tree$edge.length + 10^-7

# Make Plot
# Define Color Palette
mypalette <- colorRampPalette(brewer.pal(9, "YlOrRd"), bias = 2)

# Map Carbon Respiration Traits {adephylo}
Resp <- BR[,c(11, 13, 15)]
Resp[is.na(Resp)] <- 0
Resp[Resp > 30] <- 30
colnames(Resp) <- c("Glucose", "Succinate", "Protocatechuate")
rownames(Resp) <- BR$Organism

# Reorder Resp
Resp <- as.matrix(Resp[match(tree$tip.label, row.names(Resp)), ])

par(mar=c(1,1,1,2) + 0.1)
x <- phylo4d(tree, Resp)
table.phylo4d(x, treetype = "phylo", symbol = "colors", show.node = FALSE,
              cex.label = 0.8, scale = FALSE, use.edge.length = FALSE,
              edge.color = "black", edge.width = 3, box = FALSE,
              col=mypalette(100), pch = 15, cex.symbol = 2.5,
              ratio.tree = 0.60, cex.legend = 1.5, center = FALSE,
              )
mtext(expression(paste("pmole C cell"^-1, "hr"^-1, "                ")), side = 1, cex = 1.2)
text(18.5, 22.5, expression(alpha), cex=1.5)
text(18.5, 19.5, expression(beta), cex=1.5)
text(4, 13, expression(gamma), cex=1.5)
text(11.5, 17, "Xan.", cex=1)
text(11.5, 12, "Aero.", cex=1)
text(11.5, 7.5, "Pseu.", cex=1)

# Map Carbon Production Traits {adephylo}
Prod <- BP[,c(11, 13, 15)]
Prod[is.na(Prod)] <- 0
Prod[Prod < 0] <- 0
Prod[Prod > 10] <- 10
colnames(Prod) <- c("Glucose", "Succinate", "Protocatechuate")
rownames(Prod) <- BP$Organism

# Reorder Prod
Prod <- as.matrix(Prod[match(tree$tip.label, row.names(Prod)), ])


par(mar=c(1,1,1,2) + 0.1)
x <- phylo4d(tree, Prod)
table.phylo4d(x, treetype = "phylo", symbol = "colors", show.node = FALSE,
              cex.label = 0.8, scale = FALSE, use.edge.length = FALSE,
              edge.color = "black", edge.width = 3, box = FALSE,
              col=mypalette(25), pch = 15, cex.symbol = 2.5,
              ratio.tree = 0.60, cex.legend = 1.5, center = FALSE)
mtext(expression(paste("pmole C cell"^-1, "hr"^-1, "                ")), side = 1, cex = 1.2)
text(18.5, 22.5, expression(alpha), cex=1.5)
text(18.5, 19.5, expression(beta), cex=1.5)
text(4, 13, expression(gamma), cex=1.5)
text(11.5, 17, "Xan.", cex=1)
text(11.5, 12, "Aero.", cex=1)
text(11.5, 7.5, "Pseu.", cex=1)


# Map Carbon BGE Traits {adephylo}
BGE2 <- BGE[,2:4]
BGE2[is.na(BGE2)] <- 0
BGE2[BGE2 < 0] <- 0
BGE2[BGE2 > 0.9] <- 0
colnames(BGE2) <- c("Glucose", "Succinate", "Protocatechuate")
rownames(BGE2) <- BGE$Organism

# Reorder BGE
BGE2 <- as.matrix(BGE2[match(tree$tip.label, row.names(BGE2)), ])


par(mar=c(1,1,1,2) + 0.1)
x <- phylo4d(tree, BGE2)
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


# Hypothesis Testing

traits <- cbind(Resp, Prod, BGE2)

# Import Phylogeny (already rooted)
tree1000 <- read.tree("./data/Phylogeny/RAxML_1000bootstrap.HMWF.tre")


# Reorder Traits
tree1000[[1]] <- drop.tip(tree1000[[1]], "Aquifex")
traits <- as.matrix(traits[match(tree1000[[1]]$tip.label, row.names(traits)), ])




# Blomberg's K - Resp
bloms1 <- matrix(NA, 1000, 6)
colnames(bloms1) <- c("K_g", "K_s", "K_p", "P_g", "P_s", "P_p")
for (i in 1:3){
  for (j in 1:1000){
    tree1000[[j]] <- drop.tip(tree1000[[j]], "Aquifex")
    tree1000[[j]]$edge.length <- tree1000[[j]]$edge.length + 10^-7
    output <- phylosignal(traits[, i], tree1000[[j]])
    bloms1[j, i] <- output[[1]]
    bloms1[j, 3+i] <- output[[4]]
}}

avgK1 <- colMeans(bloms1)[1:3]
avgP <- colMeans(bloms1)[4:6]
length(which(bloms1[, 4] > 0.05)) / 1000
length(which(bloms1[, 5] > 0.05)) / 1000
length(which(bloms1[, 5] > 0.05)) / 1000

# Blomberg's K - Prod
bloms2 <- matrix(NA, 1000, 6)
colnames(bloms2) <- c("K_g", "K_s", "K_p", "P_g", "P_s", "P_p")
for (i in 1:3){
  for (j in 1:1000){
    tree1000[[j]] <- drop.tip(tree1000[[j]], "Aquifex")
    tree1000[[j]]$edge.length <- tree1000[[j]]$edge.length + 10^-7
    output <- phylosignal(traits[, 3 + i], tree1000[[j]])
    bloms2[j, i] <- output[[1]]
    bloms2[j, 3+i] <- output[[4]]
  }}

avgK1 <- colMeans(bloms2)[1:3]
avgP <- colMeans(bloms2)[4:6]
length(which(bloms2[, 4] > 0.05)) / 1000
length(which(bloms2[, 5] > 0.05)) / 1000
length(which(bloms2[, 5] > 0.05)) / 1000



# Blomberg's K - BGE
bloms3 <- matrix(NA, 1000, 6)
colnames(bloms3) <- c("K_g", "K_s", "K_p", "P_g", "P_s", "P_p")
for (i in 1:3){
  for (j in 1:1000){
    tree1000[[j]] <- drop.tip(tree1000[[j]], "Aquifex")
    tree1000[[j]]$edge.length <- tree1000[[j]]$edge.length + 10^-7
    output <- phylosignal(traits[, 6 + i], tree1000[[j]])
    bloms3[j, i] <- output[[1]]
    bloms3[j, 3+i] <- output[[4]]
  }}

avgK1 <- colMeans(bloms3)[1:3]
avgP <- colMeans(bloms3)[4:6]
length(which(bloms3[, 4] > 0.05)) / 1000
length(which(bloms3[, 5] > 0.05)) / 1000
length(which(bloms3[, 5] > 0.05)) / 1000


phylosignal(traits[, 6 + i], tree)


# Varaince Partitioning
BGE3 <- as.data.frame(BGE2)
BGE3$ID <- row.names(BGE3)
BGE3$Taxon <- c("Pseudo", "Pseudo", "Pseudo", "Pseudo", "Pseudo", "Pseudo", "Pseudo",
                "Pseudo", "Pseudo", "Aero", "Aero", "Aero", "Aero", "Aero", "Xantho",
                "Xanto", "Xanto", "Beta", "Beta", "Beta", "Alpha", "Alpha", "Alpha")
BGE3$TaxonP <- c("Gamma", "Gamma", "Gamma", "Gamma", "Gamma", "Gamma", "Gamma",
                "Gamma", "Gamma", "Gamma", "Gamma", "Gamma", "Gamma", "Gamma", "Gamma",
                "Gamma", "Gamma", "Beta", "Beta", "Beta", "Alpha", "Alpha", "Alpha")



# Mixed Model
BGE.l <- melt(BGE3)
model <- glm(log1p(BGE.l$value) ~ as.factor(BGE.l$Taxon) + as.factor(BGE.l$variable))
summary(model)

1 - (0.29902/0.40510)
1 - (0.35154/0.40510)

Anova(model, type="III")


# Mixed Model
BGE.l <- melt(BGE3)
model <- glm(log1p(BGE.l$value) ~ as.factor(BGE.l$Taxon))
summary(model)

1 - (0.32573/0.40510)

# Mixed Model
BGE.l <- melt(BGE3)
model <- glm(log1p(BGE.l$value) ~ as.factor(BGE.l$TaxonP))
summary(model)

1 - (0.37824/0.40510)

Anova(model, type="III")


# Mixed Model
BGE.l <- melt(BGE3)
model <- glm(log1p(BGE.l$value) ~ as.factor(BGE.l$variable))
summary(model)
1 - (0.3784/0.40510)





# Variance Partitioning








# Crap I haven't worked out



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
