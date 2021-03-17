# Il mio primo codice in R per il telerilevamento!
# installare il pacchetto raster per gestire i dati in formato raster
install.packages("raster") 
# funzione library per visualizzare il pacchetto raster
library(raster) 
# percorso per Windows per lavorare con la cartella lab
setwd("C:/lab/") 
# funzione brick per importare il blocco di immagini satellitari e assegnare un oggetto 
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# vedere cosa contiene il file
p224r63_2011
# funzione plot per visualizzare le 7 bande
plot(p224r63_2011)
# funzione per cambiare colore e assegnamo un oggetto
cl <- colorRampPalette(c("black","grey","light grey")) (100)
plot(p224r63_2011, col=cl)
# esercizio change colour -> new
cl <- colorRampPalette(c("blue","pink","light pink","purple","green")) (100)
plot(p224r63_2011, col=cl)
