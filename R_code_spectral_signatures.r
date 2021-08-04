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
