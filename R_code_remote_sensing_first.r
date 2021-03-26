# Il mio primo codice in R per il telerilevamento!
# funzione install per installare il pacchetto raster e gestire i dati in formato raster
install.packages("raster") 
# funzione library per visualizzare il pacchetto raster
library(raster) 

# percorso Windows per lavorare con i dati contenuti nella cartella lab
setwd("C:/lab/") 

# funzione brick per importare dentro a R l'intero blocco di immagini satellitari
# assegnare l'oggetto (nome immagine) alla funzione 
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# nome immagine: vedere cosa contiene il file
p224r63_2011
# funzione plot per visualizzare le 7 bande dell'immagine
plot(p224r63_2011)

# funzione colorRampPalette: per cambiare colore
# assegnare l'oggetto (cl) alla funzione  
cl <- colorRampPalette(c("black","grey","light grey")) (100)
# funzione plot -> primo argomento:immagine, secondo argomento:colore
plot(p224r63_2011, col=cl)
# esercizio: cambiamo il colore della palette di colori di default
clb <- colorRampPalette(c("blue","pink","light pink","purple","green")) (100)
plot(p224r63_2011, col=clb)

# Bande di Landsat:
# B1: blu
# B2: verde
# B3: rosso 
# B4: infrarosso vicino 
# B5: infrarosso medio
# B6: infrarosso termico 
# B7: infrarosso medio 

# comando dev off per ripulire la finestra grafica
dev.off()
# funzione plot: plottiamo l'immagine intera legata alla sua banda 1 ($ per legare i due blocchi) 
plot(p224r63_2011$B1_sre)
# esercizio: plot della banda 1 con una scala di colori scelta da noi
cls <- colorRampPalette(c("blue","light blue","magenta","light pink","white")) (100)
plot(p224r63_2011$B1_sre, col=cls)

# funzione par: plottiamo solo due bande: una accanto all'altra
# mfrow: n.righe, n.colonne; mfcol: n.colonne, n.righe
# mfrow: 1 riga e 2 colonne
par(mfrow=c(1,2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
# mfrow: 2 righe e 1 colonna
par(mfrow=c(2,1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

# esercizio: plottiamo le prime 4 bande di Landsat: mfrow 4 righe e 1 colonna
par(mfrow=c(4,1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
# esercizio: plottiamo le prime 4 bande in un quadrato 2x2
par(mfrow=c(2,2)) 
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
# esercizio: plottiamo le prime 4 bande in un quadrato 2x2, per ogni banda assegniamo una colorRampPalette associata al sensore della banda
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
# B4(infrarosso vicino): colorRampPalette basata sui gialli
clnir <- colorRampPalette(c("red","orange","yellow")) (100)
plot(p224r63_2011$B4_sre, col=clnir)

# visualizzare tutta l'immagine a colori naturali
# funzione plotRGB: 
# primo argomento:immagine, red=banda 3 - green=banda 2 - blue=banda 1, stretch
plotRGB(p224r63_2011,  r=3, g=2, b=1, stretch="Lin")

# visualizzare tutta l'immagine a infrarossi
# infrarosso (banda 4) sulla componente red (RGB)
plotRGB(p224r63_2011,  r=4, g=3, b=2, stretch="Lin")
# infrarosso (banda 4) sulla componente green (RGB)
plotRGB(p224r63_2011,  r=3, g=4, b=2, stretch="Lin")
# infrarosso (banda 4) sulla componente blue (RGB)
plotRGB(p224r63_2011,  r=3, g=2, b=4, stretch="Lin")

#ESERCIZIO: visualizzare tutte le 4 immagini in un quadrato 2x2
par(mfrow=c(2,2)) 
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="Lin")

# creiamo un pdf delle 4 immagini appena create
pdf("immagine_multiframe_2x2")
par(mfrow=c(2,2)) 
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=2, b=4, stretch="Lin")
dev.off()

# da stretch lineare a histogram stretch
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="hist")

# esercitazione: 
par(mfrow=c(3,1))
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="hist")

install.packages("RStoolbox")
library(RStoolbox)




