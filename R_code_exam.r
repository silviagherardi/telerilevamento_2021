# R_code_exam.r  
# Athabasca Oil Sand - Alberta - Canada 
# Sito utilizzato per scaricare le immagini: https://eros.usgs.gov/image-gallery/earthshot/athabasca-oil-sands-alberta-canada

# Una delle più grandi riserve di petrolio si trova nella foresta boreale in Canada, precisamente nell'Alberta nord-ovest
# Luogo di studio: a nord della città di Fort McMurray, sulle sponde del fiume Athabasca
# Le tecniche di estrazione del petrolio comprendono la deforestazione di parte della foresta boreale e questo crea delle miniere a cielo aperto
# In questo progetto si vuole osservare lo sviluppo delle miniere dal 1989 al 2014

# LIBRERIE 
# Imposto le librerie necessarie per le indagini
# funzione install.packages: funzione che installa un pacchetto situato all'esterno del software R 
# funzione library: serve per utilizzare un pacchetto

# install.packages("raster")
library(raster)                # per gestire i dati in formato raster e le funzioni associate 
# install.packages("RStoolbox") 
library(RStoolbox)             # per la classificazione non supervisionata (funzione unsuperClass) - per l'analisi delle componenti principali (funzione rasterPCA)                            
# install.packages("rasterVis")
library(rasterVis)             # per la time series analysis (funzione levelplot) 
# install.packages("ggplot2")
library(ggplot2)               # per la funzione ggRGB e per la funzione ggplot 
# install.packages(gridExtra)
library(gridExtra)             # per la funzione grid.arrange
# install.packages(viris) 
library(viridis)               # per la funzione scale_fill_viridis

# Settare la working directory - percorso Windows
setwd("C:/esame_telerilevamento_2021/")

# img 1989: Landsat 5
# Bande: 
#       1: Swir - 2: Nir - 3: Red

# img 2014: Landsat 8
# Bande: 
#       1: Swir - 2: Nir - 3: Red 

# ------------------------------------------------------------------------------------------------------------------------------------------------------


# 1. INTRODUZIONE - Caricare le immagini - Visualizzare le immagini e le relative Informazioni associate

# Funzione brick: serve per importare dentro a R l'intera immagine satellitare costituita da tutte le sue singole bande (intero set di bande)
# ogni immagine è composta da 3 bande
# la funzione crea un oggetto che si chiama Rasterbrick: serie di bande in formato raster in un'unica immagine satellitare
At1989 <- brick("4_8-6-1989_McMurrayMain.png")
At2014 <- brick("11_9-28-2014_McMurrayMain.png")

# Controllo le informazioni dei due Rasterbrick: 
At1989
# class      : RasterBrick 
# dimensions : 990, 1000, 990000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 990  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/esame_telerilevamento_2021/4_8-6-1989_McMurrayMain.png 
# names      : X4_8.6.1989_McMurrayMain.1, X4_8.6.1989_McMurrayMain.2, X4_8.6.1989_McMurrayMain.3, X4_8.6.1989_McMurrayMain.4 
# min values :                          0,                          0,                          0,                          0 
# max values :                        255,                        255,                        255,                        255 

At2014
# class      : RasterBrick 
# dimensions : 990, 1000, 990000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 990  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/esame_telerilevamento_2021/11_9-28-2014_McMurrayMain.png 
# names      : X11_9.28.2014_McMurrayMain.1, X11_9.28.2014_McMurrayMain.2, X11_9.28.2014_McMurrayMain.3, X11_9.28.2014_McMurrayMain.4 
# min values :                            0,                            0,                            0,                            0 
# max values :                          255,                          255,                          255,                          255 

# La classe è un RasterBrick: sono 3 bande in formato raster
# Ci sono 990.000 pixel per ogni banda
# Le due immagini sono a 8 bit: 2^8 = 256 -> da 0 a 255 valori 

# Funzione plot: visualizzo le 3 bande di ciascuna immagine e i relativi valori di riflettanza nella legenda: 
plot(At1989)
plot(At2014)
# la legenda riporta i valori interi di riflettanza approssimati in una scala in bit da 0 a 255


# SCHEMA RGB: attraverso lo schema RGB visualizzo le due immagini a colori falsi: 
# Posso utilizzare solo 3 bande alla volta per visualizzare le immagini intere 
# Funzione plotRGB: funzione che permette di visualizzare un oggetto raster multi-layered attraverso lo schema RGB 
# Monto la banda 1 (Swir) sulla componente Red; la banda 2 (Nir) sulla componente Green; la banda 3(Red) sulla componente Blue;
#     -> r=1, g=2, b=3
# Stretch lineare: prende i valori di riflettanza e li fa variare tra 0 e 1 (estremi) in maniera lineare
#                  serve per mostrare tutte le gradazioni di colore ed evitare uno schiacciamento verso una sola parte del colore
# Funzione par: metto le due immagini del 1989-2014 a confronto in un grafico con una riga e due colonne: 
par(mfrow=c(1,2)) 
plotRGB(At1989, r=1, g=2, b=3, stretch="Lin", main="Miniere nel 1989")
plotRGB(At2014, r=1, g=2, b=3, stretch="Lin", main="Miniere nel 2014")
# Verde: foresta boreale e praterie coltivate -> la vegetazione riflette molto il Nir (g=2 -> alto valore di riflettanza)
# Viola: miniere, molto aumentate come superficie nel 2014 
# Blu: fiume, stagni sterili

# ------------------------------------------------------------------------------------------------------------------------------------------------------


# 2. TIME SERIES ANALYSIS 
# La Time Series Analysis è utile per confrontare due o più immagini nel corso degli anni e capire dove sono avvenuti i cambiamenti principali 

# funzione list.files: creo una lista di file riconosciuta grazie al pattern "McMurrayMain" che si ripete nel nome
lista <- list.files(pattern="McMurrayMain")
# funzione lapply: applica la funzione (in questo caso raster) a tutta la lista di file appena creata
# funzione raster: importa singoli strati e crea un oggetto chiamato raster layer
importa <- lapply(lista, raster)
# funzione stack: raggruppa i file appena importati in un unico blocco di file 
athabasca <- stack(importa) 

# funzione colorRampPalette: cambio la scala di colori di default proposta dal software con una gradazione di colori che possa marcare le differenze nei due periodi
# ogni colore è un etichetta scritta tra "" e sono diversi caratteri di uno stesso argomento dunque vanno messi in un vettore c 
# (100): argomento che indica i livelli per ciascun colore
cs <- colorRampPalette(c("dark blue","light blue","pink","red"))(100)

# library(rasterVis) 
# funzione levelplot: crea un grafico dove mette a confronto le due immagini in tempi diversi utilizzando un'unica legenda 
levelplot(athabasca, col.regions=cs, main="Sviluppo delle miniere a cielo aperto nella provincia di Alberta", names.attr=c("2014" , "1989"))
# Si nota in rosa e rosso l'aumento delle miniere a cielo aperto e la diminuzione della foresta boreale 

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------


# 3. INDICI DI VEGETAZIONE - NDVI 

# NDVI = NIR - red / NIR + red 
# - 1 < NDVI < 1 

# associo dei nomi immediati alle bande:
nir1 <- At1989$X4_8.6.1989_McMurrayMain.2
red1 <- At1989$X4_8.6.1989_McMurrayMain.3
nir2 <- At2014$X11_9.28.2014_McMurrayMain.2
red2 <- At2014$X11_9.28.2014_McMurrayMain.3

clr <- colorRampPalette(c('dark blue', 'yellow', 'red', 'black'))(100)

# Calcolo il NDVI per l'immagine del 1989:
ndvi1 <- (nir1 - red1) / (nir1 + red1)
plot(ndvi1, col=clr, main="NDVI 1989")
# legenda:
#     rosso: NDVI alto, foresta borale sana e intatta
#     giallo: NDVI basso, aree di deforestazione per le miniere


# Calcolo il NDVI per l'immagine del 2014:
ndvi2 <- (nir2 - red2) / (nir2 + red2)
plot(ndvi2, col=clr, main="NDVI 2014") 
# Legenda:
#    rosso scuro: NDVI alto, foresta borale sana e intatta
#    giallo: NDVI basso, aree di deforestazione per le miniere, si nota un forte aumento di quest'area 

# metto le due immagini risultanti a confronto in un grafico con una riga e due colonne
par(mfrow=c(1,2))
plot(ndvi1, col=clr, main="NDVI 1989")
plot(ndvi2, col=clr, main="NDVI 2014")


# Cambiamento della vegetazione dal 1989 al 2014
# Differenza tra i due NDVI nei due tempi:
cld <- colorRampPalette(c('dark blue', 'white', 'red'))(100)
diffndvi <- ndvi1 - ndvi2
levelplot(diffndvi, col.regions=cld, main="NDVI 1989 - NDVI 2014")
# legenda:
#       rosso: > diff -> aree con la maggior perdita di vegetazione per l'aumento delle miniere
#       bianco: < diff -> aree con foresta boreale sana e intatta


# ----------------------------------------------------------------------------------------------------------------------------------------------------------


# 4. GENERAZIONE DI MAPPE DI LAND COVER E CAMBIAMENTO DEL PAESAGGIO 


# Unsupervised classification  -> processo che accorpa pixel con valori simili, una volta che questi pixel sono stati accorpati rappresentano una classe
# Come si comportano i pixel nello spazio multispettrale definito dalle bande come assi
# Il Software crea un Training Set: prende un certo n. di pixel come campione e misura le riflettanze nelle varie bande
# Dopodichè classifica tutti gli altri pixel dell'immagine in funzione del training set (precedentemente creato) e forma le classi
# Maximum Likelihood: si prende pixel per pixel e il software misura la distanza che ogni pixel ha (nello spazio multispettrale) dai pixel del training set 
#                     in base alla distanza più breve li inserisce nelle varie classi e infine associa ogni classe ad una label 
# library(RStoolbox) 
# funzione unsuperClass: opera la classificazione non supervisionata
# funzione set.seed: serve per fare una classificazione che sia sempre la stessa (usa sempre le stesse repliche per fare il modello) 
set.seed(42)

# Classificazione NON supervisionata per l'immagine del 1989 
# 3 classi: mi interessa solo: classe foresta - classe miniere - classe praterie coltivate
p1c <- unsuperClass(At1989, nClasses=3)

# controllo le informazioni
p1c
# unsuperClass results
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 990, 1000, 990000  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 990  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 3  (min, max)

# facciamo il plot totale, sia di d1c che della sua mappa all'interno
plot(p1c$map)
# Classe 1 (bianco) : Prateria + Acqua 
# Classe 2 (giallo) : Miniere  
# Classe 3 (verde) : Foresta boreale 

# Frequencies p1c$map 
# ci chiediamo quanta % di foresta è stata persa 
# qual è la frequenza delle 4 classi  
# funzione freq: funzione generale che genera tavole di frequenza e va a calcolarla
freq(p1c$map)
#         value  count
# [1,]     1    489157  -> pixel di prateria + acqua 
# [2,]     2     46475  -> pixel di miniera
# [3,]     3    454368  -> pixel di foresta boreale 

# calcoliamo la proporzione dei pixel per l'immagine p1c (consiste nella %)
# facciamo la somma dei valori di pixel e la chiamiamo s1
s1 <-  489157 + 46475 + 454368
prop1 <- freq(p1c$map) / s1 
prop1
#         value      count
# [1,] 1.010101e-06  0.49409798 -> 49.4 % prateria + acqua 
# [2,] 2.020202e-06  0.45895758 -> 45.9 % di foresta 
# [3,] 3.030303e-06  0.04694444 -> 4.7 % di miniera 


# Classificazione NON supervisionata per l'immagine del 2014
# 3 classi:
set.seed(42)
p2c <- unsuperClass(At2014, nClasses=3)

p2c
# unsuperClass results
# *************** Map ******************
# $map
# class      : RasterLayer 
# dimensions : 990, 1000, 990000  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 990  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      : layer 
# values     : 1, 3  (min, max)


plot(p2c$map)
# Classe 1 (bianco) : Prateria + Acqua 
# Classe 2 (giallo) : Miniere          
# Classe 3 (verde) : Foresta boreale 


# Frequencies p2c$map 
freq(p2c$map)
#        value  count
# [1,]     1    558016  558.106 pixel di prateria + acqua 
# [2,]     2    55961   55.961 pixel di miniere 
# [3,]     3    376023  76.023 pixel di foresta 


# facciamo la somma dei valori di pixel e la chiamiamo s2
s2 <- 558016 + 55961 + 376023
prop2 <- freq(p2c$map) / s2
prop2 
#            value      count
# [1,] 1.010101e-06   0.56365253 -> 56,4 % di prateria + acqua 
# [2,] 2.020202e-06   0.05652626 -> 5,7 % di miniera 
# [3,] 3.030303e-06   0.37982121 -> 37,9 % di foresta 

# Metto a confronto le due immagini classificate in un grafico con una riga e due colonne: 
par(mfrow=c(1,2))
plot(p1c$map)
plot(p2c$map)


# DataFrame 
# creo una tabella con 3 colonne
# prima colonna -> copertura: prateria coltivata - foresta boreale - miniere 
# seconda colonna -> % di classi dell'immagine p1c ->  percent_1989
# terza colonna -> % di classi dell'immagine p2c -> percent_2014

copertura <- c("Foresta boreale","Miniere","Praterie/Acqua")
percent_1989 <- c(45.9, 4.7, 49.4)
percent_2014 <- c(37.9, 5.7, 56.4) 

# creiamo il dataframe
# funzione data.frame: crea una tabella
# argomenti della funzione: sono le 3 colonne che ho appena creato
percentage <- data.frame(copertura, percent_1989, percent_2014)
percentage
#      copertura        percent_1989     percent_2014
# 1    Foresta boreale         45.9         37.9
# 2    Miniere                 4.7          5.7
# 3    Praterie/Acqua          49.4         56.4



# plotto il Dataframe con ggplot
# p1c -> creo il grafico per l'immagine del 1989 (At1989)
# library(ggplot2) 
# funzione ggplot
#         (nome del dataframe, aes(x=prima colonna, y=seconda colonna, color=copertura))
#          +
#         geom_bar(stat="identity", fill="white")

# color: si riferisce a quali oggetti vogliamo discriminare/distinguere nel grafico e nel nostro caso vogliamo discriminare le tre classi (copertura) 
# geom_bar: tipo di geometria del grafico perchè dobbiamo fare delle barre
# stat: indica il tipo di dati che utilizziamo e sono dati grezzi quindi si chiamano "identity" 
# fill: colore delle barre all'interno e mettiamo "white" 

p1 <- ggplot(percentage, aes(x=copertura, y=percent_1989, color=copertura))  +  geom_bar(stat="identity", fill="white")
p1


# p2c -> creo il grafico per l'immagine del 2014 (At2014)  
# funzione ggplot 
p2 <- ggplot(percentage, aes(x=copertura, y=percent_2014, color=copertura))  +  geom_bar(stat="identity", fill="white")
p2

# funzione grid.arrange: mette insieme dei vari plot di ggplot con le immagini
# library(gridExtra) for grid.arrange
# argomenti: p1, p2, numero di righe = 1  
grid.arrange(p1, p2, nrow=1)
# Le miniere e le praterie coltivate sono aumentate nel tempo come percentuale, mentre è diminuita la % di foresta boreale

# ---------------------------------------------------------------------------------------------------------------------------------------------------------------


# 5. VARIABILITA' SPAZIALE - ANALISI DELLE COMPONENTI PRINCIPALI

# La variabilità spaziale è un indice di biodiversità, vado a controllare quanto è eterogenea questa area
# > eterogeneità -> > biodiversità attesa 
# MOVING WINDOW: analizzo la variabilità spaziale tramite una tecnica chiamata moving window, ovvero sull'img originale si fa scorrere una moving window di nxn pixel 
#                e calcola un'operazione (da noi richiesta) per poi riportare il risultato sul pixel centrale 
#                poi la finestra mobile si muove nuovamente di un pixel verso destra e riesegue l'operazione per riportare il risultato sul nuovo pixel centrale
#                in questo modo si crea una nuova mappa finale i cui pixel periferici NON contengono valori, i pixel centrali hanno il risultato da noi calcolato 


# DEVIAZIONE STANDARD: calcolo la ds perchè è correlata con la variabilità siccome racchiude il 68% di tutte le osservazioni
# per calcolarla ci serve solo una banda, dunque bisogna compattare tutte le informazioni relative alle diverse bande in un unico strato


# ANALISI DELLE COMPONENTI PRINCIPALI
# faccio l'analisi multivariata per ottenere la PC1 e su questa calcolo la deviazione standard

# PCA immagine At1989
# library(RStoolbox)
# funzione rasterPCA: fa l'analisi delle componeneti principali di un det di dati
a1pca <- rasterPCA(At1989) 

# funzione summary: fornisce un sommario del modello, voglio sapere quanta variabilità spiegano le varie PC
summary(a1pca$model)
# Importance of components:
#                            Comp.1     Comp.2      Comp.3 Comp.4
# Standard deviation     51.0017266 39.9525617 15.45703283      0
# Proportion of Variance  0.5863387  0.3598057  0.05385562      0
# Cumulative Proportion   0.5863387  0.9461444  1.00000000      1

# La  prima componente principale (PC1) è quella che spiega il 58,6% dell’informazione originale

a1pca
# $call
# rasterPCA(img = At1989)

# $model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])

# Standard deviations:
#   Comp.1   Comp.2   Comp.3   Comp.4 
# 51.00173 39.95256 15.45703  0.00000 

# 4  variables and  990000 observations.

# $map
# class      : RasterBrick 
# dimensions : 990, 1000, 990000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 990  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      :        PC1,        PC2,        PC3,        PC4 
# min values : -168.71545,  -93.47232, -192.07486,    0.00000 
# max values :   231.0160,   282.1179,   135.0855,     0.0000 

# attr(,"class")
# [1] "rasterPCA" "RStoolbox"

# calcolo la deviazione standard sulla PC1
# lego l'immagine a1pca alla sua mapppa e alla PC1 per definire la prima componenete principale che chiamo pc1a1: 
pc1a1 <- a1pca$map$PC1

# library(raster) 
# funzione focal: funzione generica che calcola la statistica che vogliamo
#                 calcolo la deviazione standard sulla pc1 
# primo argomento: nome dell’immagine
# secondo argomento: w (window) uguale ad una matrice che è la nostra finestra spaziale e normalmente è quadrata (1/n.pixeltot, n.righe, n.colonne)
# terzo argomento: stiamo calcolando la deviazione standard che viene definita sd
# associamo il risultato della funzione all'oggetto pc1sd3a1 (deviazione standard sulla pc1 con una finestra mobile di 3x3 pixel)  
pc1sd3a1 <- focal(pc1a1, w=matrix(1/9, nrow=3, ncol=3), fun=sd)


# library(ggplot2)          -> per plottare con ggplot 
# library(gridExtra)        -> per mettere insieme tanti plot con ggplot
# library(viridis)          -> per i colori, colorare i plot con ggplot in modo automatico, funzione scale_fill_viridis

# plotto la sd della PC1 con ggplot: modo migliore perche individua ogni tipo di discontinuità ecologica e geografica:
# legenda Inferno:
a1 <- ggplot() + geom_raster(pc1sd3a1, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 in 1989 by inferno color scale")
a1
# Legenda:
#    giallo: aumento della sd al passaggio tra suolo e fiume e anche al passaggio tra foresta e prateria 
#    violetto: bassa sd che individua la città, le miniere e le strade
#    nero: bassa sd che indica una copertura omogenea di foresta boreale e una copertura omogenea di prateria coltivata 


# PCA per l'immgine At2014
a2pca <- rasterPCA(At2014) 

summary(a2pca$model)
# Importance of components:
#                            Comp.1     Comp.2      Comp.3 Comp.4
# Standard deviation     64.6197861 29.3892007 16.09073585      0
# Proportion of Variance  0.7881159  0.1630176  0.04886646      0
# Cumulative Proportion   0.7881159  0.9511335  1.00000000      1


# La prima componente principale (PC1) è quella che spiega il 78.8% dell’informazione originale

a2pca
$call
rasterPCA(img = At2014)

$model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])

# Standard deviations:
#   Comp.1   Comp.2   Comp.3   Comp.4 
# 64.61979 29.38920 16.09074  0.00000 

#  4  variables and  990000 observations.

# $map
# class      : RasterBrick 
#dimensions : 990, 1000, 990000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 990  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      :       PC1,       PC2,       PC3,       PC4 
# min values : -126.8333, -140.3601, -195.6748,    0.0000 
# max values :  311.3536,  138.6307,  119.3797,    0.0000 

# attr(,"class")
# [1] "rasterPCA" "RStoolbox"

# calcolo la deviazione standard sulla PC1
# lego l'immagine a2pca alla sua mapppa e alla PC1 per definire la prima componenete principale che nomino pc1a2: 
pc1a2 <- a2pca$map$PC1

# funzione focal: calcolo la deviazione standard sulla pc1 tramite la moving windows di 3x3 pixel 
pc1sd3a2 <- focal(pc1a2, w=matrix(1/9, nrow=3, ncol=3), fun=sd)


# library(ggplot2)          -> per plottare con ggplot 
# library(gridExtra)        -> per mettere insieme tanti plot con ggplot
# library(viridis)          -> per i colori, colorare i plot con ggplot in modo automatico, funzione scale_fill_viridis

# plotto la sd della PC1 con ggplot: modo migliore perche individua ogni tipo di discontinuità ecologica e geografica:
# legenda Inferno:
a2 <- ggplot() + geom_raster(pc1sd3a2, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 in 2014 by inferno color scale")
a2
# Legenda
#     giallo: sd alta -> individua il passaggio da foresta a prateria 
#     violetto: sd media -> individua strade, miniere e la parte urbana a sud
#     nero: sd molto bassa -> copertura omogenea di foresta boreale e di prateria coltivata 


grid.arrange(a1, a2, nrow=1) 
# con le due immagini a confronto si nota la differenza nell'uso del suolo nei due periodi:
#       nel 2014: c'è l'aumento della superficie delle miniere e l'aumento delle strade rispetto al 1989 con perdita di copertura forestale
