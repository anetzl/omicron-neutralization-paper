#setup page and load metadata
rm(list = ls())
library(Racmacs)
set.seed(100)

# ----------------------------------------------- read in maps -----------------------------------------------
conv_map <- read.acmap("./data/map/omicron_neut_conv_only_map.ace")
pv_map_conv <- read.acmap("./data/map/omicron_neut_PV_conv_only_map.ace")
lv_map_conv <- read.acmap("./data/map/omicron_neut_LV_conv_only_map.ace")


# function for plotting
# Get map plotting limits
lims <- Racmacs:::mapPlotLims(conv_map, sera = T, padding = 0.5)
lims$xlim <- c(-3, 5)
lims$ylim <- c(-3, 4)

# Setup plotting function
doplot <- function(map, label, show_labels = T) {
  
  # Setup the plot
  par(mar = c(0.1,0.5,0.1,0.5))
  
  # Plot the regular map
  srOutlineWidth(map) <- 2
  srOutline(map) <- adjustcolor(srOutline(map), alpha.f = 0.8)
  plot(map, xlim = lims$xlim, ylim = lims$ylim, fill.alpha = 0.9)
  if(show_labels) {
    # Plot labels
    label_adjustments <- matrix(0, numAntigens(map), 2)
    rownames(label_adjustments) <- agNames(map)
    label_adjustments["B.1.351",] <- c(0.5, 0.7)
    label_adjustments["P.1",] <- c(0.7, -0.6)
    label_adjustments["B.1.1.529",] <- c(-0.7, -0.6)
    label_adjustments["B.1.1.7",] <- c(0, 1)
    label_adjustments["D614G",] <- c(0, -0.5)
    label_adjustments["WT",] <- c(-0.5, -0.2)
    label_adjustments["B.1.617.2",] <- c(0, -0.6)
    
    
    labels <- agNames(map)
    names(labels) <- agNames(map)
    labels["B.1.351"] <- "Beta\n(B.1.351)"
    labels["P.1"] <- "Gamma\n(P.1)"
    labels["B.1.617.2"] <- "Delta\n(B.1.617.2)"
    labels["B.1.1.529"] <- "Omicron\n(B.1.1.529/BA.1)"
    labels["B.1.1.7"] <- "Alpha\n(B.1.1.7)"
    
    
    label_size <- rep(1.2, numAntigens(map))
    names(label_size) <- agNames(map)
    
    text(
      agCoords(map) + label_adjustments,
      cex = label_size,
      label = labels,
      font = 1
    )
  }
  
  text(
    x = lims$xlim[1]+0.5, 
    y = lims$ylim[2]-0.5,
    cex = 3,
    label = label,
    font = 1
  )
}

# Do the plots
pdf("./figures/map/omicron_antigen_type_maps.pdf", 7*1.4*1.1, 1.5*1.5*1.1)
layout(matrix(c(1:4), 1, 4, byrow = TRUE))
doplot(lv_map_conv, label = "A")
doplot(pv_map_conv, label = "B")
doplot(procrustesMap(lv_map_conv, conv_map, sera= FALSE), label = "C", show_labels = F)
doplot(procrustesMap(pv_map_conv, conv_map, sera= FALSE), label = "D", show_labels = F)
dev.off()

png("./figures/map/omicron_antigen_type_maps.png", 7*1.4*1.1, 1.5*1.5*1.1, units = "in", res = 300)
layout(matrix(c(1:4), 1, 4, byrow = TRUE))
doplot(lv_map_conv, label = "A")
doplot(pv_map_conv, label = "B")
doplot(procrustesMap(lv_map_conv, conv_map, sera= FALSE), label = "C", show_labels = F)
doplot(procrustesMap(pv_map_conv, conv_map, sera= FALSE), label = "D", show_labels = F)
dev.off()
# WT position on pseudo conv map so far off because most (all except 2) sera with WT titrations were only titrated against WT and Omicron
# results in no proper triangulation and positioning of WT with respect ot other antigens. One Corti has weirdly low D614G titers
# View(titerTable(pseudo_map_conv)[,titerTable(pseudo_map_conv)["WT",] != "*"])

