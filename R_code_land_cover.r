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
# --------------------------------------------------------------------------------------------------------------------------------------------------------

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
# ------------------------------------------------------------------------------------------------------------------------------------------------------

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
# ------------------------------------------------------------------------------------------------------------------------------------------------------

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
# ----------------------------------------------------------------------------------------------------------------------------------------------------

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
# ----------------------------------------------------------------------------------------------------------------------------------------------------
