# R Code Complete - Telerilevamento Geo-Ecologico

# ------------------------------------------------------------------------------------------------------------------------------------------------

# Summary:
# 1. R code remote sensing first code 
# 2. R code time series Greenland
# 3. R code Copernicus data
# 4. R code knitr 
# 5. R code multivariate analysis
# 6. R code classification
# 7. R code ggplot2
# 8. R code vegetation indices
# 9. R code land cover
# 10. R code variability 
# 11. R code spectral signatures

# ------------------------------------------------------------------------------------------------------------------------------------------------

# 1. R code remote sensing first code 

# Il mio primo codice in R per il telerilevamento!

# funzione install.packages: serve per INSTALLARE il pacchetto raster e gestire i dati in formato raster
# il pacchetto raster si scrive tra "" perchè si trova all'esterno del software R 
install.packages("raster") 
# funzione library: serve per UTILIZZARE il pacchetto raster, non mettiamo le "" perchè il pacchetto è già dentro R
library(raster) 

# funzione setwd: settiamo la working directory: percorso Windows per GESTIRE i dati contenuti nella cartella lab
setwd("C:/lab/") 

# funzione brick: serve per IMPORTARE dentro a R l'intera immagine satellitare costituita da tutte le sue singole bande (intero blocco)
# l'immagine satellitare va scritta tra "" perchè si trova all'esterno di R
# assegnare il risultato della funzione brick ad un oggetto chiamato con il nome dell'immagine
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# scriviamo il nome dell'immagine per conoscere le INFORMAZIONI relative al file raster
p224r63_2011
# - Classe: RasterBrick (7 bande in formato raster) 
# - Bande di Landsat:
# B1: blu
# B2: verde
# B3: rosso 
# B4: infrarosso vicino 
# B5: infrarosso medio
# B6: infrarosso termico 
# B7: infrarosso medio 

# funzione plot: serve per VISUALIZZARE i dati: in questo caso visualizziamo tutte le 7 bande dell'intera immagine satellitare
plot(p224r63_2011)



# colorRampPalette
# vogliamo cambiare la scala di colori di default 
# funzione colorRampPalette per CAMBIARE il COLORE delle 7 bande, ogni colore è un etichetta scritta tra ""
# le etichette dei colori sono caratteri di uno stesso argomento (colore) quindi vengono racchiusi all'interno di un VETTORE c 
# funzione(c("carattere 1","carattere 2","carattere 3"...))
# 100: livelli di ogni colore, sono fuori dalla funzione e sono un altro argomento 
# assegnare l'oggetto (cl) al risultato della funzione 
cl <- colorRampPalette(c("black","grey","light grey")) (100)
# funzione plot: visualizziamo l'immagine con la nuova palette di colori
# funzione(primo argomento:nome_immagine, secondo argomento:colore(col)=oggetto(cl))
plot(p224r63_2011, col=cl)

# ESERCIZIO: creiamo una nuova palette di colori scelta da noi e visualizziamo 
clb <- colorRampPalette(c("blue","pink","light pink","purple","green")) (100)
plot(p224r63_2011, col=clb)

# funzione dev off per RIPULIRE la finestra grafica (nel caso non si fosse chiusa manualmente) 
dev.off()

# funzione plot: visualizziamo l'immagine intera legata alla sua banda 1 
# simbolo $: LEGA i due blocchi, quindi lega l'intera immagine alla sua banda 1 
plot(p224r63_2011$B1_sre)

# ESERCIZIO: visualizzare solo la banda 1 con una scala di colori scelta da noi
cls <- colorRampPalette(c("blue","light blue","magenta","light pink","white")) (100)
# funzione(primo argomento:nome_immagine$banda1, secondo argomento:colore(col)=oggetto(cls))
plot(p224r63_2011$B1_sre, col=cls)



# par
# vogliamo visualizzare solo le bande che ci interessano (non tutte e nemmeno una singola), vogliamo vedere la banda del blu e la banda del verde:
# funzione par: crea un GRAFICO e serve per fare il settaggio dei vari parametri grafici
# stiamo facendo un multiframe -> mf e vogliamo un grafico con 1 riga e 2 colonne
# mfrow = n.righe, n.colonne oppure mfcol = n.colonne, n.righe
# par(mfrow=1,2)
# 1,2 sono due caratteri dello stesso argomento (n.righe,n.colonne) dunque li inseriamo in un VETTORE c
par(mfrow=c(1,2))
# plottiamo le due bande (blu - verde) legate ($) all'immagine intera 
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

# ESERICIZIO: plottiamo le due bande (blue - verde) su 2 righe e 1 colonna
par(mfrow=c(2,1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
# plottiamo le prime 4 bande di Landsat su 4 righe e 1 colonna
par(mfrow=c(4,1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
# plottiamo le prime 4 bande di Landsat in un quadrato 2x2
par(mfrow=c(2,2)) 
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)

# ESERCIZIO: plottiamo le prime 4 bande di Landsat in un quadrato 2x2
# per ogni banda assegniamo una colorRampPalette che faccia riferimento ai sensori di quella banda
# 1- funzione par mforw=2righe,2olonne / 2- oggetto <- funzione colorRampPalette / 3- funzione plot (nome_immagine$bandax, col=oggetto)
par(mfrow=c(2,2)) 
# B1(blu): colorRampPalette blue
clb <- colorRampPalette(c("dark blue","blue","light blue")) (100)
plot(p224r63_2011$B1_sre, col=clb)
# B2(verde): colorRampPalette green
clg <- colorRampPalette(c("dark green","green","light green")) (100)
plot(p224r63_2011$B2_sre, col=clg)
# B3(rosso): colorRampPalette red
clr <- colorRampPalette(c("dark red","red","pink")) (100)
plot(p224r63_2011$B3_sre, col=clr)
# B4(infrarosso vicino): colorRampPalette sfumature gialle
clnir <- colorRampPalette(c("red","orange","yellow")) (100)
plot(p224r63_2011$B4_sre, col=clnir)



# plotRGB
# visualizziamo i dati utilizzando lo schema RGB
# SCHEMA RGB: red,green,blue - per ogni componente dello schema RGB utilizziamo una banda 
# utilizziamo solo 3 bande per volta per visualizzare l'immagine intera 
# componente rossa R3 -> banda 3 (banda del rosso)
# componente verde G2 -> banda 2 (banda del verde)
# componente blu B1 -> banda 1 (banda del blu)

# visualizzare tutta l'immagine a colori naturali
# funzione plotRGB: VISUALIZZAZIONE, attraverso lo schema RGB, di un oggetto raster multi-layered (molte bande)
# primo argomento: nome_immagine / secondo argomento: quali componenti per ogni banda: r=3, g=2, b=1 / terzo argomento: stretch="Lin"
# stretch lineare per mostrare tutte le gradazioni di colore ed evitare uno schiacciamento verso una sola parte del colore
plotRGB(p224r63_2011,  r=3, g=2, b=1, stretch="Lin")

# visualizzare tutta l'immagine a falsi colori
# banda 4 (infrarosso vicino) sulla componente rossa, banda 3 (rosso) sulla componente verde, banda 2 (verde) sulla componente blu
# vegetazione tutta rossa 
plotRGB(p224r63_2011,  r=4, g=3, b=2, stretch="Lin") 
# banda 3 (rosso) sulla componente rossa, banda 4 (infrarosso vicino) sulla componente verde, banda 2 (verde) sulla componente blu
# vegetazione tutta verde e suolo nudo viola
plotRGB(p224r63_2011,  r=3, g=4, b=2, stretch="Lin")  
# banda 3 (rossa) sulla componente rossa, banda 2 (verde) sulla componente verde, banda 4 (infrarosso vicino) sulla componente blu
# vegetazione tutta blu e suolo nudo giallo
plotRGB(p224r63_2011,  r=3, g=2, b=4, stretch="Lin") 

#ESERCIZIO: facciamo un multiframe delle 4 immagini appena create e le mettiamo in un quadrato 2x2
par(mfrow=c(2,2)) 
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="Lin")

# funzione pdf: SALVIAMO le 4 immagini appena create come pdf nella cartella lab
# l'argomento è il nome del file tra "" e senza spazi
pdf("immagine_multiframe_2x2")
par(mfrow=c(2,2)) 
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="Lin")
dev.off()

# histogram stretch: non è lineare ma tira i valori intermedi di riflettanza al centro grazie ad una pendenza molto accentuata della curva
# immagine a colori falsi -> banda 4 (infrarosso vicino) sulla componente verde 
# confronto tra stretch lineare e histogram stretch
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="hist")
# l'immagine con l'histogram stretch ha particolari in più, nella foresta distinguiamo le zone di vegetazione più umide (in viola) ed il movimento dell'acqua

# ESERCIZIO: facciamo un par mfrow = 3righe, 1 colonna
# immagine a colori naturali (3,2,1) - immagine a colori falsi (infrarosso vicino sul verde) - immagine a colori falsi con histogram stretch (infrarosso vicino sul verde)
par(mfrow=c(3,1))
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="hist")



# MULTITEMPORAL SET
# facciamo un confronto temporale tra l'immagine del 2011 e l'immagine del 1988 che rappresentano la stessa zona (stesse path e raw)
# dobbiamo utilizzare l'immagine del 1988: 1- richiamare il pacchetto raster 2- settare la working directory: cartella che utiliziamo per caricare i dati
library(raster)
set("C:/lab/") 

# importiamo in R il file corrispondente all'immagine del 2011
# funzione brick: IMPORTA l'intera immagine satellitare, dunque importa tutte le singole bande all'interno di un unica immagine saltellitare
# assegnamo il rislutato della funzione brick ad un oggetto che chiamiamo come il nome dell'immagine
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# richiamiamo l'immagine (oggetto della funzione brick) per vedere le informazioni del file
p224r63_2011

# importiamo in R il file corrispondente all'immagine del 1988
p224r63_1988 <- brick("p224r63_1988_masked.grd")
# richiamiamo l'oggeto della funzione per vedere le informazioni del file
p224r63_1988

# funzione plot: VISUALIZZIAMO l'intera immagine satellitare con le sue singole bande (esattamente le stesse dell'immagine del 2011) e con la scala di colori di default
plot(p224r63_1988)

# plotRGB 
# vediamo l'immagine del 1988 a colori naturali (3,2,1: banda rossa sulla componente R, banda verde sulla componente G, banda blu sulla componente B)
plotRGB(p224r63_1988,  r=3, g=2, b=1, stretch="Lin")
# vediamo l'immagine del 1988 a colori falsi (4,3,2: banda infraorosso sulla componente R, banda rossa sulla componente G, banda verde sulla componente B)
plotRGB(p224r63_1988,  r=4, g=3, b=2, stretch="Lin") 
# vegetazione tutta colorata di rosso, rispetto al 2011 notiamo una componente antropica meno prevalente

# ESERCIZIO: creare un multiframe con par: schema con 2 righe e 1 colonna delle due immagini a confronto 
par(mfrow=c(2,1)) 
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_1988,  r=4, g=3, b=2, stretch="Lin")

# ESERCIZIO: mettiamo a confronto le due immagini (1988 - 2011) con la funzione plotRGB: vediamo le due immagini a colori falsi (4,3,2)
# funzione par: creare un grafico con 2 righe e 2 colonne -> prima riga: stretch lin; seconda riga: histogram stretch 
# GRAFICO -> LIN   1988 - 2011
#            HIST  1988 - 2011
par(mfrow=c(2,2)) 
# Lin (prima riga)
plotRGB(p224r63_1988,  r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
# hist (seconda riga) 
plotRGB(p224r63_1988,  r=4, g=3, b=2, stretch="hist")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="hist")
# RISULTATO DEL CONFRONTO: 
# immagine 1988: all'interno della foresta vediamo bene le zone di transizione: passaggio graduale dalla componente vegetale (foresta pluviale) alla componente umana (campi agricoli)
# immagine 2011: vediamo una soglia netta e marcata tra la foresta pluviale e l’impatto umano
# le immagini con l'histogram stretch (seconda riga) contengono molto rumore: non permette di visualizzare bene le variazioni reali 

# PDF: salviamo il risultato del confronto delle due immagini nella cartella lab
pdf("confronto_1988_2011_2x2")
par(mfrow=c(2,2))
plotRGB(p224r63_1988,  r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_1988,  r=4, g=3, b=2, stretch="hist")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="hist")
dev.off()
# ---------------------------------------------------------------------------------------------------------------------------------------------------

# 2. R code time series Greenland

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
# --------------------------------------------------------------------------------------------------------------------------------------------------------- 

# 3. R code Copernicus data

# R_code_copernicus.r
# Visualizing Copernicus data

# importiamo le librerie necessarie per le operazioni
library(raster)
# installiamo la libreria ncdf4 per visualizzare i dati in formato .nc
install.packages("ncdf4")
library(ncdf4) 

# settiamo la working directory
setwd("C:/lab/")

# procediamo con la lettura del file che abbiamo scaricato
# Energy Budget - ALBEDO - Hemispherical Albedo 1km Global V1
# funzione raster: vogliamo caricare un singolo strato/layer
# dobbiamo uscire da R perchè l’immagine è nella cartella lab e quindi mettiamo tutto tra ""
# associamo l'oggetto albedo alla funzione raster
albedo <- raster ("c_gls_ALBH_202006130000_GLOBE_PROBAV_V1.5.1.nc")
albedo
# class: RasterLayer 
# dimensions: 15680, 40320, 632.217.600  (nrow, ncol, ncell)
# resolution: 0.008928571, 0.008928571  (x, y) -> la risoluzione è in coordinate geografiche (gradi)  
# extent: -180.0045, 179.9955, -59.99554, 80.00446  (xmin, xmax, ymin, ymax)
# -180° a + 180° -> estensione possibile dei gradi di longitudine /  - 60° a + 80° -> estesnione possibile dei gradi di latitudine
# crs: +proj=longlat +ellps=WGS84 +no_defs -> sistema di riferimento WGS84 (world geodetic system) ellissoide che copre tutta superficie della terra  
# names: Broadband.hemispherical.albedo.over.total.spectrum -> nome dello strato 
# z-value: 2020-06-13 -> recente 
# zvar: AL_BH_BB -> come viene nominata la variabile per essere utilizzata

# colorRampPalette
# facciamo il plot di albedo con una colorRampPalette decisa da noi 
cl <- colorRampPalette(c('dark blue','green','red','yellow'))(100)
plot(albedo, col=cl) 
# vediamo la superficie dove viene riflessa più energia solare, i deserti riflettono di più perchè è tutto suolo nudo

# ricampionamento bilineare
# ricampioniamo il dato perchè vogliamo diminuire la sua risoluzione
# funzione aggregate: aggrega i pixel dell'immagine 
# > n.pixel -> > peso immagine
# fact: argomento della funzione aggregate, serve per diminuire il numero di pixel
# fact=100: diminuisce linearmente i pixel di 100 volte, prende 100 pixel x 100 pixel e lo trasforma in un solo pixel come media di tutti i pixel all’interno
albedores <- aggregate(albedo, fact=100)
albedores
# class: RasterLayer
# dimensions: 314, 807, 63428 (nrow, ncol, ncell) -> le informazioni sono diminuite di 10.000 volte (100x100) 

# funzione plot
plot(albedores, col=cl) 
# il plot si carica molto più velocemente perchè il file è più grezzo e i pixel al suo interno sono più grandi
# ---------------------------------------------------------------------------------------------------------------------------------------------------------------

# 4. R code knitr 

# R_code_knitr.r

# settiamo la working directory
setwd("C:/lab/")

# richiamiamo tutte le library necessarie
library (raster)
library (rasterVis)
# pacchetto knitr: può utilizzare un codice esterno (code.r) per creare un report
install.packages("knitr") 
library(knitr)
# installare un altro pezzo di R per creare il report
install.packages("tinytex")
library(tinytex)

# prendiamo la repository sulla Groenlandia: la copiamo e la incolliamo sul blocco note
# salviamo il blocco note (file di testo) nella cartella lab con il nome: R-code-Greenland.r
# cambiamo l'estensione da .txt a .r
# usiamo il pacchetto knitr che utilizza il codice appena salvato nella cartella lab, lo carica dentro a R e poi genera il report

# funzione stitch: crea automaticamente un REPORT basato su uno script di R
# primo argomento: nome del codice che abbiamo salvato nella cartella lab tra "" -> "R-code-Greenland.r"
# "misc": il tipo di template all'interno di knitr
# "knit-template.Rnw": il file di riferimento 
# "knitr": il pacchetto che si utilizza 
stitch("R-code-Greenland.r", template=system.file("misc","knitr-template.Rnw", package="knitr"))

# 2 azioni per risolvere il problema latex 
# Error: LaTex to compile R-code-Greenland.tex
tinytex::install_tinytex()
tinytex::tlmgr_update()
# --------------------------------------------------------------------------------------------------------------------------------------------------------

# 5. R code multivariate analysis

# R_code_multivariate_analysis.r 
# Analisi multivariata: PCA (dati Landsat, 30m)
# usiamo una PCA per compattare il sistema in un numero inferiore di bande ma conservando la stessa proporzione

# librerie e working directory
library(raster)
library(RStoolbox)
setwd("C:/lab/") 

# bande di Landsat:
# b1: blu
# b2: verde
# b3: rosso 
# b4: NIR 

# funzione brick: carichiamo l'immagine intera costiuita da 7 bande (RasterBrick) 
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# plottiamo l'immagine per vedere le 7 bande
plot(p224r63_2011)
# vediamo le informazioni dell'immagine
p224r63_2011
# class: RasterBrick
# dimensions: 1499, 2967, 4.447.533, 7  (nrow, ncol, ncell, nlayers)
# resolution: 30, 30  (x, y)
# extent: 579765, 668775, -522705, -477735  (xmin, xmax, ymin, ymax)
# crs: +proj=utm +zone=22 +datum=WGS84 +units=m +no_defs 
# source:    
# names: B1_sre, B2_sre, B3_sre, B4_sre, B5_sre, B6_bt, B7_sre 
# min values: 0.000000e+00, 0.000000e+00, 0.000000e+00, 1.196277e-02, 4.116526e-03, 2.951000e+02, 0.000000e+00 
# max values:    0.1249041,    0.2563655,    0.2591587,    0.5592193,    0.4894984,  305.2000000,    0.3692634 

# correliamo la banda del blu e la banda del verde: dobbiamo plottare la banda del blu contro la banda del verde
# banda blu: B1_sre -> asse X
# banda verde: B2_sre -> asse Y
# $: leghiamo le bande all'immagine completa
# col="red": colore del plot e in questo modo i punti sono rossi
# pch=19: point character e in questo modo i punti sono dei cerchietti pieni
# cex=2: aumentiamo la dimensione dei punti
plot(p224r63_2011$B1_sre,p224r63_2011$B2_sre, col="red", pch=19, cex=2) 
# Warning message: In .local(x, y, ...): plot used a sample of 2.2% of the cells. You can use "maxpixels" to increase the sample
# i pixel da plottare sono oltre 4 milioni, dunque il sistema ci dice che plotta solo il 2.2% di questo totale
# in statistica il sistema si chiama multicollinearità: le due bande sono molto correlate tra loro e sono correlate positivamente
# le info del punto sulla X sono molto simili alle info del punto sulla Y
# spesso questa forma di correlazione è usata in modo causale

# plottiamo di nuovo la stessa immagine ma con B2_sre -> asse X e B1_sre -> asse Y 
plot(p224r63_2011$B2_sre,p224r63_2011$B1_sre, col="red", pch=19, cex=2)

# funzione pairs: serve per plottare tutte le correlazione possibili tra tutte le variabili di un dataset
# mette in correlazione a due a due tutte le variabili di un certo dataset
pairs(p224r63_2011)
# sulla diagonale vediamo tutte le bande
# parte sottostante alla diagonale: grafico che mostra la correlazione tra le bande 
# parte sopra alla diagonale: indice di correlazione che varia tra -1 e 1



# la PCA è un’analisi piuttosto impattante
# funzione aggregate: ricampioniamo il dato creando un dato più leggero 
# riduciamo la dimensione dell’immagine diminuendone la risoluzione e aumentando la dimensione dei pixel, lo facciamo per tutte e 7 le bande
# fattore 10 lineare: aggreghiamo i pixel del dato iniziale di 10 volte per ottenere un dato con una risoluzione più bassa
# associamo l'oggetto p224r63_2011res (resampled) al risultato della funzione
p224r63_2011res <- aggregate(p224r63_2011, fact=10)
p224r63_2011res 
# class: RasterBrick 
# dimensions: 150, 297, 44550, 7  (nrow, ncol, ncell, nlayers)
# resolution: 300, 300  (x, y)  -> la risoluzione iniziale è diminuita, ora è di 300 m (30x10)

# per vedere la diminuzione della risoluzione nel nuovo dato facciamo un parmfrow
# 2 righe e 1 colonna
# plottiamo con plotRGB le due immagini a diversa risoluzione
# banda NIR (4) sulla componente red, banda rossa (3) sulla componente green, banda verde (2) sulla componente blue
par(mfrow=c(2,1))
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011res, r=4, g=3, b=2, stretch="Lin")
# immagine sopra: immagine dettagliata con risoluzione 30mx30m di pixel
# immagine sotto: immagine molto sgranata con risoluzione 300mx300m di pixel 

# facciamo la PCA della nuova immagine a minor risoluzione (p224r63_2011res) 
# funzione rasterPCA - Principal Component Analysis for Rasters: prende il pacchetto di dati e va a compattarli in un numero minore di bande
# associamo l'oggetto p224r63_2011res_pca al risultato della funzione
p224r63_2011res_pca <- rasterPCA(p224r63_2011res)



# la funzione rasterPCA ci restituisce in uscita un’immagine che contiene la mappa e il modello
# vogliamo visualizzare le informazioni solo del modello: leghiamo l’immagine totale (p224r63_2011res_pca) con il suo modello (model)
# vogliamo sapere qual è la variabilità spiegata dalle componenti principali del nostro sistema
# funzione summaries: ci da un sommario del modello
summary(p224r63_2011res_pca$model)
# Importance of components:
#                             Comp.1      Comp.2       Comp.3       Comp.4          Comp.5       Comp.6       Comp.7
# Standard deviation      1.2050671  0.046154880   0.0151509526  4.575220e-03   1.841357e-03   1.233375e-03  7.595368e-04
# Proportion of Variance  0.9983595  0.001464535   0.0001578136  1.439092e-05   2.330990e-06   1.045814e-06  3.966086e-07
# Cumulative Proportion   0.9983595  0.999824022   0.9999818357  9.999962e-01   9.999986e-01   9.999996e-01  1.000000e+00

# Proportion of Variance: ci dice quanta variabilità spiegano le singole bande, es: PC1 spiega il 99,835% della varianza
# Cumulative Proportion: ci dice quanta variabilità spiegano le componenti insieme, es: PC1+PC2+PC3 si spiega il 99,998% di variabilità quindi bastano le prime 3 componenti

# facciamo il plot dell'immagine_res_pca legata alla sua mappa: $map
plot(p224r63_2011res_pca$map)
# ci mostra tutte le 7 componenti principali e le variabilità che spiegano
# PC1: spiega praticamente tutta la variabilità, dunque si vede bene la foresta, la parte agricola, i tagli dentro la foresta ecc
# PC7: non si distingue più niente perchè spiega la minore variabilità del sistema



# scriviamo il nome dell'immagine_res_pca per vedere le informazioni che contiene
p224r63_2011res_pca
# $call -> ci dice qual è la funzione che abbiamo usato 
# rasterPCA(img = p224r63_2011res)

# $model -> ci da le informazioni sulle componenti principali e la variabilità che spiegano 
# Call:
# princomp(cor = spca, covmat = covMat[[1]])
# Standard deviations:
#       Comp.1       Comp.2       Comp.3       Comp.4       Comp.5       Comp.6       Comp.7 
# 1.2050671158 0.0461548804 0.0151509526 0.0045752199 0.0018413569 0.0012333745 0.0007595368    
# 7  variables and  44550 observations.

# $map -> ci da le informazioni relative alla mappa 
# class: RasterBrick 
# dimensions: 150, 297, 44550, 7  (nrow, ncol, ncell, nlayers)
# resolution: 300, 300  (x, y)
# extent: 579765, 668865, -522735, -477735  (xmin, xmax, ymin, ymax)
# crs: +proj=utm +zone=22 +datum=WGS84 +units=m +no_defs 
# source: memory
# names: PC1,         PC2,         PC3,         PC4,         PC5,         PC6,         PC7 
# min values: -1.96808589, -0.30213565, -0.07212294, -0.02976086, -0.02695825, -0.01712903, -0.00744772 
# max values: 6.065265723, 0.142898435, 0.114509984, 0.056825372, 0.008628344, 0.010537396, 0.005594299 

# attr(,"class")
# [1] "rasterPCA" "RStoolbox"



# plottiamo in RGB le prime 3 componenti principali (PC1 - PC2 - PC3) 
# l'immagine è p224r63_2011res_pca
# plottiamo questa immagine insieme alla sua mappa: $map
# montiamo la PC1 sulla componente red, la PC2 sulla componente green, la PC3 sulla componente blue
# stretch lineare
plotRGB(p224r63_2011res_pca$map, r=1, g=2, b=3, stretch="Lin")
# i colori sono legati alle 3 componenti quindi a livello di colori non abbiamo modo di intuire nulla e non ci danno informazioni
# questa è un'immagine risultante da una analisi delle componenti principali
# ------------------------------------------------------------------------------------------------------------------------------------------------------------

# 6. R code classification

# R_code_classification.r
# CLASSIFICAZIONE: processo che accorpa pixel con valori simili, una volta che questi pixel sono stati accorpati rappresentano una classe

# settiamo la working directory
setwd("C:/lab/")
# impostiamo le librerie che ci servono
library(raster)
library(RStoolbox) 

# funzione brick: inseriamo l'immagine RGB con 3 livelli (pacchetto di dati) 
# associamo l'oggetto so (solar orbiter) al risultato della funzione
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
# vediamo le informazioni relative alle 3 bande
so
# calss: RasterBrick 
# values: 0 , 255 → immagine a 8 bit → 2^8 = 256 valori 

# visualizziamo i 3 livelli dell'immagine RGB
# funzione plotRGB: ci serve per visualizzare i 3 livelli dell'immagine RGB
# X = oggetto
# banda 1 sulla componenete red, banda 2 sulla componente green, banda 3 sulla componente blue
# stretch lineare
plotRGB(so, 1, 2, 3, stretch="Lin")
# vediamo diversi livelli energitici, da alti (colore acceso) a bassi (grigio/nero) 

# classifichiamo l'immagine per individuare le 3 classi
# classificazione non supervisionata: si lascia al software la possibilità di definire il training set sulla base delle riflettanze dei pixel
# training set: il software cattura pochi pixel all’interno dell’immagine per creare un set di controllo e poi si classifica l'intera immagine
# maximum likelihood: per ogni pixel si calcola la distanza nello spazio multispettrale, in base a questa si associa il pixel ad una determinata classe 
# per la classificazione serve la library(RStoolbox) -> libreria che contiene la funzione unsuperClass
# library(RStoolbox) 

# funzione unsuperClass: opera la classificazione non supervisionata (dentro al pacchetto RStoolbox) 
# so: inserimento dell'immagine 
# nClasses=3: numero di classi sulla base dell'immagine 
# associamo l'oggetto soc (solar orbiter classified) al risultato della funzione
soc <- unsuperClass(so, nClasses=3)

# funzione unsuperClass: ha creato l'immaigine classificata (soc) formata da più pezzi: modello + mappa 
# facciamo un plot dell'immagine classificata (soc) e in particolare della mappa
# $: leghiamo l'immagine classificata (soc) alla sua mappa (map)
plot(soc$map)
# 3 classi: classe 1: bianca; classe 2: gialla; classe 3: verde
# queste classi corrispondono ai diversi livelli di energia (alto - medio - basso)

# la mia mappa finale è diversa dalle altre -> i pixel selezionati in entrata per il training set sono diversi di volta in volta
# funzione set.seed: serve per fare una classificazione che sia sempre la stessa (usa sempre le stesse repliche per fare il modello) 
set.seed(42)

# esercitazione: Unsupervised Classification with 20 classes
set.seed(42)
soc20 <- unsuperClass(so, nClasses=20)
plot(soc20$map)

# esercitazione: download an image from: https://www.esa.int/ESA_Multimedia/Missions/Solar_Orbiter/(result_type)/images
# funzione brick: importiamo l'immagine dentro R
sun <- brick("sun.png")
# classificazione dell'immaigne sun - Unsupervised classification
# 3 classi 
set.seed(42)
sunc <- unsuperClass(sun, nClasses=3)
# plottiamo la mappa dell'immagine sun classificata 
plot(sunc$map)



# Grand Canyon 
# https://landsat.visibleearth.nasa.gov/view.php?id=80948

# richiamare le librerie
library(raster)
library(RStoolbox) # indispensabile per la classificazione e l'analisi multivariata
# settare la working directory
setwd("C:/lab/") 

# carichiamo l’immagine che è un RGB: formata da 3 livelli
# funzione brick: per IMPORTARE tutti e 3 i livelli e crea un oggetto raster brick 
# oggetto gc associato al risultato della funzione
gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg")

# visualizzare l'immagine RGB
# funzione plotRGB: oggetto raster brick e con la funzione lo plottiamo 
# x: oggetto dell'immagine (gc)
# red = 1 (banda 1 sul rosso); green = 2 (banda 2 sul verde); blue = 3 (banda 3 sul blu)
# stretch lineare: per aumentare la potenza visiva di tutti i colori possibili
plotRGB(gc, r=1, g=2, b=3, stretch="Lin")

# histogram stretch
plotRGB(gc, r=1, g=2, b=3, stretch="hist")

# Grand Canyon classified 2
# n. classi = 2
gcc2 <- unsuperClass(gc, nClasses=2)
gcc2
# *************** Map ******************
# class: RasterLayer
# dimensions: 6222, 9334, 58.076.148 (nrow, ncol, ncell)
# resolution : 1, 1 (x, y)
# extent: 0, 9334, 0, 6222 (xmin, xmax, ymin, ymax)
# crs: NA
# source: 
# names: layer
# values: 1, 2 (min, max)

# plottiamo la mappa di gcc2
# $: legare la mappa all’immagine intera
plot(gcc2$map)
# vediamo le due classi e possiamo fare un confronto con l'immagine originale
# la discriminazione più alta è nella zona centrale
# tipo di roccia e composizione mineralogico molto caratteristica

# Grand Canyon classified 4
# n.classi = 4
gcc4 <- unsuperClass(gc, nClasses=4)
gcc4
# *************** Map ******************
# class: RasterLayer 
# dimensions: 6222, 9334, 58076148  (nrow, ncol, ncell)
# resolution: 1, 1  (x, y)
# extent: 0, 9334, 0, 6222  (xmin, xmax, ymin, ymax)
# crs: NA 
# source: 
# names: layer 
# values: 1, 4  (min, max)

# plottiamo la mappa di gcc4
# $: legare la mappa all’immagine intera
plot(gcc4$map)
# vediamo una differenziazione più alta
# rilevamento: si va a terra per vedere quanto l'immagine può essere utilizzabile, quanto le classi individuate sono veritiere a terra
# abbiamo usato solo le bande red-green-blue, se avessimo usato anche la banda dell'infrarosso vicino, l'acqua sarebbe stata inserita in una classe a sè
# --------------------------------------------------------------------------------------------------------------------------------------------------------------

# 7. R code ggplot2

library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)

setwd("~/lab/")

p224r63 <- brick("p224r63_2011_masked.grd")

ggRGB(p224r63,3,2,1, stretch="lin")
ggRGB(p224r63,4,3,2, stretch="lin")

p1 <- ggRGB(p224r63,3,2,1, stretch="lin")
p2 <- ggRGB(p224r63,4,3,2, stretch="lin")

grid.arrange(p1, p2, nrow = 2) # this needs gridExtra
# ----------------------------------------------------------------------------------------------------------------------------------------------------------------

# 8. R code vegetation indices

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
# ----------------------------------------------------------------------------------------------------------------------------------------------------------

# 9. R code land cover

# R_code_land_cover.r

# impostiamo le library e la working directory
setwd("C:/lab/")
library(raster)
library(RStoolbox) # for classification 
# install.packages("ggplot2")
library(ggplot2) # for ggRGB
# install.packages(gridExtra)
library(gridExtra) # for grid.arrange

# utilizziamo le immagini defor1 e defor2, luogo: foresta amazzonica nel Rio Peixoto
# BANDE -> NIR: banda 1; RED: banda 2; GREEN: banda 3

# funzione brick: importiamo dentro R le immagini defor1 e defor2 che sono un pacchetto di dati
defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg") 

# funzione plotRGB: banda 1 (NIR) sulla componente red, banda 2 (RED) sulla componente green, banda 3 (GREEN) sulla componente blue
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")
# sono entrambe delle immagini abbastanza grezze come informazioni 

# funzione ggRGB: plottiamo le immagini raster con informazioni aggiuntive e con una grafica più accattivante rispetto a plotRGB
# funzione ggRGB è contenuta nel pacchetto ggplot2
# abbiamo 3 bande per ogni immagine e possiamo creare una immagine singola di queste 3 bande
# argomenti della funzione: immagine da plottare, 3 componenti RGB, stretch 
ggRGB(defor1, r=1, g=2, b=3, stretch="Lin") 
ggRGB(defor2, r=1, g=2, b=3, stretch="Lin") 
# ci sono delle coordinate dell'immagine: n. pixel sulla x e sulla y 

# funzione parmfrow: mettiamo una accanto all’altra le due immagini defor1-defor2 plottate con la funzione plotRGB
par(mfrow=c(1,2))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")

# multiframe with ggplot2 and gridExtra 
# la funzione parmfrow non funziona con immagini raster plottate con la funzione ggRGB
# funzione grid.arrange: compone il multiframe come ci piace, va a mettere insieme vari pezzi di un grafico
# p1: nome per il primo ggRGB
# p2: nome per il secondo ggRGB
p1 <- ggRGB(defor1, r=1, g=2, b=3, stretch="Lin") 
p2 <- ggRGB(defor2, r=1, g=2, b=3, stretch="Lin")
# argomenti della funzione grid.arrange: nome primo ggRGB, nome secondo ggRGB, nrow=2 (n. righe) 
grid.arrange(p1, p2, nrow=2)



# Unsupervised classification 

# funzione unsuperClass
# argomenti: nome immagine, numero di classi 
# 2 classi: foresta amazzonica - parte agricola+acqua
# associamo l'oggetto d1c (defor1 classified) al risultato della funzione 
d1c <- unsuperClass(defor1, nClasses=2)

# vediamo le informazioni
d1c
# *************** Map ******************
# $map
# class: RasterLayer 
# dimensions: 478, 714, 341292  (nrow, ncol, ncell)
# resolution: 1, 1  (x, y)
# extent: 0, 714, 0, 478  (xmin, xmax, ymin, ymax)
# crs: NA 
# source: memory
# names: layer 
# values: 1, 2  (min, max) -> solo due valori perchè abbiamo fatto 2 classi 

# facciamo il plot totale, sia di d1c che della sua mappa all'interno
plot(d1c$map)
# classe 1 = foresta amazzonica (in bianco);  classe 2 = parte agricola + fiume (in verde)

# classifichiamo la seconda immagine (defor2) 
d2c <- unsuperClass(defor2, nClasses=2)
plot(d2c$map)
# classe 1 = foresta amazzonica (in bianco); classe 2 = parte agricola (in verde)

# proviamo a inserire 3 classi per l'immagine defor 2
# la terza classe dovrebbe rappresentare il fiume (acqua) 
d2c3 <- unsuperClass(defor2, nClasses=3)
plot(d2c3$map) 
# classe 3 (in verde): parte residua di foresta amazzonica  
# classe 1 - 2 (bianco - giallo): parte agricola divisa in 2 zone 
# probabilmente ci sono due agricolture diverse all’interno della zona che hanno una riflettanza diversa



# frequencies d1c$map 
# qual è la frequenza delle due classi? 
# funzione freq: funzione generale che genera tavole di frequenza e va a calcolarla
# argomento: d1c e la sua mappa
freq(d1c$map)
#         value  count
# [1,]     1    307047
# [2,]     2    34245
# 1: foresta amazzonica: 307047 -> n pixel
# 2: parte agricola: 34245 -> n pixel 

# calcoliamo la proporzione dei pixel per l'immagine d1c (consiste nella %)
# facciamo la somma dei valori di pixel e la chiamiamo s1
s1 <- 307047 + 34245
s1
# [1] 341292
prop1 <- freq(d1c$map) / s1 
prop1
#            value        count
# [1,] 2.930042e-06     0.8996607     -> foresta amazzonica
# [2,] 5.860085e-06     0.1003393     -> parte agricola
# consideriamo solo il count 
# 89,96% di foresta amazzonica e il 10% di agricolo 

# frequencies d2c$map
freq(d2c$map)
#         value  count
# [1,]     1     178684 
# [2,]     2     164042
# 1: foresta amazzonica
# 2: parte agricola

s2 <- 178684 + 164042
s2
# [1] 342726
prop2 <- freq(d2c$map)/ s2
prop2
#      value          count
# [1,] 2.917783e-06   0.5213611     -> foresta amazzonica
# [2,] 5.835565e-06   0.4786389     -> parte agricola
# 52% di foresta amazzonica e 47,86% di agricolo 



# build a dataframe 
# creiamo una tabella con 3 colonne
# prima colonna -> cover: forest - agriculture
# seconda colonna -> % di classi dell'immagine defor1 ->  percent_1992
# terza colonna -> % di classi dell'immagine defor2 -> percent_2006

# cover è dato da due elementi dello stesso argomento dunque si crea un vettore c, inoltre essendo parole vanno messe tra ""
cover <- c("Forest","Agriculture")	
# le % delle classi sono date da due elementi dello stesso argomento dunque si crea un vettore c
percent_1992 <- c(89.96, 10.03)
percent_2006 <- c(52.13, 47.86)

# creiamo il dataframe
# funzione data.frame: crea una tabella
# argomenti della funzione: sono le 3 colonne che abbiamo appena creato
percentage <- data.frame(cover, percent_1992, percent_2006)
percentage
#         cover         percent_1992    percent_2006
# 1      Forest         89.96           52.13
# 2      Agriculture    10.03           47.86



# let's plot them with ggplot 
# creiamo un grafico per l'immagine del 1992 (defor1)
# funzione ggplot argomenti:
# -> (nome del dataframe, aes(prima colonna, seconda colonna, color=cover))
# color: si riferisce a quali oggetti vogliamo discriminare/distinguere nel grafico e nel nostro caso vogliamo discriminare le due classi
# +
# geom_bar: tipo di geometria del grafico perchè dobbiamo fare delle barre
# stat: indica il tipo di dati che utilizziamo e sono dati grezzi quindi si chiamano "identity" 
# fill: colore delle barre all'interno e mettiamo "white" 
# -> geom_bar(stat="identity", fill="white")
p1 <- ggplot(percentage, aes(x=cover, y=percent_1992, color=cover)) + geom_bar(stat="identity", fill="white")
p1
# vediamo che sulla sinistra abbiamo la percentuale delle due classi nel 1992 e vediamo la parte agricola (molto bassa) e la foresta (molto alta)

# facciamo il grafico per l'immagine del 2006 (defor2) 
p2 <- ggplot(percentage, aes(x=cover, y=percent_2006, color=cover)) + geom_bar(stat="identity", fill="white")
p2
# vediamo che sulla sinistra abbiamo la percentuale delle due classi nel 2006 ma la parte agricola e la foresta ora sono molto simili 

# funzione grid.arrange: mette insieme dei vari plot di ggplot con le immagini
# argomenti: p1, p2, numero di righe = 1 (nrow) 
grid.arrange(p1, p2, nrow=1)
# nella prima data (1992) abbiamo la foresta che è molto elevata come valore, mentre l’agricoltura ha un valore basso
# la situazione è molto diversa nel secondo grafico (2006) dove agricoltura e foresta hanno praticamente lo stesso valore
# ---------------------------------------------------------------------------------------------------------------------------------------------------------

# 10. R code variability

# R_code_variability.r

# settiamo la working directory e le library necessarie
setwd("C:/lab/") 
library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)
# install.packages("viridis")
library(viridis) # per la gestione dei colori, colora i plot con ggplot in modo automatico

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



# cambiamo la grandezza della finestra e la aumentiamo
# calcoliamo la deviazione standard basata su una finestra di 5x5 pixel
ndvisd5 <- focal(ndvi, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
plot(ndvisd5, col=clsd)
# bassa deviazione standard -> roccia nuda
# aumenta -> per la differenziazione all’interno della roccia stessa e all’interno della vegetazione
# poi diminuisce -> nella vegetazione delle praterie ad alta quota
# alta deviazione standard -> crepacci e ombre 



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
# definiamo la banda con la quale vogliamo lavorare -> banda PC1
# leghiamo l'immagine sentpca alla sua mapppa e alla PC1
pc1 <- sentpca$map$PC1
# funzione focal: calcoliamo la deviazione standard sulla pc1
pc1sd5 <- focal(pc1, w=matrix(1/25, nrow=5, ncol=5), fun=sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
# plottiamo l'immagine pc1sd5
plot(pc1sd5, col=clsd)
# 
# 
# 
# ------------------------------------------------------------------------------------------------------------------

# source test 
# scarichiamo un pezzo di codice da Virtuale: source_test_lezione.r
# nel codice si calcola la deviazione standard sulla PC1 di 7x7 pixel (49 pixel possibili dentro la moving window)
# funzione source: esce da R, prende un pezzo di codice e poi lo inserisce all’interno di R, dobbiamo usare le ""
source("source_test_lezione.r.txt")
# vediamo l’immagine della deviazione standard 7x7 pixel della PC1

# library(ggplot2) per plottare con ggplot 
# library(gridExtra) per mettere insieme tanti plot con ggplot
# library(viridis) per i colori, colorare i plot con ggplot in modo automatico 
# scarichiamo un pezzo di codice da Virtuale: source_ggplot.r
# funzione source: inseriamo in R il pezzo di codice scaricato
source("source_ggplot.r.txt")
# --------------------------------------------------------------------------------------------------------------------

# plottiamo con ggplot 
#
#
#
ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) 

#
#
# aggiungiamo il titolo 
ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis() + ggtitle("Standard deviation of PC1 by viridis color scale") 

#
#
ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="magma") + ggtitle("Standard deviation of PC1 by magma color scale")

#
#
ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 by inferno color scale")

#
#
#
#
p1 <- ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis() + ggtitle("Standard deviation of PC1 by viridis color scale")
p2 <- ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="magma") + ggtitle("Standard deviation of PC1 by magma color scale")
p3 <- ggplot() + geom_raster(pc1sd5, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 by inferno color scale")
grid.arrange(p1, p2, p3, nrow=1)
#

# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 11. R code spectral signatures

# R_code_spectral_signatures.r

# impostiamo le librerie che ci servono
library(raster)
library(ggplot2)
library(rgdal) # for click function

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
# utilizziamo l'immagine defor 2 per creare delle firme spettrali
# funzione click: serve per fare un click con il mouse dentro l’immagine scelta e si va a selezionare la firma spettrale
# vogliamo cliccare sulla mappa defor2
# id=T:  argomento che stabilisce se vogliamo creare un id per ogni punto (lo vogliamo fare dunque id=T significa true) 
# xy=T: significa che vogliamo utilizzare l’informazione spaziale
# cell=T: significa che stiamo andando a cliccare su un pixel
# type="p": ci chiede che tipo di click facciamo ovvero un punto quindi "p"
# pch=16: pallino chiuso 
# cex=4: dimensione del carattere
# col="yellow": scegliamo il colore del pixel 
click(defor2, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="yellow")
# clicchiamo su un pixel di vegetazione all’interno della mappa e vediamo che dentro a R ci sono delle informazioni:
#       x     y   cell defor2.1 defor2.2 defor2.3
# 1 155.5 274.5 145707      208       12       26
# banda 2.1 (NIR): ha un valore molto alto di riflettanza (pari a  208) perchè riflette questa lunghezza d'onda 
# banda 2.2 (red): ha una valore molto basso di riflettanza (pari a 12) perchè assorbe questa lunghezza d'onda
# banda 2.3 (green): ha un valore molto basso di riflettanza (pari a 26) perchè assorbe questa lunghezza d'onda (ma la assorbe molto meno del rosso dunque nella luce viisibile noi le vediamo verdi)

# clicchiamo su un pixel di acqua: 
#       x     y   cell defor2.1 defor2.2 defor2.3
# 1 112.5 217.5 186533      42      76      139
# banda 2.1 (NIR): ha un valore molto basso di riflettanza (pari a 42) perchè assorbe questa lunghezza d'onda 
# banda 2.2 (red): ha un valore abbastanza alto di riflettanza (pari a 76) perchè riflette questa lunghezza d'onda
# banda 2.3 (green): ha un valore alto di riflettanza (pari a 139) perchè riflette questa lunghezza d'onda
# se avessimo la banda del blu avrebbe una riflettanza ancora più alta 
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Dataframe
# creiamo una tabella con 3 colonne
# 3 bande: defor2.1; defor 2.2; defor2.3 
# 2 variabili: acqua; foresta (con i valori per le 3 bande) 

#     b     F           W
#     1     lambda1f   lambda1w
#     2     lambda2f   labda2w
#     3     lambda3f   lambda3w

# band: prima colonna - banda di riferimento 
band <- c(1, 2, 3)
# forest: seconda colonna - valore di riflettanza nella foresta
forest <- c(208, 12, 26)
# water: terza colonna - valore di riflettanza nell'acqua
water <- c(42, 76, 139)

# mettiamo tutto insieme in una tabella che si chiama dataframe
# funzione data.frame: crea una tabella 
# spectrals: nome del dataset che vogliamo creare
# argomenti della funzione: le colonne che abbiamo appena definito
spectrals <- data.frame(band, forest, water)
spectrals
#   band forest water
# 1    1    208    42
# 2    2     12    76
# 3    3     26   139

# plot the spectral signatures: 
# per vedere il risultato facciamo un ggplot 
# funzione ggplot: apre solo il plot 
# spectrals: primo argomento è il dataset 
# aes(x=band)) : definiamo su cosa stiamo lavorando:
#       - asse x mettiamo le bande (1-2-3) 
#       - asse y mettiamo i valori di riflettanza 
#       - poi facciamo una linea per la foresta e una linea per l'acqua 
# chiudiamo la funzione ggplot 

# + 

# funzione geom_line: riguarda le geometrie inserisce quelle che ci interessano nel plot (aperto da ggplot) 
# come geometrie ci interessano delle linee 
# geom_line(aes(y=forest), color="green"): ci interessa sapere i valori sulla y e sono i valori di riflettanza che abbiamo nella foresta

# + 

# geom_line(aes(y=water), color="blue"): ci interessa sapere i valori sulla y e sono i valori di riflettanza che abbiamo nell'acqua

# + 

# funzione labs: definisce gli assi x e y 

ggplot(spectrals, aes(x=band)) + geom_line(aes(y=forest), color="green") + geom_line(aes(y=water), color="blue") + labs(x="band", y="reflectance")
# se volessimo mettere in ordine le bande come sono nella luce visibile, verde-rosso-infrarosso, dovremmo invertire i valori all’interno del band overo band(3,2,1) 
# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Multitemporal 
# creiamo tante spectral signature e facciamo un calcolo della variabilità di ogni classe
# utilizziamo l'immagine defor1
defor1 <- brick("defor1.jpg") 
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin") 

# creiamo delle spectral signature dell'immagine defor1 
click(defor1, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="yellow")
# clicchiamo delle zone dove c'è alterazione (sopra l'ansa del fiume in alto a sinistra)

#     x     y   cell defor1.1 defor1.2 defor1.3
# 1 23.5 332.5 103554      195       18       34
#      x     y  cell defor1.1 defor1.2 defor1.3
# 1 42.5 347.5 92863      190       47       49
#     x     y  cell defor1.1 defor1.2 defor1.3
# 1 57.5 344.5 95020      232       99      102
#     x     y  cell defor1.1 defor1.2 defor1.3
# 1 85.5 339.5 98618      213       25       40
#     x     y  cell defor1.1 defor1.2 defor1.3
# 1 74.5 367.5 78615      199       11       26

# facciamo la stessa operazione per l'immagine defor2 e con il click riclicchiamo nella stessa zona dell'immagine defor1
defor2 <- brick("defor2.jpg") 
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin") 
click(defor2, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="yellow")

#      x     y  cell defor2.1 defor2.2 defor2.3
# 1 81.5 344.5 95443       81       37       28
#      x     y  cell defor2.1 defor2.2 defor2.3
# 1 100.5 340.5 98330      187      160      153
#      x     y  cell defor2.1 defor2.2 defor2.3
# 1 113.5 363.5 81852      180      136      125
#     x     y   cell defor2.1 defor2.2 defor2.3
# 1 81.5 324.5 109783      178      133      130
#      x     y   cell defor2.1 defor2.2 defor2.3
# 1 111.5 319.5 113398      182      168      155

# creiamo il dataset
# definire le colonne del dataset che sono sempre le stesse
# band: prima colonna - numero di bande 
band <- c(1, 2, 3)
# time1.1: seconda colonna - valore del primo pixel del tempo 1
time1.1 <- c(195, 18, 34)
# time1.2: terza colonna - valore del secondo pixel del tempo 1
time1.2 <- c(190, 47, 49)
# time2.1: quarta colonna - valore del primo pixel del tempo 2
time2.1 <- c(81, 37, 28) 
# time 2.2: quinta colonna - valore del secondo pixel del tempo 2
time2.2 <- c(187, 160, 153)

# spetracl signature temporal -> spectralst: 
# funzione data.frame: crea la tabella e definiamo le 3 colonne: 
spectralst <- data.frame(band, time1.1, time2.1) 
# ora plottiamo con ggplot solo il time1.1 e il time 2.1 
ggplot(spectralst, aes(x=band)) + geom_line(aes(y=time1.1), color="red") + geom_line(aes(y=time2.1), color="gray") + labs(x="band", y="reflectance")

# plottiamo con ggplot time1.1, time1.2, time2.1, time2.2
# funzione data.frame per definire la tabella con le nuove colonne: 
spectralst <- data.frame(band, time1.1, time1.2, time2.1, time2.2) 
spectralst
#   band   time1.1   time1.2   time2.1   time2.2
# 1    1     195     190       81        187
# 2    2      18      47       37        160
# 3    3      34      49       28         153

# funzione ggplot: 
ggplot(spectralst, aes(x=band)) + geom_line(aes(y=time1.1), color="red") 
+ geom_line(aes(y=time1.2), color="red") + geom_line(aes(y=time2.1), color="gray")
+ geom_line(aes(y=time2.2), color="gray") + labs(x="band", y="reflectance")
# --------------------------------------------------------------------------------------------------------------------------------------------------------

# sito Earth Observatory:
# immagine: Flooding in Central China
# 3 bande:
# chinaflooding_amo_2021207.1  
# chinaflooding_amo_2021207.2  
# chinaflooding_amo_2021207.3

# facciamo 3 spectral signature: 
china <- brick("chinaflooding_amo_2021207.jpg")
china
# class      : RasterBrick 
# dimensions : 480, 720, 345600, 3  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 480  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/lab/chinaflooding_amo_2021207.jpg 
# names      : chinaflooding_amo_2021207.1, chinaflooding_amo_2021207.2, chinaflooding_amo_2021207.3 
# min values :                           0,                           0,                           0 
# max values :                         255,                         255,                         255 

plotRGB(china, 1, 2, 3, stretch="hist")
click(china, id=T, xy=T, cell=T, type="p", pch=16, cex=4, col="black")
# ho visto 3 zone molto differenziate (viola - verde - blu)

#     x     y   cell    chinaflooding_amo_2021207.1     chinaflooding_amo_2021207.2    chinaflooding_amo_2021207.3
# 1 510.5 281.5 143071                           4                         199          1
#     x     y   cell      chinaflooding_amo_2021207.1   chinaflooding_amo_2021207.2    chinaflooding_amo_2021207.3
# 1 318.5 163.5 227839                         118                         163          72
#     x     y   cell      chinaflooding_amo_2021207.1   chinaflooding_amo_2021207.2    chinaflooding_amo_2021207.3
# 1 553.5 207.5 196394                           8                         132            95
  
# definisco le colonne del dataset:
band <- c(1, 2, 3)
strato1 <- c(4, 199, 1)
strato2 <- c(118, 163, 72)
strato3 <- c(8, 132, 95) 

# spectralsc: spectral signature china 
spectralsc <- data.frame(band, strato1, strato2, strato3)
spectralsc
#   band strato1 strato2 strato3
# 1    1       4     118       8
# 2    2     199     163     132
# 3    3       1      72      95

# plottiamo con ggplot:
ggplot(spectralsc, aes(x=band)) + geom_line(aes(y=strato1), color="purple")  + geom_line(aes(y=strato2), color="green")
+ geom_line(aes(y=strato3), color="blue") + labs(x="band", y="reflectance")
# questi 3 strati (3 pixel diversi che ho scelto nell'immagine) si differenziano molto 
# tutti i 3 pixel hanno il picco di riflettanza nella seconda banda (riflettono molto nella seconda banda) 
# Conclusione: questo esercizio serve a identificare delle classi all'interno di una immagine attraverso le quali possiamo classificarla 
# -------------------------------------------------------------------------------------------------------------------------------------------------------------------------
