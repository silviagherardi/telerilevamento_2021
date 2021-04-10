# TIME SERIES ANALYSIS: importare una serie di dati multitemporali da satellite e analizzarli
# analizziamo nel tempo l'incremento della temperatura in Groenlandia
# data and code from Emanuela Cosma

# caricare il pacchetto raster 
# install.packages("raster")
library(raster)
# cambiare la working directory: percorso Windows per gestire i dati dentro la cartella greenland 
setwd("C:/lab/greenland") 

# importiamo la singola immagine del 2000
# funzione raster: serve per IMPORTARE singoli dati/singoli strati, quindi crea un oggetto chiamato raster layer
# raster layer: oggetto formato da diversi layer di dati raster
# funzione diversa dalla funzione brick che importa un intero pacchetto di dati
# importiamo un singolo dato/strato che si trova fuori dal software R quindi utilizziamo le ""
# associamo il risultato della funzione all'oggetto che chiamiamo lst_2000 (nome dell'immagine)
lst_2000 <- raster("lst_2000.tif")

# funzione plot: VISUALIZZARE il file lst_2000  
plot(lst_2000)
# valori della scala graduata associata all'immagine: sono i valori interi possibili in funzione dei bit associati a questo file
# digital number: valori interi possibili
# > valore del digital number -> > valore di T per queste aree

# scriviamo il nome dell'immagine del 2000 per vedere le informazioni associate al file
lst_2000
# classe: Rasterlayer
# values: 0, 65.535  (min, max): immagine a 16 bit con 2^16 = 65.356 valori interi possibili che vanno da 0 a 65.355

# importiamo le restanti immagini del 2005 - 2010 - 2015 e le plottiamo per visualizzarle
# 2005
lst_2005 <- raster("lst_2005.tif")
plot(lst_2005)
# 2010
lst_2010 <- raster("lst_2010.tif")
plot(lst_2010)
# 2015
lst_2015 <- raster("lst_2015.tif")
plot(lst_2015)

# ESERCIZIO: creiamo un grafico con le 4 immagini (2000-2005-2010-2015) in un quadrato 2x2
par(mfrow=c(2,2))
plot(lst_2000)
plot(lst_2005)
plot(lst_2010)
plot(lst_2015)
# -------------------------------------------------------------------------------------------------------------------------------------------------

# funzione lapply
# metodo veloce per importare tutte le 4 immagini insieme piuttosto che applicare la funzione raster ad ogni files
# facciamo una lista di tutti i files lst e applicchiamo a tutti questi la funzione raster grazie alla funzione lapply
# si procede seguendo 2 step

# 1- funzione list.files: crea una lista di files che R utilizzerà per applicare la funzione lapply
# dobbiamo cercare i files che ci interessano attraverso il loro nome
# pattern: argomento della funzione list.files ed è la scritta che hanno in comune i nomi dei files
# pattern="lst" perchè tutti i files hanno in comune lst nel nome, essendo la scritta un testo va posta tra ""
# assocciamo l'oggetto rlist alla funzione list.files
rlist <- list.files(pattern="lst")  
rlist
# scriviamo l'oggetto della funzione: vediamo che R ci propone la lista con tutti i files della cartella greenland che contengono "lst" nel nome 
# a questa lista di files dobbiamo applicare la funzione raster tramite la funzione lapply

# 2- funzione lapply: serve per applicare una funzione (funzione raster) su tutti i files della lista appena creata
# lapply(X, FUN)
# X: lista di files, quindi l'oggetto associato alla funzione list.files
# FUN: funzione che vogliamo applicare a tutti i files della lista quindi la funzione raster
# associamo l'oggetto chiamato import alla funzione lapply 
import <- lapply(rlist,raster)
import
# scriviamo l'oggetto della funzione: vediamo tutte le informazioni relative ai 4 files 

# 3- funzione stack: raggruppiamo la lista dei 4 files contenuti nella cartella greenland in un unico file (blocco unico di files raster separati)
# argomento della funzione stack: import (oggeto della funzione lapply) -> tutti i 4 files della lista (rlist) a cui abbiamo applicato la funzione raster 
# TGr: Tgreenland è il nome dell'oggetto che associamo alla funzione stack
TGr <- stack(import)
# funzione plot: visualizziamo il file unico costituito dai 4 files raster separati
plot(TGr)

# ESERCITAZIONE: facciamo un plotRGB delle prime tre immagini: 1,2,3 (file 2000 sulla componente red, file 2005 sulla componente blu, file 2010 sulla componente green)
# primo argomento:   / secondo argomento: montiamo i file sulle componenti RGB / terzo argomento: stretch
plotRGB(TGr, 1,2,3, stretch="Lin")
#
plotRGB(TGr, 2,3,4, stretch="Lin")
# ----------------------------------------------------------------------------------------------


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









