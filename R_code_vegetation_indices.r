# R_code_vegetation_indices.r
# zone indagate: Rio Peixoto de Azevedo - centro Brasile (bordo foresta amazzonica) 

# librerie e working directory: 
library(raster)
library(RStoolbox) # for vegetation indices calculation
setwd("C:/lab/") 

# le due immagini sono RGB e contengono ciascuna 3 bande
# b1 = NIR; b2 = red; b3 = green 
# funzione brick: importiamo dentro R le due immagini che sono blocchi di dati
defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg")

# facciamo un parmfrow per confrontare le due immagini scattate in tempi diversi
# 2 righe - 1 colonna
# le plottiamo con plotRGB / banda NIR (1) sulla componente red, banda del rosso (2) sulla componente green, banda del verde (3) sulla componente blue 
# stretch lineare
par(mfrow=c(2,1))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")
# la prima immagine riporta la foresta amazzonica ancora intatta, vediamo le zone rosse che sono vegetazione
# nella seconda immagine tutte le zone chiare sono suolo nudo e terreno agricolo, le zone rosse sono terreni agricoli vegetati


# DVI per defor1
defor1
# class: RasterBrick 
# dimensions: 478, 714, 341292, 3  (nrow, ncol, ncell, nlayers)
# resolution: 1, 1  (x, y)
# extent: 0, 714, 0, 478  (xmin, xmax, ymin, ymax)
# crs: NA 
# source: C:/lab/defor1.jpg 
# names: defor1.1, defor1.2, defor1.3              -> banda NIR: defor1.1 ; banda red: defor1.2
# min values:        0,        0,        0 
# max values:      255,      255,      255

# 
dvi1 <- defor1$defor1.1 - defor1$defor1.2

plot(dvi1)

cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi1, col=cl, main="DVI at time 1") 


# DVI per defor2
defor2
# class: RasterBrick 
# dimensions: 478, 717, 342726, 3  (nrow, ncol, ncell, nlayers)
# resolution: 1, 1  (x, y)
# extent: 0, 717, 0, 478  (xmin, xmax, ymin, ymax)
# crs: NA 
# source: C:/lab/defor2.jpg 
# names: defor2.1, defor2.2, defor2.3           -> banda NIR: defor2.1 ; banda red: defor2.2
# min values:        0,        0,        0 
# max values:      255,      255,      255

dvi2 <- defor2$defor2.1 - defor2$defor2.2
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi2, col=cl, main="DVI at time 2") 

par(mfrow=c(2,1))
plot(dvi1, col=cl, main=”DVI at time 1”)
plot(dvi2, col=cl, main=”DVI at time 2”) 

difdvi <- dvi1 - dvi2
# Warning message: In dvi1 - dvi2 : Raster objects have different extents. Result for their intersection is returned

cld <- colorRampPalette(c('blue','white','red'))(100) 
plot(difdvi, col=cld)

# NDVI
# (NIR - RED) / (NIR + RED) 
# NDVI per defor1
ndvi1 <- (defor1$defor1.1 - defor1$defor1.2) / (defor1$defor1.1 + defor1$defor1.2)
plot(ndvi1, col=cl) 

# NDVI per defor 2
ndvi2 <- (defor2$defor2.1 - defor2$defor2.2) / (defor2$defor2.1 + defor2$defor2.2)
plot(ndvi2, col=cl) 

# RStoolbox - funzione spectralIndices: 
si <- spectralIndices(defor1, green = 3, red = 2, nir = 1)
plot(si, col=cl)

# 
difndvi <- ndvi1 - ndvi2
cld <- colorRampPalette(c('blue','white','red'))(100) 
plot(difndvi, col=cld)













