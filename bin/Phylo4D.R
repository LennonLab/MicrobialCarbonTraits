# Modified Table4D

table.phylo4d2 <- function (x, treetype = c("phylogram", "cladogram"), 
                           symbol = c("circles", "squares", "colors"), 
                           repVar = 1:ncol(tdata(x, type = "tip")), 
          center = TRUE, scale = TRUE, legend = TRUE, grid = TRUE, 
          box = TRUE, show.tip.label = TRUE, show.node.label = TRUE, 
          show.var.label = TRUE, ratio.tree = 1/3, font = 3, tip.label = tipLabels(x), 
          var.label = colnames(tdata(x, type = "tip")), cex.symbol = 1, 
          cex.label = 1, cex.legend = 1, pch = 20, col = heat.colors(100), 
          coord.legend = NULL, ...) 
{
  if (is.character(chk <- checkPhylo4(x))) 
    stop("bad phylo4d object: ", chk)
  if (cex.label < 0.1) {
    show.tip.label <- FALSE
    show.node.label <- FALSE
    show.var.label <- FALSE
  }
  cex <- par("cex")
  symbol <- match.arg(symbol)
  treetype <- match.arg(treetype)
  SYMBSCALE <- 0.2
  if (symbol == "colors") {
    SYMBSCALE <- 0.05
  }
  tre <- suppressWarnings(as(x, "phylo"))
  if (ncol(tdata(x, type = "tip")) == 0) {
    plot(tre, type = treetype, direction = "rightwards", 
         show.tip.label = show.tip.label, show.node.label = show.node.label, 
         cex = cex.label, no.margin = FALSE, x.lim = NULL, 
         y.lim = NULL, ...)
    return(invisible())
  }
  dat <- tdata(x, type = "tip")
  dat <- dat[, repVar, drop = FALSE]
  clas <- lapply(dat, class)
  isNum <- sapply(clas, function(e) e %in% c("integer", "numeric"))
  dat <- dat[, isNum, drop = FALSE]
  var.label <- var.label[repVar]
  var.label <- var.label[isNum]
  E <- phylobase::edges(x)
  tips.ord <- E[, 2][!E[, 2] %in% E[, 1]]
  dat <- dat[tips.ord, , FALSE]
  tip.label <- tip.label[tips.ord]
  dat <- as.data.frame(scale(dat, center = center, scale = scale))
  temp <- var.label[which.max(nchar(var.label))]
  lab.height <- strwidth(temp, units = "inches", cex = cex.label)
  lab.height <- lab.height/par("pin")[1]
  plotreg <- plotreg0 <- par("plt")
  plotreg.width <- plotreg0[2] - plotreg0[1]
  plotreg.height <- plotreg0[4] - plotreg0[3]
  plotreg[2] <- plotreg[1] + (ratio.tree) * plotreg.width
  plotreg[3] <- plotreg[3] + plotreg.height * ifelse(show.var.label, 
                                                     lab.height + 0.05, 0.05)
  plotreg[4] <- plotreg[4] - plotreg.height * 0.05
  par(plt = plotreg)
  plotres <- plot(tre, type = treetype, direction = "rightwards", 
                  show.tip.label = FALSE, show.node.label = show.node.label, 
                  cex = cex.label, no.margin = FALSE, x.lim = NULL, y.lim = NULL, 
                  ...)
  par(plt = plotreg0)
  cur.usr.width <- par("usr")[2] - par("usr")[1]
  usr.width <- cur.usr.width/ratio.tree
  usr.height <- par("usr")[4] - par("usr")[3]
  x.inset <- SYMBSCALE * cex.symbol * usr.width/par("pin")[1]
  y.inset <- SYMBSCALE * cex.symbol * usr.height/par("pin")[2]
  x.base <- plotres$x.lim[2] + x.inset
  if (show.tip.label) {
    temp <- tipLabels(x)[which.max(nchar(tipLabels(x)))]
    lab.width <- strwidth(temp, units = "user", cex = cex.label)
  }
  else {
    lab.width <- 0
  }
  xrange.data <- c(x.base, (par("usr")[1] + usr.width) - lab.width - 
                     2 * x.inset)
  if (diff(xrange.data) < (x.inset * ncol(dat))) 
    warning("There may not be enough room left to plot data; you may consider reducing ratio.tree or cex.label.")
  x.grid <- seq(xrange.data[1], xrange.data[2], length = ncol(dat))
  if (ncol(dat) == 1) {
    x.grid <- mean(c(xrange.data[1], xrange.data[2]))
  }
  y.grid <- seq(plotres$y.lim[1], plotres$y.lim[2], length = plotres$Ntip)
  temp <- expand.grid(y.grid, x.grid)
  xy.data <- data.frame(x = temp[, 2], y = temp[, 1])
  alldat <- cbind.data.frame(xy.data, unlist(dat))
  if (box) {
    box()
  }
  else {
    box(col = "transparent")
  }
  if (grid) {
    segments(x0 = x.grid, y0 = rep(min(y.grid), plotres$Ntip), 
             x1 = x.grid, y1 = rep(max(y.grid), plotres$Ntip), 
             col = "grey")
    segments(x0 = rep(min(x.grid), plotres$Ntip), y0 = y.grid, 
             x1 = rep(max(x.grid), plotres$Ntip), y1 = y.grid, 
             col = "grey")
  }
  makeColors <- function(x, col) {
    if (length(x) == 1) 
      return(col[1])
    nCol <- length(col)
    res <- x - min(x)
    res <- res/max(res)
    res <- res * (nCol - 1) + 1
    res <- round(res)
    res[res > nCol] <- nCol
    res[res < 1] <- 1
    return(col[res])
  }
  plotaux <- function(x, y, var, symbol, cex) {
    if (any(var[!is.na(var)] < 0)) {
      usebw <- TRUE
    }
    else {
      usebw <- FALSE
    }
    if (usebw) {
      ispos <- var > 0
      fg.col <- rep("black", length(var))
      fg.col[ispos] <- "white"
      bg.col <- rep("white", length(var))
      bg.col[ispos] <- "black"
      if (symbol == "squares") {
        symbols(x = x, y = y, squares = abs(var), inches = SYMBSCALE * 
                  cex, fg = fg.col, bg = bg.col, add = TRUE)
      }
      if (symbol == "circles") {
        symbols(x = x, y = y, circles = abs(var), inches = SYMBSCALE * 
                  cex, fg = fg.col, bg = bg.col, add = TRUE)
      }
      if (symbol == "colors") {
        myCol <- makeColors(var, col)
        points(x = x, y = y, pch = pch, cex = cex, bg = myCol, col = "gray")
      }
    }
    else {
      if (symbol == "squares") {
        symbols(x = x, y = y, squares = var, inches = SYMBSCALE * 
                  cex, fg = "white", bg = "black", add = TRUE)
      }
      if (symbol == "circles") {
        symbols(x = x, y = y, circles = var, inches = SYMBSCALE * 
                  cex, fg = "white", bg = "black", add = TRUE)
      }
      if (symbol == "colors") {
        myCol <- makeColors(var, col)
        points(x = x, y = y, pch = pch, cex = cex, bg = myCol, col = "gray")
      }
    }
    if (any(is.na(var))) {
      isNA <- is.na(var)
      points(x[isNA], y[isNA], pch = 4, cex = cex.symbol)
    }
  }
  plotaux(alldat[, 1], alldat[, 2], alldat[, 3], symbol, cex.symbol)
  if (show.var.label) 
    text(x = x.grid, y = rep(min(y.grid) - 1.5 * y.inset, 
                             ncol(dat)), lab = var.label, adj = 1, srt = 90, cex = cex.label)
  if (show.tip.label) {
    x.base <- xrange.data[2] + x.inset
    text(x = rep(x.base, plotres$Ntip), y = 1:plotres$Ntip - 0.1, 
         lab = tip.label, font = font, cex = 0.9, pos = 4)
  }
  if (legend) {
    addLegend <- function(x, y, z, cex.legend, cex.label, 
                          cex.symbol) {
      z <- z * cex.legend
      leg.values <- pretty(z, n = 4, min.n = 1)
      temp <- length(leg.values)
      if (temp > 4) {
        leg.values <- leg.values[c(1, 2, temp - 1, temp)]
      }
      leg.txt <- as.character(leg.values)
      if (symbol == "colors") {
        sym.w <- strwidth("o", units = "user", cex = cex.symbol)
        sym.w <- rep(sym.w, length(leg.values))
        sym.h <- strheight("o", units = "user", cex = cex.symbol)
        sym.h <- rep(sym.h, length(leg.values))
      }
      else {
        usr.w <- (par("usr")[2] - par("usr")[1])/ratio.tree
        usr.h <- par("usr")[4] - par("usr")[3]
        sym.w <- usr.w * ((abs(leg.values)/max(abs(leg.values))) * 
                            SYMBSCALE * cex.symbol * cex.legend)/par("pin")[1]
        sym.h <- usr.h * (SYMBSCALE * cex.symbol * cex.legend)/par("pin")[2]
      }
      ann.w <- strwidth(leg.txt, units = "user", cex = cex.label * 
                          cex.legend)
      ann.h <- strheight(leg.txt, units = "user", cex = cex.label * 
                           cex.legend)
      space.w.sym <- sapply(1:(length(sym.w) - 1), function(i) sum(sym.w[c(i, 
                                                                           i + 1)]))
      space.w.ann <- sapply(1:(length(ann.w) - 1), function(i) sum(ann.w[c(i, 
                                                                           i + 1)]))/2
      temp <- cbind(space.w.sym, space.w.ann)
      space.w <- apply(temp, 1, max)
      if (symbol == "colors") {
        space.h <- sym.h + ann.h 
      }
      else {
        space.w <- space.w + 0.01 * usr.w
        space.h <- sym.h + ann.h + 0.01 * usr.h
      }
      ann.coordX <- c(x, x + cumsum(space.w)) + max(sym.w[1], 
                                                    ann.w[1]) + 0.01 * usr.w
      ann.coordY <- y + 0.4 * space.h
      sym.coordX <- ann.coordX
      sym.coordY <- y + space.h
      text(ann.coordX, ann.coordY, leg.txt, cex = cex.label * 
             cex.legend)
      plotaux(sym.coordX, sym.coordY, leg.values, symbol, 
              cex.symbol * cex.legend)
    }
    if (!is.null(coord.legend)) {
      x.leg <- coord.legend$x
      y.leg <- coord.legend$y
    }
    else {
      usr.w <- (par("usr")[2] - par("usr")[1])/ratio.tree
      usr.h <- par("usr")[4] - par("usr")[3]
      temp <- lab.height * usr.height/(1 - lab.height)
      y.base <- par("usr")[3] - temp - y.inset
      x.leg <- par("usr")[1] + 0.01 * usr.w
      y.leg <- y.base
    }
    addLegend(x = x.leg, y = y.leg, z = alldat[, 3], cex.legend = cex.legend, 
              cex.label = cex.label, cex.symbol = cex.symbol)
  }
  return(invisible())
}