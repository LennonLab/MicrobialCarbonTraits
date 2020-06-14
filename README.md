Microbial Carbon Traits
=====================

This repository contains open-source code, data, & text files for the microbial carbon traits project currently titled: Trait-based approach to bacterial growth efficiency. 

## Publication
Muscarella, M.E., Howey, X.M. and Lennon, J.T. (2020), Trait‐based approach to bacterial growth efficiency. Environ Microbiol. Accepted Author Manuscript. doi:10.1111/1462-2920.15120

## Goals

* **Aim 1.)** Determine metabolic profiles of HMWF culture collection using BioLog EcoPlates 

* **Aim 2.)** Determine metabolic potential of HMWF culture collection using Genomic Functional Potential Evaluation

* **Aim 3.)** Measure physiological traits including productivity, respiration, and growth efficiency using defined carbon sources

## Contents

* **bin:** 
  * *consenTRAIT.R*: consenTrait function from Adam Martiny's group
  * *curve_fit_fxs.R*: Code for fitting growth curves
  * *EcoPlate.R*: Code for analyzing ecoplate data
  * *grid.mle2.R*: Code for fitting grid maximum likelihood
  * *growthcurve_models.R*: Growth Curve Analysis scripts
  * *modified_Gomp.R*: Modified gomphertz growth curve function
  * *PresensInteractiveRegresssion.R*: Code for moving window regression with R
  * *PreSensRespiration.R*: Code to process presense respirometer data
  * *read.synergy.R*: Functions to import data from synergy plate reader
  * *ReadEcoPlate.R*: Function to import ecoplate data
  * *moleculetype_matrix.txt*: EcoPlate Molecule Grouping Matrix
  * *resource_matrix.txt*: EcoPlate Well ID Matrix

* **data:**
  * *CellCounts*: Directory with cell count data from experiments
  * *EcoPlate*: Directory with EcoPlate data from experiments
  * *Old Genomes*: Directory with Amino Acid annotations for HMWF genomes (OLD Genome Annotations)
  * *GrowthCurves*: Directory with growth curve data and output
  * *Maple*: Directory with GenBank genome annotations and Maple output
  * *Phylogeny*: Directory with 16S sequences and RAxML phylogeny
  * *Production*: Raw data for bacterial production
  * *Respiration*: Raw data for bacterial respiration
  * *RespiratoryQuotient*: Raw CO2 data for RQ calculations
  * *16SrRNA.txt*: rRNA copy number data
  * *ABS-Cells.txt*: Absorbance to cell density values
  * *BGE_data.txt*: Growth efficiency output data
  * *BP_data.txt*: Production output data
  * *BR_data.txt*: Respiration output data
  * *eco.data.txt*: Ecoplate output data
  * *umax.txt*: Maximum growth rate output data

* **analyses:**
  * *CarbonTraits.Rmd*
  * *CarbonTraitsEcoPlate.R*
  * *CarbonTraitsGrowthRate.R*
  * *CarbonTraitsPreSens.R*
  * *CarbonTraitsProduction.R*
  * *CarbonTraitsRespiration.R*

* **figures:**
  * *OLD*: Directory with all of the old figures (remove soon)
  * Figure1.png - Chemicals used in the incubations
  * Figure2.png - Phylogenetic tree with BGE values
  * Figure3.png - Physiological tradeoffs
  * Figure4.png - Respiration / Production relationship
  * FigureS1.png
  * FigureS2.png


## Funding Sources  
  1. Huron Mountain Wildlife Foundation Grant (to JTL & MEM) - Browning of freshwater ecosystems: Will terrestrial carbon loading alter the diversity and function of aquatic microbial communities?  
  2. Indiana Academy of Sciences Grant (# 00375714 to MEM) - Metabolic Fate of Terrestrial Carbon Resources
  3. National Science Foundation (DEB‐0842441 to JTL, DEB‐1442246 to JTL and DEB‐1501164 to JTL & MEM)

## Sequencing Data
Isolate genomes are available on NCBI (BioProject PRJNA420393)

## Contributors

[Mario Muscarella](http://mmuscarella.github.io/): Postdoctoral Fellow in the [del Giorgio Lab]() and Research Associate II in the Institute of Arctic Biology at the University of Alaska Fairbanks. Former Ph.D. candidate in the [Lennon Lab](http://www.indiana.edu/~microbes/people.php). Conducted the experiments and analyzed the data

Xia Meng Howe: Former undergraduate Researchers in the [Lennon Lab](http://www.indiana.edu/~microbes/people.php). Conducted the experiments

[Dr. Jay Lennon](http://www.indiana.edu/~microbes/people.php): Principle Investigator, Associate Professor, Department of Biology, Indiana University, Bloomington. Head of the [Lennon Lab](http://www.indiana.edu/~microbes/people.php). 

