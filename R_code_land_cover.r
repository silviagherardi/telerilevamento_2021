# R_code_land_cover.r

# impostiamo le library e la working directory
setwd("C:/lab/")
library(raster)
library(RStoolbox) # serve per la classificazione
# install.packages("ggplot2")
library(ggplot2) 

# BANDE -> NIR: banda 1; RED: banda 2; GREEN: banda 3

# brick: importiamo dentro R le immagini defor1 e defor2 che sono un pacchetto di dati
defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg") 

# plotRGB: banda 1 (NIR) sulla componente red, banda 2 (RED) sulla componente green, banda 3 (GREEN) sulla componente blue
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")

# funzione ggRGB: plottiamo le immagini raster con informazioni aggiuntive e in maniera più accattivante rispetto a plotRGB
# argomenti della funzione: immagine da plottare, 3 componenti RGB, stretch lineare
ggRGB(defor1, r=1, g=2, b=3, stretch="Lin") 
ggRGB(defor2, r=1, g=2, b=3, stretch="Lin") 

# funzione parmfrow: mettiamo una accanto all’altra le due immagini defor1-defor2 plottate con la funzione plotRGB
par(mfrow=c(1,2))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")

# multiframe with ggplot2 and gridExtra 
install.packages("gridExtra") # permette di usare il ggplot per dati raster
library(gridExtra) 

# la funzione parmfrow non funziona con immagini raster plottate con la funzione ggRGB
# funzione grid.arrange: compone il multiframe come ci piace, va a mettere insieme vari pezzi di un grafico
# p1: nome al primo ggRGB
# p2: nome al secondo ggRGB
p1 <- ggRGB(defor1, r=1, g=2, b=3, stretch="Lin") 
p2 <- ggRGB(defor2, r=1, g=2, b=3, stretch="Lin")
# argomenti della funzone: nome primo ggRGB, nome secondo ggRGB, nrow=2 (n. righe) 
grid.arrange(p1, p2, nrow=2)








