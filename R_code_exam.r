# R_code_exam.r
# Crescita dell'industria dell'olio di palma in Papua (pronvincia dell'Indonesia) 

# Sito utilizzato per scaricare le immagini: https://eros.usgs.gov/image-gallery/earthshot/papua-indonesia
# Luogo di studio: Papua pronvincia dell'Indonesia 

# LIBRERIE E WORKING DIRECTORY
# Imposto le librerie necessarie per le indagini
# install.packages("raster")
library(raster) # per gestire i dati in formato raster e le funzioni associate 
# install.packages("RStoolbox") 
library(RStoolbox)            # per la classificazione non supervisionata
# install.packages("ggplot2")
library(ggplot2)              # per la funzione ggRGB e per la funzione ggplot 
# install.packages(gridExtra)
library(gridExtra)            # per la funzione grid.arrange

# Settare la working directory - percorso Windows
setwd("C:/esame_telerilevamento_2021/")

# img 1990: Landsat 5
# Bande: 
#       5: Swir; 4: Nir; 3: Red

# img 2020: Landsat 8
# Bande: 
#       6: Swir; 5: Nir; 4: Red


# ------------------------------------------------------------------------------------------------------------------------------------------------------

# 1. INTRODUZIONE - Caricare le immagini - Visualizzare le immagini e le relative Informazioni associate

# Funzione brick: serve per importare dentro a R l'intera immagine satellitare costituita da tutte le sue singole bande (intero set di bande)
# ogni immagine è composta da 3 bande
# la funzione crea un oggetto che si chiama Rasterbrick: serie di bande in formato raster in un'unica immagine satellitare
papua1990 <- brick("1_11-20-1990_Papua_Main(chs. 5,4,3).png")
papua2020 <- brick("8-18-2020_Papua_Main(chs_6,5,4).png")

# Controllo le informazioni dei due Rasterbrick: 
papua1990
# class      : RasterBrick 
# dimensions : 869, 1000, 869000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 869  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/esame_telerilevamento_2021/1_11-20-1990_Papua_Main(chs. 5,4,3).png 
# names      : X1_11.20.1990_Papua_Main.chs._5.4.3..1, X1_11.20.1990_Papua_Main.chs._5.4.3..2, X1_11.20.1990_Papua_Main.chs._5.4.3..3, X1_11.20.1990_Papua_Main.chs._5.4.3..4 
# min values :                                      0,                                      0,                                      0,                                      0 
# max values :                                    255,                                    255,                                    255,                                    255

papua2020
# class      : RasterBrick 
# dimensions : 869, 1000, 869000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 869  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/esame_telerilevamento_2021/8-18-2020_Papua_Main(chs_6,5,4).png 
# names      : X8.18.2020_Papua_Main.chs_6.5.4..1, X8.18.2020_Papua_Main.chs_6.5.4..2, X8.18.2020_Papua_Main.chs_6.5.4..3, X8.18.2020_Papua_Main.chs_6.5.4..4 
# min values :                                  0,                                  0,                                  0,                                  0 
# max values :                                255,                                255,                                255,                                255 

# La classe è un RasterBrick: sono 3 bande in formato raster
# Ci sono 869.000 pixel per ogni banda
# Le due immagini sono a 8 bit: 2^8 = 256 -> da 0 a 255 valori 


# Funzione plot: visualizzo le 3 bande di ciascuna immagine e i relativi valori di riflettanza nella legenda: 
plot(papua1990)
plot(papua2020)
# la legenda riporta i valori interi di riflettanza approssimati in una scala in bit da 0 a 255


# SCHEMA RGB: attraverso lo schema RGB visualizzo le due immagini a colori falsi: 
# Posso utilizzare solo 3 bande alla volta per visualizzare le immagini intere 
# Monto la banda 2 (Nir) sulla componente Red; la banda 1 (Swir) sulla componente Green; la banda 3(Red) sulla componente Blue;
#     -> r=2, g=1, b=3
# Stretch lineare: prende i valori di riflettanza e li fa variare tra 0 e 1 (estremi) in maniera lineare
#                  serve per mostrare tutte le gradazioni di colore ed evitare uno schiacciamento verso una sola parte del colore
# Funzione par: metto le due immagini del 1990-2020 a confronto in un grafico con due righe e una colonna: 
par(mfrow=c(2,1)) 
plotRGB(papua1990, r=2, g=1, b=3, stretch="Lin")
plotRGB(papua2020, r=2, g=1, b=3, stretch="Lin")
# Rosso: foresta pluviale tropicale perchè riflette molto il Nir (r=2 -> alto valore di riflettanza) 
# Blu: acqua perchè riflette molto il rosso (b=3 -> alto valore di riflettanza) 
# Nell'immagine sopra (1990): vediamo la foresta pluviale tropicale ancora intatta
# Nell'immagine sotto (2020) si notano bene i blocchi grigliati che rappresentano le piantagioni di olio di palma che sostituiscono la foresta pluviale tropicale

# ------------------------------------------------------------------------------------------------------------------------------------------------------

# 2. INDICI DI VEGETAZIONE - DVI - NDVI 

# DVI
# Calcolo il DVI per l'immagine del 1990:
# DVI = riflettanza NIR (1990) - riflettanza RED (1990) 
# -255 < DVI < +255
# associo dei nomi immediati alle bande:
nir <- papua1990$X1_11.20.1990_Papua_Main.chs._5.4.3..2
red <- papua1990$X1_11.20.1990_Papua_Main.chs._5.4.3..3
dvi1 <- nir - red 
# per ogni pixel stiamo prendendo il valore di riflettanza della banda del NIR e lo sottraiamo al valore di riflettanza della banda del red
# dvi1 è la mappa del DVI: in uscita abbiamo una mappa formata da tanti pixel che sono la differenza tra infrarosso e rosso

# creo una ColorRamppalette che metta in risalto le zone con alto e basso valore di dvi:
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi1, col=cl, main="DVI 1990") 
# rosso scuro: DVI alto, per cui una vegetazione sana rappresentata da foresta pluviale 
# giallo: DVI basso, sono campi agricoli e rimangono a ridosso del fiume 

# Calcolo il DVI per l'immagine del 2020:
# DVI = riflettanza NIR (2020) - riflettanza RED (2020) 
# -255 < DVI < +255
# associo dei nomi immediati alle bande:
nir2 <- papua2020$X8.18.2020_Papua_Main.chs_6.5.4..2
red2 <- papua2020$X8.18.2020_Papua_Main.chs_6.5.4..3
dvi2 <- nir2 - red2 

cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi2, col=cl, main="DVI 2020") 
# nero: DVI alto, però non è foresta pluviale ma coltivazioni di olio di palma 
# giallo: DVI basso: vegetazione che sta soffrendo oppure campi coltivati, si nota un aumento di questa parte a discapito della foresta pluviale tropicale

# Com'è cambiata la vegetazione in questo settore dal 1990 al 2020?
# Si può capire facendo la differenza tra i due DVI nei diversi tempi 
diffdvi <- dvi1 - dvi2 
cld <- colorRampPalette(c('blue','white','red'))(100) 
plot(diffdvi, col=cld)
# legenda:
#       > diff: aree con la maggior perdita di vegetazione 
#       < diff: aree con la minor perdita di vegetazione 
# in rosso: la parte di vegetazione meno sana e che ha sofferto di più dal 1990 al 2020 è localizzata in alto a destra 



# NDVI
# NDVI = NIR - red / NIR + red 
# - 1 < NDVI < 1 

# Calcolo il NDVI per l'immagine del 1990:
ndvi1 <- (nir - red) / (nir + red)
plot(ndvi1, col=cl) 
# rosso: NDVI alto, foresta pluviale tropicale 
# giallo: NDVI basso, campi coltivati 

# Calcolo il NDVI per l'immagine del 2020:
ndvi2 <- (nir2 - red2) / (nir2 + red2)
plot(ndvi2, col=cl) 
# rosso: NDVI alto, foresta pluviale tropicale 
# giallo: NDVI basso, campi coltivati molto aumentati rispetto all'immagine del 1990 

# Cambiamento della vegetazione dal 1990 al 2020
# Differenza tra i due NDVI nei due tempi:
diffndvi <- ndvi1 - ndvi2
plot(diffndvi, col=cld)
# legenda:
#       > diff: aree con la maggior perdita di vegetazione 
#       < diff: aree con la minor perdita di vegetazione
# in rosso: sono le aree con maggiore perdita di vegetazione, si nota molto meglio la parte di vegetazione non sana oppure trasformata in campi coltivati 


# Metto a confronto le due differenze degli indici in un grafico con 1 riga e due colonne: 
par(mfrow=c(1,2))
plot(diffdvi, col=cld, main="Differenza DVI")
plot(diffndvi, col=cld, main="Differenza NDVI") 

# ----------------------------------------------------------------------------------------------------------------------------------------------------------

# 3. GENERAZIONE DI MAPPE DI LAND COVER E CAMBIAMENTO DEL PAESAGGIO 

# library(ggplot2) 
# funzione ggRGB: plottiamo le immagini raster con informazioni aggiuntive e con una grafica più accattivante rispetto a plotRGB
# abbiamo 3 bande per ogni immagine e possiamo creare una immagine singola di queste 3 bande
# monto la banda NIR(2) sulla componenete Red; la banda Swir(1) sulla componenete Green, la banda Red(3) sulla componenete Blue dello schema RGB
# library(gridExtra) 
# funzione grid.arrange: compone il multiframe e va a mettere insieme vari pezzi di un grafico plottati con ggRGB 
p1990 <- ggRGB(papua1990, r=2, g=1, b=3, stretch="Lin")
p2020 <- ggRGB(papua2020, r=2, g=1, b=3, stretch="Lin")
grid.arrange(p1990, p2020, nrow=2)



# Unsupervised classification 
# CLASSIFICAZIONE: processo che accorpa pixel con valori simili, una volta che questi pixel sono stati accorpati rappresentano una classe
# library(RStoolbox) 
# funzione unsuperClass: opera la classificazione non supervisionata
# funzione set.seed: serve per fare una classificazione che sia sempre la stessa (usa sempre le stesse repliche per fare il modello) 
set.seed(42)

# Classificazione NON supervisionata per l'immagine del 1990 
# 2 classi: 
#         - foresta pluviale tropicale
#         - parte agricola + acqua
p1c <- unsuperClass(papua1990, nClasses=2)

# controllo le informazioni
p1c
# unsuperClass results
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 869, 1000, 869000  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 869  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 2  (min, max)   -> solo due valori (1, 2) perchè abbiamo fatto 2 classi 

# facciamo il plot totale, sia di d1c che della sua mappa all'interno
plot(p1c$map)
# verde: foresta tropicale pluviale (classe 2)
# bianco: parte agricola più acqua (classe 1) 


# Classificazione NON supervisionata per l'immagine del 2020
# 3 classi:
#       - foresta pluviale tropicale
#       - parte agricola più acqua
#       - coltivazioni di palma (per olio di palma) 
set.seed(42)
p2c <- unsuperClass(papua2020, nClasses=3)

p2c
# unsuperClass results
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 869, 1000, 869000  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 869  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 3  (min, max)

plot(p2c$map)
# verde: campi agricoli + acqua (classe 3) 
# bianco: foresta tropicale  (classe 1)
# giallo: coltivazioni di palme per olio di palma (classe 2) 



# Frequencies p1c$map 
# ci chiediamo quanta % di foresta è stata persa 
# qual è la frequenza delle due classi (foresta - agricoltura) 
# funzione freq: funzione generale che genera tavole di frequenza e va a calcolarla
freq(p1c$map)
#       value  count
# [1,]     1  32306    -> classe 1 (parte agricola + acqua) 32.306 pixel 
# [2,]     2 836694    -> classe 2 (foresta tropicale) 836.694 pixel 

# calcoliamo la proporzione dei pixel per l'immagine p1c (consiste nella %)
# facciamo la somma dei valori di pixel e la chiamiamo s1
s1 <- 32306 + 836694
prop1 <- freq(p1c$map) / s1 
prop1
#           value      count
# [1,] 1.150748e-06 0.03717606  -> 3,7% parte agricola più acqua
# [2,] 2.301496e-06 0.96282394  -> 96,3% foresta tropicale 



# Frequencies p2c$map 
freq(p2c$map)
#         value  count
# [1,]     1     732145  -> classe 1  (foresta tropicale) 732.145 pixel
# [2,]     2     59454   -> classe 2 (coltivazioni di palme per olio di palma) 59.454 pixel 
# [3,]     3     77401   -> classe 3 (parte agricola + acqua) 77.401 pixel 

# facciamo la somma dei valori di pixel e la chiamiamo s2
s2 <- 732145 + 59454 + 77401
prop2 <- freq(p2c$map) / s2
prop2 
#       value           count
# [1,] 1.150748e-06   0.84251438  -> 84,3% forestra tropicale 
# [2,] 2.301496e-06   0.06841657  -> 6,8% coltivazione di palme per olio di palma 
# [3,] 3.452244e-06   0.08906904  -> 9% di agricoltura più acqua 



# DataFrame 
# creiamo una tabella con 3 colonne
# prima colonna -> cover: foresta - agricoltura - palma 
# seconda colonna -> % di classi dell'immagine p1c ->  percent_1990
# terza colonna -> % di classi dell'immagine p2c -> percent_2020

cover <- c("Foresta","Agricoltura", "Palma")
percent_1990 <- c(96.3, 3.7, 0)
percent_2020 <- c(84.3, 9, 6.8)

# creiamo il dataframe
# funzione data.frame: crea una tabella
# argomenti della funzione: sono le 3 colonne che ho appena creato
percentage <- data.frame(cover, percent_1990, percent_2020)
percentage
#      cover       percent_1990    percent_2020
# 1    Foresta         96.3         84.3
# 2    Agricoltura     3.7          9.0
# 3    Palma           0.0          6.8


# plotto il Dataframe con ggplot
# p1c -> creo il grafico per l'immagine del 1990 (papua1990)
# library(ggplot2) 
# funzione ggplot
#         (nome del dataframe, aes(prima colonna, seconda colonna, color=cover))
#          +
#         geom_bar(stat="identity", fill="white")

# color: si riferisce a quali oggetti vogliamo discriminare/distinguere nel grafico e nel nostro caso vogliamo discriminare le due classi
# geom_bar: tipo di geometria del grafico perchè dobbiamo fare delle barre
# stat: indica il tipo di dati che utilizziamo e sono dati grezzi quindi si chiamano "identity" 
# fill: colore delle barre all'interno e mettiamo "white" 

p1 <- ggplot(percentage, aes(x=cover, y=percent_1990, color=cover))  +  geom_bar(stat="identity", fill="white")
p1


# p2c -> creo il grafico per l'immagine del 2020 (papua2020)  
# funzione ggplot 
p2 <- ggplot(percentage, aes(x=cover, y=percent_2020, color=cover))  +  geom_bar(stat="identity", fill="white")
p2


# funzione grid.arrange: mette insieme dei vari plot di ggplot con le immagini
# library(gridExtra) for grid.arrange
# argomenti: p1, p2, numero di righe = 1  
grid.arrange(p1, p2, nrow=1)
# nella prima data (1990) abbiamo la foresta che è molto elevata come valore, mentre l’agricoltura ha un valore basso e le coltivazioni di palma hanno valore 0 perchè non ci sono
# la situazione risulta diversa nel secondo grafico (2020) dove il valore della foresta si abbassa leggermente, mentre si alza il valore % delle coltivazioni di palma e dell'agricoltura 












