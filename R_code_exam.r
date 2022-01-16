# R_code_exam.r  
# Athabasca Oil Sand - Alberta - Canada 
# Sito utilizzato per scaricare le immagini: https://eros.usgs.gov/image-gallery/earthshot/athabasca-oil-sands-alberta-canada

# Una delle più grandi riserve di petrolio si trova nella foresta boreale in Canada, precisamente nell'Alberta nord-ovest
# Luogo di studio: a nord della città di Fort McMurray, sulle sponde del fiume Athabasca
# Le tecniche di estrazione del petrolio comprendono la deforestazione di parte della foresta boreale e questo crea delle miniere a cielo aperto
# In questo progetto si vuole osservare lo sviluppo delle miniere dal 1989 al 2016: anno dell'incendio vicino alla città di Fort McMurray che ha distrutto parte della foresta

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

# img 2016: Landsat 8
# Bande: 
#       1: Swir - 2: Nir - 3: Red 

# ------------------------------------------------------------------------------------------------------------------------------------------------------


# 1. INTRODUZIONE - Caricare le immagini - Visualizzare le immagini e le relative Informazioni associate

# Funzione brick: serve per importare dentro a R l'intera immagine satellitare costituita da tutte le sue singole bande (intero set di bande)
# ogni immagine è composta da 3 bande
# la funzione crea un oggetto che si chiama Rasterbrick: serie di bande in formato raster in un'unica immagine satellitare
At1989 <- brick("4_8-6-1989_McMurrayMain.png")
At2016 <- brick("12_7-15-2016_McMurrayMain.png")

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

At2016
# class      : RasterBrick 
# dimensions : 990, 1000, 990000, 3  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 990  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/esame_telerilevamento_2021/12_7-15-2016_McMurrayMain_labeled.png 
# names      : X12_7.15.2016_McMurrayMain_labeled.1, X12_7.15.2016_McMurrayMain_labeled.2, X12_7.15.2016_McMurrayMain_labeled.3 
# min values :                                    0,                                    0,                                    0 
# max values :                                  255,                                  255,                                  255 

# La classe è un RasterBrick: sono 3 bande in formato raster
# Ci sono 990.000 pixel per ogni banda
# Le due immagini sono a 8 bit: 2^8 = 256 -> da 0 a 255 valori 

# Funzione plot: visualizzo le 3 bande di ciascuna immagine e i relativi valori di riflettanza nella legenda: 
plot(At1989)
plot(At2016)
# la legenda riporta i valori interi di riflettanza approssimati in una scala in bit da 0 a 255


# SCHEMA RGB: attraverso lo schema RGB visualizzo le due immagini a colori falsi: 
# Posso utilizzare solo 3 bande alla volta per visualizzare le immagini intere 
# Funzione plotRGB: funzione che permette di visualizzare un oggetto raster multi-layered attraverso lo schema RGB 
# Monto la banda 1 (Swir) sulla componente Red; la banda 2 (Nir) sulla componente Green; la banda 3(Red) sulla componente Blue;
#     -> r=1, g=2, b=3
# Stretch lineare: prende i valori di riflettanza e li fa variare tra 0 e 1 (estremi) in maniera lineare
#                  serve per mostrare tutte le gradazioni di colore ed evitare uno schiacciamento verso una sola parte del colore
# Funzione par: metto le due immagini del 1989-2016 a confronto in un grafico con una riga e due colonne: 
par(mfrow=c(1,2)) 
plotRGB(At1989, r=1, g=2, b=3, stretch="Lin", main="Miniere nel 1989")
plotRGB(At2016, r=1, g=2, b=3, stretch="Lin", main="Miniere nel 2016")
# Verde: foresta boreale e praterie coltivate -> la vegetazione riflette molto il Nir (g=2 -> alto valore di riflettanza)
# Viola: miniere, molto aumentate come superficie nel 2016 
# Blu: fiume, stagni sterili
# Rossiccio: suolo nudo (foresta bruciata nel 2016)

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
levelplot(athabasca, col.regions=cs, main="Sviluppo delle miniere a cielo aperto nella provincia di Alberta", names.attr=c("2016" , "1989"))
# Si nota in rosa e rosso l'aumento delle miniere a cielo aperto e la diminuzione della foresta boreale 

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------


# 3. INDICI DI VEGETAZIONE - NDVI 

# NDVI = NIR - red / NIR + red 
# - 1 < NDVI < 1 

# associo dei nomi immediati alle bande:
nir1 <- At1989$X4_8.6.1989_McMurrayMain.2
red1 <- At1989$X4_8.6.1989_McMurrayMain.3
nir2 <- At2016$X12_7.15.2016_McMurrayMain.2
red2 <- At2016$X12_7.15.2016_McMurrayMain.3

clr <- colorRampPalette(c('dark blue', 'yellow', 'red', 'black'))(100)

# Calcolo il NDVI per l'immagine del 1989:
ndvi1 <- (nir1 - red1) / (nir1 + red1)
plot(ndvi1, col=clr, main="NDVI 1989")
# legenda:
#     rosso: NDVI alto, foresta borale sana e intatta
#     giallo: NDVI basso, aree di deforestazione per le miniere


# Calcolo il NDVI per l'immagine del 2016:
ndvi2 <- (nir2 - red2) / (nir2 + red2)
plot(ndvi2, col=clr, main="NDVI 2016") 
# Legenda:
#    rosso scuro: NDVI alto, foresta borale sana e intatta
#    giallo: NDVI basso, aree di deforestazione per le miniere, si nota un forte aumento di quest'area 

# metto le due immagini risultanti a confronto in un grafico con una riga e due colonne
par(mfrow=c(1,2))
plot(ndvi1, col=clr, main="NDVI 1989")
plot(ndvi2, col=clr, main="NDVI 2016")


# Cambiamento della vegetazione dal 1989 al 2016
# Differenza tra i due NDVI nei due tempi:
cld <- colorRampPalette(c('dark blue', 'white', 'red'))(100)
diffndvi <- ndvi1 - ndvi2
levelplot(diffndvi, col.regions=cld, main="NDVI 1989 - NDVI 2016")
# legenda:
#       rosso: > diff -> aree con la maggior perdita di vegetazione per l'aumento delle miniere e a sud per l'incendio del 2016
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
# Classe 1: Foresta 
# Classe 2: Prateria coltivata
# Classe 3: Miniere

# Frequencies p1c$map 
# ci chiediamo quanta % di foresta è stata persa 
# qual è la frequenza delle 4 classi  
# funzione freq: funzione generale che genera tavole di frequenza e va a calcolarla
freq(p1c$map)
#         value  count
# [1,]     1      489157 -> n. pixel di foresta
# [2,]     2      454368 -> n. pixel di prateria 
# [3,]     3      46475  -> n. pixel di miniere 

# calcoliamo la proporzione dei pixel per l'immagine p1c (consiste nella %)
# facciamo la somma dei valori di pixel e la chiamiamo s1
s1 <- 489157 + 454368 + 46475 
prop1 <- freq(p1c$map) / s1 
prop1
#           value      count
# [1,] 1.010101e-06   0.49409798 -> 49.4% di foresta boreale
# [2,] 2.020202e-06   0.45895758 -> 45.9% di prateria
# [3,] 3.030303e-06   0.04694444 -> 4.7% di miniere 


# Classificazione NON supervisionata per l'immagine del 2016
# 4 classi:
set.seed(42)
p2c <- unsuperClass(At2016, nClasses=3)

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
# Classe 1: Foresta boreale
# Classe 2: Miniere          
# Classe 3: Praterie coltivate


# Frequencies p2c$map 
freq(p2c$map)
#         value  count
# [1,]     1    397659  -> 397.659 pixel di foresta boreale
# [2,]     2     92935  -> 92.935 pixel di miniere 
# [3,]     3    499406  -> 499.406 pixel di praterie coltivate 


# facciamo la somma dei valori di pixel e la chiamiamo s2
s2 <- 397659 + 92935 + 499406
prop2 <- freq(p2c$map) / s2
prop2 
#         value       count
# [1,] 1.010101e-06   0.40167576  -> 40.1% di foresta boreale
# [2,] 2.020202e-06   0.09387374  -> 9.3% di miniere
# [3,] 3.030303e-06   0.50445051  -> 50.4% di praterie coltivate 

# Metto a confronto le due immagini classificate in un grafico con una riga e due colonne: 
par(mfrow=c(1,2))
plot(p1c$map)
plot(p2c$map)


# DataFrame 
# creo una tabella con 3 colonne
# prima colonna -> copertura: prateria coltivata - foresta boreale - miniere 
# seconda colonna -> % di classi dell'immagine p1c ->  percent_1989
# terza colonna -> % di classi dell'immagine p2c -> percent_2016

copertura <- c("Prateria coltivata","Foresta boreale","Miniere")
percent_1989 <- c(45.9, 49.4, 4.7)
percent_2016 <- c(50.4, 40.1, 9.3)

# creiamo il dataframe
# funzione data.frame: crea una tabella
# argomenti della funzione: sono le 3 colonne che ho appena creato
percentage <- data.frame(copertura, percent_1989, percent_2016)
percentage
#                copertura   percent_1989    percent_2016
# 1 Prateria coltivata         45.9         50.4
# 2    Foresta boreale         49.4         40.1
# 3            Miniere          4.7          9.3



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


# p2c -> creo il grafico per l'immagine del 2016 (At2016)  
# funzione ggplot 
p2 <- ggplot(percentage, aes(x=copertura, y=percent_2016, color=copertura))  +  geom_bar(stat="identity", fill="white")
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


# PCA per l'immgine At2016
a2pca <- rasterPCA(At2016) 

summary(a2pca$model)
# Importance of components:
#                            Comp.1     Comp.2      Comp.3
# Standard deviation     78.9600727 49.8364718 23.23955135
# Proportion of Variance  0.6734062  0.2682604  0.05833343
# Cumulative Proportion   0.6734062  0.9416666  1.00000000

# La prima componente principale (PC1) è quella che spiega il 67,3% dell’informazione originale

a2pca
# $call
# rasterPCA(img = At2016)

# $model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])

# Standard deviations:
#   Comp.1   Comp.2   Comp.3 
# 78.96007 49.83647 23.23955 

#  3  variables and  990000 observations.

#$map
# class      : RasterBrick 
# dimensions : 990, 1000, 990000, 3  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 990  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      :       PC1,       PC2,       PC3 
# min values : -115.7182, -149.0113, -168.5545 
# max values :  315.0527,  125.7507,  109.7049 

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
a2 <- ggplot() + geom_raster(pc1sd3a2, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 in 2016 by inferno color scale")
a2
# Legenda
#     giallo: sd alta -> individua il passaggio da foresta a prateria 
#     violetto: sd media -> individua strade, miniere e la parte urbana a sud
#     nero: sd molto bassa -> copertura omogenea di foresta boreale e di prateria coltivata 


grid.arrange(a1, a2, nrow=1) 
# con le due immagini a confronto si nota la differenza nell'uso del suolo nei due periodi:
#       nel 2016: c'è l'aumento della superficie delle miniere e l'aumento delle strade rispetto al 1989 con perdita di copertura forestale



# Calcolo la Biomassa per l'immagine del 1989 e del 2016
# la procedura rimane la stessa usata per il calcolo della deviazione standard
# con la funzione focal calcolo la media
# At1989: 
pc1m3a1 <- focal(pc1a1, w=matrix(1/9, nrow=3, ncol=3), fun=mean) 
# At2016:
pc1m3a2 <- focal(pc1a2, w=matrix(1/9, nrow=3, ncol=3), fun=mean)

# con la funzione ggplot mostro le due mappe che rappresentano la media calcolata sulla PC1: 
biomassa1 <- ggplot() + geom_raster(pc1m3a1, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Media of PC1 in 1989 by inferno color scale")
biomassa2 <- ggplot() + geom_raster(pc1m3a2, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Media of PC1 in 2016 by inferno color scale")
grid.arrange(biomassa1, biomassa2, nrow=1)
# CONCLUSIONE: Tramite il calcolo della biomassa si nota che dal 1989 al 2016 c'è una riduzione consistente della biomassa vegetale  
#     a causa della realizzazione di nuove miniere a cielo aperto e di nuove strade
