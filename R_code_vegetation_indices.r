# R_code_vegetation_indices.r 
# zone indagate: Rio Peixoto de Azevedo - centro Brasile (bordo foresta amazzonica) 

# librerie e working directory: 
# install.packaged("rasterdiv")
library(rasterdiv) 
library(rasterVis) # for levelplot 
library(raster)
library(RStoolbox) # for vegetation indices calculation
setwd("C:/lab/") 

# le due immagini sono RGB e contengono ciascuna 3 bande
# bande: b1 = NIR; b2 = red; b3 = green 
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

# DVI: calcoliamo l'indice di vegetazione per l'immagine defor1
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

# DVI: banda NIR - banda red -> defor1.1 - defor1.2 
# uniamo ogni banda alla propria immagine con il $ 
dvi1 <- defor1$defor1.1 - defor1$defor1.2
# per ogni pixel stiamo prendendo il valore di riflettanza della banda dell’infrarosso e lo sottraiamo al valore di riflettanza della banda del rosso
# dvi1 è la mappa del DVI: in uscita abbiamo una mappa formata da tanti pixel che sono la differenza tra infrarosso e rosso

# plottiamo la mappa dvi1
plot(dvi1)
# salute della vegetazione: colori chiari/gialli -> parte agricola; colore scuro/verde -> parte della foresta amazzonica 

# cambiamo la colorRampPalette
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi1, col=cl, main="DVI at time 1") 
# rosso scuro -> vegetazione; giallo -> campi agricoli 

# DVI: calcoliamo l'indice di vegetazione per l'immagine defor2
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

# DVI: banda NIR - banda red -> defor2.1 - defor2.2
dvi2 <- defor2$defor2.1 - defor2$defor2.2
# colorRampPalette precedente: cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi2, col=cl, main="DVI at time 2") 
# mappa dvi2: giallo -> parte agricola/vegetazione non in salute/suolo nudo; la foresta pluviale è stata quasi del tutto distrutta in questo luogo

# parmfrow delle due immagini (dvi1 e dvi2) a confronto con 2 righe e 1 colonna
# com'è cambiata nel tempo la situazione della vegetazione in questo luogo
par(mfrow=c(2,1))
plot(dvi1, col=cl, main=”DVI at time 1”)
plot(dvi2, col=cl, main=”DVI at time 2”) 

# ci chiediamo cos'è cambiato in questa stessa zona in tempi diversi
# prima mappa: dvi1; seconda mappa: dvi2 
# se il dvi è diminuito: prima mappa (foresta sana) avremo un valore di dvi1 più alto (255); seconda mappa (foresta distrutta) avremo un valore di dvi2 più basso (20)
# facciamo la differenza tra i due dvi -> dvi1 - dvi2 -> 255 - 20 
difdvi <- dvi1 - dvi2
# Warning message: In dvi1 - dvi2 : Raster objects have different extents. Result for their intersection is returned
# l'estensione delle due mappe non è la stessa, probabilmente una delle due mappe ha più pixel 

# plottiamo l'immagine difdvi (differenza del valore dvi dei pixel prima mappa e seconda mappa) 
# cambiamo la colorRampPalette 
cld <- colorRampPalette(c('blue','white','red'))(100) 
plot(difdvi, col=cld)
# zone rosse: valori di differenza (dvi1-dvi2) più marcati
# zone chiare bianche/blu: valori di differenza (dvi1-dvi2) meno marcati
# nella mappa le parti rosse ci indicano i punti dove c’è stata maggiore sofferenza da parte della vegetazione nel tempo (sofferenza per deforestazione)
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# NDVI
# calcoliamo il NDVI per le due situazioni (defor1 e defor2)
# il range del NDVI è sempre lo stesso indipendente dall’immagine -> -1 < NDVI < 1 
# l'indice serve per paragonare immagini che hanno risoluzione radiometrica diversa in entrata
# NDVI = (NIR - RED) / (NIR + RED) 

# NDVI per l'immagine defor1
# attenzione: alcuni software ragionano in modo sequenziale quindi mettere sempre le parentesi per i calcoli
ndvi1 <- (defor1$defor1.1 - defor1$defor1.2) / (defor1$defor1.1 + defor1$defor1.2)
plot(ndvi1, col=cl) 

# NDVI per l'immagine defor 2
ndvi2 <- (defor2$defor2.1 - defor2$defor2.2) / (defor2$defor2.1 + defor2$defor2.2)
plot(ndvi2, col=cl) 

# facciamo la differenza dei due ndvi (ndvi1-ndvi2) 
difndvi <- ndvi1 - ndvi2
cld <- colorRampPalette(c('blue','white','red'))(100) 
plot(difndvi, col=cld)
# difndvi: mappa dove in rosso abbiamo le aree con la maggiore perdita di vegetazione (differenza marcata tra i due ndvi)
# ---------------------------------------------------------------------------------------------------------------------------------

# funzione spectralIndices
# c’è anche un altro metodo per fare queste operazioni in modo rapido
# library(RStoolbox) # for vegetation indices calculation
# all'interno del pacchetto RStoolbox troviamo la funzione spectralIndices che calcola molti indici tra cui il DVI, l’NDVI, il SAVI (soil) ecc..
# utilizziamo la funzione spectralIndices per l'immagine defor1 
# primo argomento immagine: defor1 
# secondo argomento bande: banda 3 (green)-> green=3, banda 2 (red)-> red=2, banda 1 (NIR)-> nir=1
si <- spectralIndices(defor1, green = 3, red = 2, nir = 1)
plot(si, col=cl)
# risultato: calcola tutti gli indici (a parte quelli che hanno bisogno della banda del blu) e li mette tutti insieme

# facciamo lo spectralIndices anche per l'immagine defor2:
si2 <- spectralIndices(defor2, green = 3, red = 2, nir = 1)
plot(si2, col=cl)
# -----------------------------------------------------------------------------------------------------------------------

# worldwide NDVI
# andiamo a vedere come varia l’indice NDVI all’interno del pianeta tramite la funzione levelplot
# install.packages("rasterdiv")
library(rasterdiv) # for the worldwide NDVI
# all’interno del pacchetto troviamo un dataset gratuito chiamato copNDVI; l'input dataset è un indice NDVI ed è un Long-Term dataset

# carichiamo il dataset con la funzione plot
plot(copNDVI)
# mappa del NDVI nel mondo che racchiude anche l’acqua: viene individuata da codici all’interno del set che vanno dal valore 253 fino al 255

# l'acqua non ci interessa dunque dobbiamo eliminare i pixel di acqua
# funzione reclassify: permette di cambiare i valori in altri valori 
# i pixel 253-254-255 devono essere trasformati in non valori ovvero NA (not assigned) 
# primo argomento: nome dell'immagine quindi copNDVI
# secondo argomento: cbind(253:255, NA) -> significa che elimina i pixel 253-254-255 
copNDVI <- reclassify(copNDVI, cbind(253:255, NA))
plot(copNDVI)
# mappa del NDVI a scala globale senza l'acqua
# all'Equatore, nella parte del nord Europa e nord America l’NDVI è più alto 
# nella fascia dei deserti l'NDVI è più basso

# facciamo un levelplot per vedere i valori medi sulle righe e sulle colonne
# la funzione levelplot si trova dentro il pacchetto rasterVis
library(rasterVis) 
levelplot(copNDVI)
# vediamo come respira la terra dal 1999 al 2017
# valori più alti: foresta dell’Amazzonia, foreste del centro Africa, foreste del Borneo, foresta continua del nord Europa-nord Asia-nord America
# valori più bassi: deserti e grandi distese di neve
# -------------------------------------------------------------------------------------------------------------------------------------------------
