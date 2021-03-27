# Il mio primo codice in R per il telerilevamento!

# funzione install per INSTALLARE il pacchetto raster e gestire i dati in formato raster
install.packages("raster") 
# funzione library per UTILIZZARE il pacchetto raster
library(raster) 

# percorso Windows per GESTIRE i dati contenuti nella cartella lab
setwd("C:/lab/") 

# funzione brick per IMPORTARE dentro a R l'intera immagine satellitare (blocco) tra ""
# assegnare il risultato della funzione brick ad un oggetto (nome_immagine)
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# nome_immagine: per conoscere INFORMAZIONI relative al file raster: 
# - Classe: RasterBrick (7 bande in formato raster) 
# - Bande di Landsat:
# B1: blu
# B2: verde
# B3: rosso 
# B4: infrarosso vicino 
# B5: infrarosso medio
# B6: infrarosso termico 
# B7: infrarosso medio 
p224r63_2011
# funzione plot per VISUALIZZARE i dati, in questo caso visualizziamo le 7 bande dell'immagine satellitare
plot(p224r63_2011)
# -------------------------------------------------------------------------------------------------------------------------

# colorRampPalette
# vogliamo cambiare la scala di colori di default 
# funzione colorRampPalette per CAMBIARE il COLORE delle 7 bande, ogni colore è un etichetta scritta tra ""
# le etichette dei colori sono elementi di uno stesso argomento (colore) quindi vengono racchiusi all'interno di un VETTORE c 
# funzione(c("elemento 1","elemento 2","elemento 3"...))
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
# simbolo $: lega i due blocchi, quindi lega l'intera immagine alla sua banda 1 
plot(p224r63_2011$B1_sre)

# ESERCIZIO: visualizzare solo la banda 1 con una scala di colori scelta da noi
cls <- colorRampPalette(c("blue","light blue","magenta","light pink","white")) (100)
# funzione(primo argomento:nome_immagine$banda1, secondo argomento:colore(col)=oggetto(cls))
plot(p224r63_2011$B1_sre, col=cls)
# ---------------------------------------------------------------------------------------------------------------

# par
# vogliamo visualizzare solo le bande che ci interessano (non tutte e nemmeno una singola), vogliamo vedere la banda del blu e la banda del verde:
# funzione par: crea un GRAFICO e serve per fare il settaggio dei vari parametri grafici
# stiamo facendo un multiframe -> mf e vogliamo un grafico con 1 riga e 2 colonne
# mfrow = n.righe, n.colonne oppure mfcol = n.colonne, n.righe
# par(mfrow=1,2)
# 1,2 sono due caratteri dello stesso argomento (n.righe,n.colonne) dunque li inseriamo in un VETTORE c
par(mfrow=c(1,2))
# plottiamo le due bande (blu,verde) legate ($) all'immagine intera 
plot(p224r63_2011$B1_sre)
plot(p224r63_2011$B2_sre)

# ESERICIZIO: plottiamo le due bande (blue e verde) su 2 righe e 1 colonna
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
# ------------------------------------------------------------------------------------------------------------

# plotRGB
# visualizziamo i dati utilizzando lo schema RGB
# SCHEMA RGB: red,green,blue - per ogni componente dello schema RGB utilizziamo una banda 
# utilizziamo solo 3 bande per volta per visualizzare l'immagine intera 
# componente rossa R3 -> banda 3 (banda del rosso)
# componente verde G2 -> banda 2 (banda del verde)
# componente blu B1 -> banda 1 (banda del blu)

# visualizzare tutta l'immagine a colori naturali
# funzione plotRGB: VISUALIZZAZIONE, attraverso lo schema RGB, di un oggetto raster multi-layered (molte bande)
# primo argomento: nome_immagine / quali componenti per ogni banda: r=3, g=2, b=1 / ultimo argomento: stretch="Lin"
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

# ESECIZIO: facciamo un par mfrow = 3righe, 1 colonna
# immagine a colori naturali (3,2,1) - immagine a colori falsi (infrarosso vicino sul verde) - immagine a colori falsi con histogram stretch (infrarosso vicino sul verde)
par(mfrow=c(3,1))
plotRGB(p224r63_2011, r=3, g=2, b=1, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="Lin")
plotRGB(p224r63_2011, r=3, g=4, b=2, stretch="hist")
# -------------------------------------------------------------------------------------------------------------

install.packages("RStoolbox")
library(RStoolbox)



