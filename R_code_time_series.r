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

# ESERCITAZIONE: facciamo un plotRGB delle prime tre immagini
# 1,2,3: file 2000 sulla componente red, file 2005 sulla componente green, file 2010 sulla componente blue
# primo argomento: file unico  / secondo argomento: montiamo i file sulle componenti RGB / terzo argomento: stretch
plotRGB(TGr, 1,2,3, stretch="Lin")
# vediamo la sovrapposizione di 3 immagini tutte insieme (2000-2005-2010)
# SPIEGAZIONE: - colori rossi: valori lst più alti nella mappa del 2000 
#              - colori verdi: valori lst più alti nella mappa del 2005
#              - colori blu: valori lst più alti nella mappa del 2010
# la mappa totale è tendenzialmente blu (soprattutto al centro) significa che ho valori di lst più alti nel 2010

# 2,3,4: file 2005 sulla componente red, file 2010 sulla componente green, file 2015 sulla componente blue 
plotRGB(TGr, 2,3,4, stretch="Lin")
# otteniamo un’immagine simile a quella precedente, dove c’è la parte blu riguarda i valori di lst più alti nel 2015
# ----------------------------------------------------------------------------------------------------------------------------------------

# richiamiamo il pacchetto raster e definiamo di nuovo la working directory per gestire i dati dentro la cartella greenland
library(raster)
setwd("C:/lab/greenland")
# installare il pacchetto rasterVis: metodi di visualizzazione dei dati raster
install.packages("rasterVis")
library(rasterVis)

# dobbiamo ricreare l'unico file che contiene tutti e 4 i files raster (singoli strati) nella cartella greenland 
rlist <- list.files(pattern="lst")
rlist
import <- lapply(rlist,raster)
import
TGr <- stack(import)
# scriviamo l'oggetto della funzione stack per vedere le informazioni che contiene il file
TGr
# classe: Raster Stack
# dimensioni: 4.428.595 pixel per ogni livello
# nomi: sono i vari livelli quindi: lst_2000, lst_2005, lst_2010, lst_2015

# funzione levelplot: crea un grafico utilizzando il blocco intero (costituito dai 4 file) e una singola legenda
levelplot(TGr)
# vediamo le 4 mappe di lst derivate da immagini satellitari

# applicchiamo la stessa funzione levelplot al file TGr ma considerando solo lo strato interno del 2000
# $: corda per legare ogni singolo pezzo ad un altro -> RasterStack$strato2000
levelplot(TGr$lst_2000)
# grafico: si basa sui valori medi dei pixel per ogni colonna e per ogni riga 
# i punti più caldi della mappa (valori medi dei pixel più alti) rimangono a ovest
# i punti più freddi della mappa (valori medi dei pixel più bassi) sono al centro della mappa (in Groenlandia) 

# ESERCIZIO: cambiamo la colorRampPalette del TGr (RasterStack)
# blue: < T
# light blue: T intermedie
# red: > T
cl <- colorRampPalette(c("blue","light blue","pink","red"))(100)
# una volta cambiata la colorRampPalette plottiamo il file TGr con il levelplot
# col.regions: argomento della funzione levelplot per cambiare la colorRampPalette
levelplot(TGr, col.regions=cl)
# risultato: trend di cambiamento di T, dal 2000 al 2015 c'è un aumento graduale di T

# differenze plot e levelplot con la nuova colorRampPalette
plot(TGr, col=cl) # -> legenda, spazio minore, coordinate minori, gamma di colori meno ampia
levelplot(TGr, col.regions=cl)

# matrix algebra
# osserviamo la differenza di T tra il 2000 e il 2015 in Groenlandia
TGr_amount <- TGr$lst_2015 - TGr$lst_2000
TGr_amount
# class: RasterLayer 
# values: -1150, 1349  (min, max)
levelplot(TGr_amount, col.regions=cl, main="LST variation 2000-2015")

# cambiamo i nomi dei 4 livelli con la funzione levelplot (lst_2000 - lst_2005 - lst_2010 - lst_2015)
# i singoli strati di uno stack raster sono attributi
# le T dei 4 livelli sono state misurate a Luglio
# rinominiamo i livelli rispettivamente: "July 2000", "July 2005", "July 2010", "July 2015" e vanno tutti tra "" perchè sono dei testi 
# names.attr: argomento della funzione levelplot per rinominare i singoli attributi
# questi attributi sono caratteri di uno stesso argomento (nome) dunque vanno inseriti in un vettore c
# names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))
levelplot(TGr, col.regions=cl, names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))

# inseriamo il titolo totale della mappa finale 
# titolo: "LST variazion in time" e va tra "" perchè è un testo
# main: argomento della funzione levelplot per dare un titolo 
# main="LST variation in time"
levelplot(TGr,col.regions=cl, main="LST variation in time", names.attr=c("July 2000","July 2005", "July 2010", "July 2015"))
# ----------------------------------------------------------------------------------------------------------------------------------------

# Melt-data
# vogliamo ottenere una stima relativa sulla quantità di ghiaccio che è stata persa dal 1978 ad oggi

# creiamo un unico file Raster Stack costituito da tutti i files melt (sono molto numerosi perchè vanno dal 1979 al 2007)
# 1- funzione list.files
# meltlist: creiamo una lista di tutti i file melt 
# pattern: melt perchè è la parola che hanno in comune nel nome 
meltlist <- list.files(pattern="melt")  
meltlist
# 2- funzione lapply
melt_import <- lapply(meltlist,raster)
melt_import
# 2- funzione stack
melt <- stack(melt_import)
melt
# classe: Raster Stack
# bit: file a 16 bit con valori pari a 2^16 = 65.536 , da 0 a 65.535 
# nomi dei vari layers:  X1979annual_melt, X1980annual_melt, X1981annual_melt, X1982annual_melt, ... , X2007annual_melt 

# funzione plot: plottiamo il file melt (Raster Stack) costituito da tutti i suoi layers 
plot(melt)
# funzione levelplot: plottiamo il file melt (Raster Stack) ma con il levelplot
levelplot(melt)
# valori di scioglimento dei ghiacci: più alto è il valore e maggiore sarà lo scioglimento
# dal 1979 al 2007 la striscia di ghiacci persa è molto maggiore 

# matrix algebra
# vogliamo conoscere lo scioglimento dal 1979 al 2007 
# 2 layers: X2007annual_melt , X1979annual_melt
# i valori di scioglimento dei ghiacci sono basati sui bit
# sottrazione: valore dell'immagine del 2007 - valore dell'immagine del 1979
# > valore di differenza -> > scioglimento dei ghiacci (dal 1979 al 2007)  
# $: leghiamo il Raster Stack (melt) ai suoi layer 
# alla funzione di sottrazione associamo un oggetto chiamato melt_amount (quantità nel tempo di scioglimento dei ghiacci)
melt_amount <- melt$X2007annual_melt - melt$X1979annual_melt
melt_amount
# class: RasterLayer
# values: -87, 92  (min, max)

# cambiamo la colorRampPalette: 
# blue = valori più bassi di scioglimento
# white = valori medi
# red = valori più alti di scioglimento
clb <- colorRampPalette(c("blue","white","red"))(100)
# funzione plot di melt_amount
plot(melt_amount, col=clb)
# tutte le zone rosse sono quelle dove dal 1979 al 2007 c’è stato uno scioglimento dei ghiacci più alto

# funzione levelplot di melt_amount
levelplot(melt_amount, col.regions=clb)
# titolo: "melt_1979-2007"
levelplot(melt_amount, col.regions=clb, main="melt_1979-2007")
# conclusione: nella zona sud-ovest c'è il picco di scioglimento dei ghiacci in Groenlandia dal 1979 al 2007
# ---------------------------------------------------------------------------------------------------------------- 
