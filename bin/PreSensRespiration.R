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
                                 end = "", names = "", in.format = "Rows"){

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
  }}

  # Input Transformations
  data.in$Date <- strptime(data.in[,1], format="%d.%m.%y%H:%M:%S")
  data.in <- as.data.frame(data.in)
  data.in[,3:26][data.in[,3:26] == "No Sensor"] <- NA
  for (i in 3:26){
    data.in[,i] <- as.numeric(data.in[,i])
  }
  data.in$Time <- data.in$Time/3600 # Convert sec to Hrs

  # Creat Output
  output <- as.data.frame(matrix(NA, 24, 6))
  colnames(output) <- c("Sample", "Start", "End", "Rate (µM O2 Hr-1)", "R2", "P-value")

    # Define Samples
  samples <- as.factor(colnames(data.in)[3:26])

  for (i in samples) {
    # Select sample
    samp <- data.in[, c("Data", "Time", "Temp", i)]
    # Make data subset based on start & end time
    sub <- subset(samp, Time >= start)
    sub <- subset(sub, Time <= end)
    # Linear trend line lm & coefs / stats
    trend <- lm(sub$i ~ sub$Time)
    a <- as.numeric(coef(trend)[1]);  b <- as.numeric(coef(trend)[2])
    r2 <- round(summary(trend)$r.squared, 3)
    p <- round(anova(trend)$'Pr(>F)'[1], 4)
    p <- ifelse (p == 0, "<0.001", p)
    start.2 <- signif(start, digits = 3)
    end.2 <- signif(end, digits = 3)
    rate <- signif(-b,3)
    data.sample <- names[i]
    data.start <- start.2
    data.end <- end.2
    data.rate <- rate
    data.r2 <- r2
    data.p <- p
    data.out <- c(data.sample, data.start, data.end, data.rate, data.r2, data.p)


  }

  # Create Plotting Window
  windows()
  par(las=1)
  par(fig=c(0,1,0, 1), new = F)
  par(ps=9); par(cex.axis=c(0.9)); par(cex.lab=c(0.9)); par(oma=c(3,1,1,0.5)); par(mar=c(4,4,2,1))

  # Attach Data
  attach(data.in)

  ### rpanel function ################
  draw <- function(panel) {
    if (panel$end > panel$start)
    {start <- panel$start
    end <- panel$end}
    else
    {start <- min(Time)
    end <- max(Time)}

    data.in$samp <- panel$samp
    name <- panel$sample.name

    # Text placement points
    xaxis_pt <- max(Time) - 0.1*(max(Time)-min(Time))
    yaxis_pt <- 275

    # Make data subset based on start & end yrs
    sub <- subset(data.in, Time >= start)
    sub <- subset(sub, Time <= end)

    # Linear trend line lm & coefs / stats
    trend <- lm(sub$samp ~ sub$Time)
    a <- as.numeric(coef(trend)[1]);  b <- as.numeric(coef(trend)[2])
    r2 <- round(summary(trend)$r.squared, 3)
    p <- round(anova(trend)$'Pr(>F)'[1], 4)
    p <- ifelse (p == 0, "<0.001", p)
    start.2 <- signif(start, digits = 3)
    end.2 <- signif(end, digits = 3)
    rate <- signif(-b,3)

    # Make Basic plot
    plot(panel$samp ~ Time, type = "b", col = "darkgrey", xlab = "Time (Hrs)",
         ylab = expression(paste("Oxygen Concentration (?M O "[2],")")),
         par(bty="n"),xlim=c(0,max(Time)+1),ylim=c(0, 500),
         xaxs = "i", yaxs = "i", axes = FALSE, cex.main = 0.95,
         main = "Interactive Regression of PreSens Respiration Data")
    axis(1, col = "grey"); axis(2, col = "grey")

    # Calc vals for start-end regression line & add line
    x_vals = c(panel$start, panel$end)
    y_vals = c(a+b*panel$start, a+b*panel$end)
    lines(x_vals, y_vals, col= "red")
    points(sub$Time, sub$samp, pch = 19, col = "red", type = "p")
    text(xaxis_pt, yaxis_pt, paste("Sample: ", name))
    text(xaxis_pt, yaxis_pt - 10, paste("Period: ", start.2, " to " , end.2, "Hrs"))
    text(xaxis_pt, yaxis_pt - 20, bquote(Rate == .(rate) ~ uM ~ O[2] ~ Hr^-1), cex=1)
    text(xaxis_pt, yaxis_pt - 30, bquote(R^2 == .(r2)), cex=1)
    text(xaxis_pt, yaxis_pt - 40, paste("P-value = ", p), cex=1)

    ### Outer Margin Annotation
    my_date <- format(Sys.time(), "%m/%d/%y")
    mtext(script, side = 1, line = .75, cex=0.8, outer = T, adj = 0)
    mtext(my_date, side = 1, line =.75, cex = 0.8, outer = T, adj = 1)
    data.out <- list(Start=start, End=end, Rate=rate, R2=r2, Pvalue=p)
    panel
  }

  collect.data <- function(panel) {
    data.in$samp <- panel$samp
    name <- panel$sample.name
    start <- panel$start
    end <- panel$end
    # Text placement points
    xaxis_pt <- min(Time) + 0.25*(max(Time)-min(Time))
    yaxis_pt <- 200
    # Make data subset based on start & end yrs
    sub <- subset(data.in, Time >= start)
    sub <- subset(sub, Time <= end)
    # Linear trend line lm & coefs / stats
    trend <- lm(sub$samp ~ sub$Time)
    a <- as.numeric(coef(trend)[1]);  b <- as.numeric(coef(trend)[2])
    r2 <- round(summary(trend)$r.squared, 3)
    p <- round(anova(trend)$'Pr(>F)'[1], 4)
    p <- ifelse (p == 0, "<0.001", p)
    start.2 <- signif(start, digits = 3)
    end.2 <- signif(end, digits = 3)
    rate <- signif(-b,3)
    data.sample <- name
    data.start <- start.2
    data.end <- end.2
    data.rate <- rate
    data.r2 <- r2
    data.p <- p
    data.out <- c(data.sample, data.start, data.end, data.rate, data.r2, data.p)
    write.table(as.matrix(t(data.out)), file=outfile, append=T, row.names=F, col.names=F, sep=",", quote=FALSE)
    panel
  }

  end.session <- function(panel) {
    dev.off(2)
    print.noquote("Good-Bye: Computer Will Now Self-Destruct")
    panel
  }

  # rpanel controls - enter start and end yrs for portion of full data set to be used
  rpplot <- rp.control(title="Interactive Regression", start=0, end = max(Time), initval = samples[1])
  rp.listbox(rpplot, variable = samp, vals = "Samples", labels = samples, action = draw)
  rp.slider(rpplot, start, action = draw, from = 0, to =  max(Time))
  rp.slider(rpplot, end, action = draw, from = 0, to =  max(Time))
  rp.doublebutton(rpplot, var = start, step = 0.1, title = "Start Fine Adjustment", action = draw)
  rp.doublebutton(rpplot, var = end, step = 0.1, title = "End Fine Adjustment", action = draw)
  rp.textentry(rpplot, var = sample.name, action = draw, labels = "Sample Name", initval = "")
  rp.button(rpplot, title = "save", action = collect.data)
  rp.button(rpplot, title = "quit", action = end.session, quitbutton=T)

}
