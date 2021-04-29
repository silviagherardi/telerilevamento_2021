# R_code_vegetation_indices.r

# librerie e working directory: 
library(raster)
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
