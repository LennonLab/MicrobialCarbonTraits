Microbial Carbon Traits
=====================

This repository contains open-source code, data, & text files for the microbial carbon traits project currently titled: Trait-based approach to bacterial growth efficiency. 

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
  * *Production*:
  * *Respiration*:
  * *RespiratoryQuotient*:
  * *16SrRNA.txt*: rRNA copy number data
  * *ABS-Cells.txt*: Absorbance to cell density values
  * *BGE_data.txt*: Growth efficiency output data
  * *BP_data.txt*: Production output data
  * *BR_data.txt*: Respiration output data
  * *eco.data.txt*: Ecoplate output data
  * *umax.txt*: Maximum growth rate output data

* **analyses:**
  * *CarbonTraits.Rmd*: 
  * *CarbonTraitsEcoPlate.R*:
  * *CarbonTraitsGrowthRate.R*:
  * *CarbonTraitsPreSens.R*:
  * *CarbonTraitsProduction.R*:
  * *CarbonTraitsRespiration.R*:

* **figures:**
  * *OLD*: Directory with all of the old figures


* **analyses:**

* **figures:**

* **output:**

## Funding Sources  
  1. Huron Mountain Wildlife Foundation Grant (# ) - Browning of freshwater ecosystems: Will terrestrial carbon loading alter the diversity and function of aquatic microbial communities?  
  2. Indiana Academy of Sciences Grant (# 00375714) - Metabolic Fate of Terrestrial Carbon Resources

## Contributors

[Mario Muscarella](http://mmuscarella.github.io/): Ph.D. candidate in the [Lennon Lab](http://www.indiana.edu/~microbes/people.php). Conducted the experiments and analyzed the data

Xia Meng Howe: Undergraduate Researchers in the [Lennon Lab](http://www.indiana.edu/~microbes/people.php). Conducted the experiments

[Dr. Jay Lennon](http://www.indiana.edu/~microbes/people.php): Principle Investigator, Associate Professor, Department of Biology, Indiana University, Bloomington. Head of the [Lennon Lab](http://www.indiana.edu/~microbes/people.php). 

