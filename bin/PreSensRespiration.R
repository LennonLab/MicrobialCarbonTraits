################################################################################
#                                                                              #
# PreSens Respiration                                                          #
#   Version 0.1 - beta                                                         #
#                                                                              #
################################################################################
#                                                                              #
# Written by: Mario Muscarella                                                 #
#                                                                              #
# Last update: 2015/08/03                                                      #
#                                                                              #
################################################################################
#                                                                              #
# Notes: This code provides functions to be used in the analysis of            #
#        PreSens oxygen respiration data.                                      #
#        The uses supplies start and end times for the entire batch            #
#        This is NOT the interactive respiration tool                          #
#        The code supports txt files only.                                     #
#        The code supports both Row and Column format inputs                   #
#                                                                              #
# Issues:                                                                      #
#                                                                              #
# Recent Changes:                                                              #
#                                                                              #
# Future Changes (To-Do List):                                                 #
#         1.                                                                   #
#                                                                              #
################################################################################

PreSens.Respiration2 <- function(infile = " ", outfile = " ", start = "",
                                 end = "", name.in = "", in.format = "Rows",
                                 in.units = "mg", out.units = "uM"){

  # Global Options
  options(digits=6)

  # Import Data
  infile <- infile
  if (grepl(".txt", infile)){
    data.in <- read.delim(infile, header=F, skip=46, sep=";",strip.white=T,
                          stringsAsFactors=FALSE)[,1:29]
    head(data.in)
    if (in.format == "Rows"){
      colnames(data.in) <- c("Date", "Time", "A1", "A2", "A3", "A4", "A5", "A6",
                             "B1", "B2", "B3", "B4", "B5", "B6", "C1", "C2",
                             "C3", "C4", "C5", "C6", "D1", "D2", "D3", "D4",
                             "D5", "D6", "Blank", "Temp", "Error")
    } else {
      if (in.format =="Columns"){
        colnames(data.in) <- c("Date", "Time", "A1", "B1", "C1", "D1", "A2",
                               "B2", "C2", "D2", "A3", "B3", "C3", "D3", "A4",
                               "B4", "C4", "D4", "A5", "B5", "C5", "D5", "A6",
                               "B6", "C6", "D6", "Blank", "Temp", "Error")
      } else {
        stop("You must choose an input format")
      }}
  } else {
    print("File must be txt format")
  }

  # Input Transformations
  data.in$Date <- strptime(data.in[,1], format="%d.%m.%y%H:%M:%S")
  data.in <- as.data.frame(data.in)
  data.in[,3:26][data.in[,3:26] == "No Sensor"] <- NA
  for (i in 3:26){
    data.in[,i] <- as.numeric(data.in[, i])
  }
  data.in$Time <- round(data.in$Time/3600, 3) # Convert sec to Hrs
  if (in.units == out.units){
    # Do Nothing
  }else{
    if (in.units == "mg" & out.units == "uM"){
      data.in[,3:26] <- data.in[,3:26] * 1000/32 # Convert mg O2/L to uM O2
    } else {
    if (in.units == "uM" & out.units == "mg"){
      data.in[,3:26] <- data.in[,3:26] * 32/1000 # Convert uM O2/L to mg O2
    }
    }
  }

  # Define Output Unit
  if (out.units == "mg"){
    units <- "Rate (mg O2 Hr-1)"
  } else {
    if (out.units == "uM"){
      units <- "Rate (µM O2 Hr-1)"
    } else {
      stop("You must choose units as either mg or uM")
    }
  }

  # Define Samples
  samples <- as.factor(colnames(data.in)[3:26])

  # Remove Empty Samples
  if (length(samples) != length(name.in)){
    stop("Your input and names do not match")
  } else {
    # Do Nothing
  }

  # Creat Output
  output <- as.data.frame(matrix(NA, length(samples), 6))
  colnames(output) <- c("Sample", "Start", "End", units, "R2", "P-value")

  for (j in 1:length(samples)){
    if (name.in[j] == "Empty") {
      next
    } else {
    # Select sample
    samp <- data.in[, c("Date", "Time", "Temp", toString(samples[j]))]
    # Make data subset based on start & end time
    sub <- subset(samp, Time >= start)
    sub <- subset(sub, Time <= end)
    # Linear trend line lm & coefs / stats
    trend <- lm(sub[,4] ~ sub$Time)
    a <- as.numeric(coef(trend)[1]);  b <- as.numeric(coef(trend)[2])
    r2 <- round(summary(trend)$r.squared, 3)
    p <- round(anova(trend)$'Pr(>F)'[1], 4)
    p <- ifelse (p == 0, "<0.001", p)
    start.2 <- signif(start, digits = 3)
    end.2 <- signif(end, digits = 3)
    rate <- signif(-b,3)
    data.sample <- name.in[j]
    data.start <- start.2
    data.end <- end.2
    data.rate <- rate
    data.r2 <- r2
    data.p <- p
    output[j, ] <- c(data.sample, data.start, data.end, data.rate, data.r2, data.p)
    }}
  output <- na.omit(output)
  write.table(as.matrix(output), file=outfile, row.names=F, col.names=T, sep=",", quote=FALSE)
}
