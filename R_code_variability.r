# R_code_variability.r

# settiamo la working directory e le library necessarie
setwd("C:/lab/") 
library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)
# install.packages("viridis")
library(viridis) # per la gestione dei colori 

# importiamo l'immagine sentinel.png dentro a R
# funzione brick: importa tutto l'intero blocco di dati
sentinel <- brick("sentinel.png")
sentinel
# class: RasterBrick 
# dimensions: 794, 798, 633612, 4  (nrow, ncol, ncell, nlayers)
# resolution: 1, 1  (x, y)
# extent: 0, 798, 0, 794  (xmin, xmax, ymin, ymax)
# crs: NA 
# source: C:/lab/sentinel.png 
# names: sentinel.1, sentinel.2, sentinel.3, sentinel.4 
# min values:          0,          0,          0,          0 
# max values:        255,        255,        255,        255 

# plottiamo i 3 livelli dell'immagine
# NIR:1, RED:2, GREEN 3
# di default: r=1 (infrarosso sulla componente red), g=2 (rosso sulla componente green), b=3 (verde sulla componente blue)
plotRGB(sentinel, stretch="Lin") # -> plotRGB(sentinel, r=1, g=2, b=3, stretch="Lin") 
# parte vegetata: rosso

# cambiamo la posizione del NIR (banda 1) e lo montiamo sulla componente verde
plotRGB(sentinel, r=2, g=1, b=3, stretch="Lin")
# parte vegetata: verde fluorescente
# roccia calcarea: viola
# acqua: nera perchè assorbe tutto il NIR 
#-------------------------------------------------------------------------------------------------------------------------

# deviazione standard 
# metodo moving window che mappa su una sola banda
# associamo i seguenti oggetti alle prime due bande (NIR e RED) 
nir <- sentinel$sentinel.1
red <- sentinel$sentinel.2
# calcoliamo l'NDVI (va da -1 a 1) 
ndvi <- (nir-red)/(nir+red)
# in questo modo abbiamo creato un singolo strato sulla quale calcolare la deviazione standard 

# plottiamo l’ndvi
plot(ndvi) 
# bianco: non c'è vegetazione (acqua, crepacci, suolo nudo)
# marroncino: roccia nuda 
# giallo/verde chiaro: parti di bosco 
# verde scuro: praterie sommitali 

# cambiamo la colorRampPalette: 
cl <- colorRampPalette(c('black','white','red','magenta','green'))(100) 
plot(ndvi, col=cl)

# calcoliamo la deviazione standard dell’immagine che è la variaiblità dell'immagine
# funzione focal: funzione generica che calcola la statistica che vogliamo
# primo argomento: nome dell’immagine
# secondo argomento: w (window) uguale ad una matrice che è la nostra finestra spaziale e normalmente è quadrata (1/n.pixeltot, n.righe, n.colonne)
# terzo argomento: stiamo calcolando la deviazione standard che viene definita sd
# associamo il risultato della funzione all'oggetto ndvisd3 (deviazione standard di ndvi con una finestra mobile di 3x3 pixel) 
ndvisd3 <- focal(ndvi, w=matrix(1/9, nrow=3, ncol=3), fun=sd)

# facciamo il plot 
plot(ndvisd3) 

# cambiamo la colorRampPalette
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
plot(ndvisd3, col=clsd)
# vediamo la variazione della deviazione standard all'interno dell'immagine, rosso/giallo: deviazione standard più alta, blu: deviazione standard più bassa
# deviazione standard blu -> molto bassa nelle parti più omogenee della roccia nuda (copertura omogenea di roccia) 
# deviazione standard verde -> aumenta nelle zone dove si passa da roccia nuda alla parte vegetata
# poi la deviazione standard ritorna molto omogenea (e diminuisce) su tutte le parti vegetate omogenee (come le praterie di alta quota)
# deviazione standard rossa -> la più alta e corrisponde alle zone dei crepacci e ombreggiature 
# ------------------------------------------------------------------------------------------------------------------------------------------------------------

# media ndvi
# calcoliamo la media della biomassa all’interno della nostra immagine
# funzione focal
# primo argomento: nome immagine
# secondo argomento: window=matrice(1/n.pixeltot, n.righe, n.colonne) 
# terzo argomento: vogliamo calcolare la media che viene definita mean
# oggetto ndvimean3: media di ndvi con 3x3 pixel 
ndvimean3 <- focal(ndvi, w=matrix(1/9, nrow=3, ncol=3), fun=mean)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
plot(ndvimean3, col=clsd)
# media gialla -> valori molto alti nelle praterie ad alta quota
# media rossa -> abbastanza alta parte seminaturale di boschi latifoglie insieme a boschi di conifere e arbusti 
# media verde/blu -> valori più bassi di roccia nuda 
# ------------------------------------------------------------------------------------------------------------------------

# cambiamo la grandezza della finestra e la aumentiamo
# calcoliamo la deviazione standard basata su una finestra di 5x5 pixel
ndvisd5 <- focal(ndvi, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
plot(ndvisd5, col=clsd)
# bassa deviazione standard -> roccia nuda
# aumenta -> per la differenziazione all’interno della roccia stessa e all’interno della vegetazione
# poi diminuisce -> nella vegetazione delle praterie ad alta quota
# alta deviazione standard -> crepacci e ombre 
# -------------------------------------------------------------------------------------------------------------------------

# PCA
# altra tecnica per compattare dei dati
# analisi multivariata su tutto il set di bande
# dall'analisi multivariata ricaviamo la PC1 sulla quale facciamo il calcolo della deviazione standard
# funzione rasterPCA: fa l’analisi delle componenti principali per i raster e si trova nel pacchetto RStoolbox
# argomento: nome dell'immagine (sentinel) 
# associamo il risultato della funzione all'oggetto sentpca
sentpca <- rasterPCA(sentinel)

# plottiamo il sentpca con la sua mappa associata 
plot(sentpca$map)
# vediamo le 4 bande e la % di variabilità che spiegano 
# PC1: banda che mantiene il range più ampio spiegato, dunque ha una % di info più alta, è molto simile all’informazione originale
# man mano che passiamo da una PC all’altra diminuisce il numero di informazione

sentpca
# $call
# rasterPCA(img = sentinel) -> funzione con la quale l'abbiamo chiamata

# $model
# Call:
# princomp(cor = spca, covmat = covMat[[1]]) -> principal component (cor: matrice di correlazione che è basata sulla matrice di covarianza, come covariano i pixel originali tra loro) 
# Standard deviations:
#  Comp.1    Comp.2    Comp.3    Comp.4     -> quanto spiega ogni singola componente principale (PC)
#  77.33628  53.51455   5.76560   0.00000 
# 4  variables and  633612 observations.

# $map
# class: RasterBrick 
# dimensions: 794, 798, 633612, 4  (nrow, ncol, ncell, nlayers)
# resolution: 1, 1  (x, y)
# extent: 0, 798, 0, 794  (xmin, xmax, ymin, ymax)
# crs: NA 
# source: memory
# names:       PC1,       PC2,       PC3,       PC4 
# min values: -227.1124, -106.4863,  -74.6048,    0.0000 
# max values: 133.48720, 155.87991,  51.56744,   0.00000 

# attr(,"class")    -> class: tipo di file 
# [1] "rasterPCA" "RStoolbox"  

# facciamo un summary della PCA del modello per vedere quanta variabilità iniziale spiegano le componenti
summary(sentpca$model)
# Importance of components:
#                            Comp.1      Comp.2      Comp.3     Comp.4
# Standard deviation     77.3362848   53.5145531   5.765599616     0
# Proportion of Variance  0.6736804   0.3225753   0.003744348      0
# Cumulative Proportion   0.6736804   0.9962557   1.000000000      1

# la prima componente principale (PC1) è quella che spiega lo 0,6736 quindi circa il 67% dell’informazione originale
# a partire da questa immagine della PCA facciamo il calcolo della variabilità
# significa che calcoliamo la deviazione standard sulla PC1












