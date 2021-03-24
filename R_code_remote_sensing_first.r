# Il mio primo codice in R per il telerilevamento!
# installare il pacchetto raster per gestire i dati in formato raster
install.packages("raster") 
# funzione library per visualizzare il pacchetto raster
library(raster) 

# percorso per Windows per lavorare con i dati contenuti nella cartella lab
setwd("C:/lab/") 

# funzione brick per importare l'intero blocco di immagini satellitari e assegnare un oggetto 
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# vedere cosa contiene il file
p224r63_2011
# funzione plot per visualizzare le 7 bande
plot(p224r63_2011)

# funzione per cambiare colore e assegnamo la funzioena all'oggetto cl
cl <- colorRampPalette(c("black","grey","light grey")) (100)
# funzione plot -> primo argomento:immagine, secondo argomento:colore
plot(p224r63_2011, col=cl)
# esercizio change colour -> new
clb <- colorRampPalette(c("blue","pink","light pink","purple","green")) (100)
plot(p224r63_2011, col=clb)

# GIORNO 3
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

# funzione par: plottiamo due bande una accanto all'altra
# mfrow: 1 riga e 2 colonne
par(mfrow=c(1,2))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
# mfrow: 2 righe e 1 colonna
par(mfrow=c(2,1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
# mfrow: righe,colonne; mfcol: colonne, righe 
# esercizio: plottiamo le prime 4 bande di Landsat: mfrow 4 righe e 1 colonna
par(mfrow=c(4,1))
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)
# plottiamo le prime 4 bande in un quadrato 2x2
par(mfrow=c(2,2)) 
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)
plot(p224r63_2011$B3_sre)
plot(p224r63_2011$B4_sre)

# plottiamo le prime 4 bande in un quadrato 2x2, per ogni banda assegniamo una colorRampPalette associata al sensore della banda
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





