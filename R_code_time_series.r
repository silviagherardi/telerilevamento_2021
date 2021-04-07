# TIME SERIES ANALYSIS
# Analizziamo l'incremento della temperatura in Groenlandia
# Data and code from Emanuela Cosma

# install.packages("raster")
library(raster)
# percorso Windows per lavorare con la cartella greenland che si trova dentro la cartella lab
setwd("C:/lab/greenland") 

# funzione RASTER: serve per caricare singoli dati, in questo caso singoli strati (diversa dalla funzione brick che importa un intero pacchetto di dati)
# associamo il risultato della funzione all'oggetto lst_2000 (nome dell'immagine)
lst_2000 <- raster("lst_2000.tif")
# plottiamo l'immagine lst_2000 per vedere cosa contiene
plot(lst_2000)
# immagine del 2005
lst_2005 <- raster("lst_2005.tif")
plot(lst_2005)
# immagine del 2010
lst_2010 <- raster("lst_2010.tif")
plot(lst_2010)
# immagine del 2015
lst_2015 <- raster("lst_2015.tif")
plot(lst_2015)

# richiamiamo l'immagine per vedere alcune informazioni
lst_2005
# values: 0, 65535  (min, max) -> immagine a 16 bit, 2^16 = 65.356 valori possibili

# ESERCIZIO: creiamo un multiframe con le 4 immagini in un quadrato 2x2
par(mfrow=c(2,2))
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)

# CREIAMO UN PACCHETTO UNICO COSTITUITO DAI 4 FILE
# 1- funzione LIST.FILES: 
rlist <- list.files(pattern="lst")  
rlist
# 2 - funzione IMPORT: 
import <- lapply(rlist,raster)
import
# 3- funzione STACK: 
TGr <- stack(import)
plot(TGr)

# 
plotRGB(TGr, 1, 2, 3, stretch="Lin")
#
plotRGB(TGr, 2, 3, 4, stretch="Lin")

# installare il pacchetto rasterVis
install.packages("rasterVis")
library(rasterVis)
# ----------------------------------------------------------------------------------------------





