# R_code_spectral_signatures.r

# impostiamo le librerie che ci servono
library(raster)
library(ggplot2)
library(rgdal)

# settiamo la working directory
setwd("C:/lab/") 

# carichiamo l'immagine defor2
defor2 <- brick("defor2.jpg")
defor2 
# class      : RasterBrick 
# dimensions : 478, 717, 342726, 3  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 717, 0, 478  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/lab/defor2.jpg 
# names      : defor2.1, defor2.2, defor2.3 
# min values :        0,        0,        0 
# max values :      255,      255,      255

# bande:
# defor2.1, defor2.2, defor2.3
# NIR, red, green 

# plottiamo l'immagine defor2 con plotRGB
# montiamo la banda 2.1 (NIR) sulla componente red, la banda 2.2 (red) sulla componente green e la banda 2.3 (green) sulla componente blu 
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin") 
plotRGB(defor2, r=1, g=2, b=3, stretch="hist") 

# firme spettrali 




