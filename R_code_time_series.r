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
# ----------------------------------------------------------------------------------------------

# 
# installare il pacchetto rasterVis: metodi di visualizzazione dei dati raster
install.packages("rasterVis")
library(rasterVis)
# definiamo di nuovo il percorso per utilizzare i dati dentro la cartella greenland
# setwd("C:/lab/greenland") 
# rlist <- list.files(pattern="lst")
# rlist
# import <- lapply(rlist,raster)
# import
# TGr <- stack(import)
# TGr

# funzione LEVELPLOT: 
levelplot(TGr)
# applicchiamo la stessa funzione levelplot al file TGr ma considerando ogni singolo strato
# $ per legare ogni singolo pezzo ad un altro
levelplot(TGr$lst_2000)

#
cl <- colorRampPalette(c("blue","light blue","pink","red"))(100)
levelplot(TGr, col.regions=cl)
# 
# names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))
levelplot(TGr, col.regions=cl, names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))
# 
# main="LST variation in time"
levelplot(TGr,col.regions=cl, main="LST variation in time", names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))
# -----------------------------------------------------------------------------------------------------------------------------

# MELT
# meltlist: creiamo una lista di tutti i file che hanno la parola melt in comune
meltlist <- list.files(pattern="melt")  
# 
melt_import <- lapply(meltlist,raster)
#
melt <- stack(melt_import)


# funzione plot: 
plot(melt)
# oggetto melt per vedere le informazioni che contiene
melt


levelplot(melt)
# sottrazione tra uno strato e l'altro
melt_amount <- melt$X2007annual_melt - melt$X1979annual_melt
clb <- colorRampPalette(c("blue","white","red"))(100)
plot(melt_amount, col=clb)

levelplot(melt_amount, col.regions=clb)


# --------------------------------------------------------------------------------------------------

# installare un pacchetto che serve per fare un report
install.packages("knitr") 
library(knitr) 









