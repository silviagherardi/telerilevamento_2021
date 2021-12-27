# R_code_exam.r
# Crescita dell'industria dell'olio di palma in Papua (pronvincia dell'Indonesia) 

# Sito utilizzato per scaricare le immagini: https://eros.usgs.gov/image-gallery/earthshot/papua-indonesia
# Luogo di studio: Papua pronvincia dell'Indonesia 

# LIBRERIE 
# Imposto le librerie necessarie per le indagini
# install.packages("raster")
library(raster) # per gestire i dati in formato raster e le funzioni associate 
# install.packages("RStoolbox") 
library(RStoolbox)            # per la classificazione non supervisionata  - per l'analisi delle componenti principali 
# install.packages("ggplot2")
library(ggplot2)              # per la funzione ggRGB e per la funzione ggplot 
# install.packages(gridExtra)
library(gridExtra)            # per la funzione grid.arrange
# install.packages(viris) 
library(viridis)          # per la funzione scale_fill_viridis

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
# 4 classi: 
#         - foresta pluviale tropicale
#         - parte agricola
#         - acqua
#         - suolo nudo
p1c <- unsuperClass(papua1990, nClasses=4)

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
# values     : 1, 4  (min, max)   

# facciamo il plot totale, sia di d1c che della sua mappa all'interno
plot(p1c$map)
# classe 1: foresta tropicale (bianco)
# classe 2: suolo nudo (arancione)
# classe 3: acqua (verde chiaro) 
# classe 4: campi agricoli (verde scuro) 


# Classificazione NON supervisionata per l'immagine del 2020
# 5 classi:
set.seed(42)
p2c <- unsuperClass(papua2020, nClasses=4)

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
# values     : 1, 4  (min, max)

plot(p2c$map)
# Classe 1: strade - infrastrutture (bianco)
# Classe 2: coltivazioni di palma (arancione) 
# Classe 3: campi agricoli + acqua (verde chiaro) 
# Classe 4: foresta tropicale (verde scuro) 


# <<<<<<<<<---------------RIGUARDARE TUTTO DA QUI ------------- <<<<<<<<<
# Frequencies p1c$map 
# ci chiediamo quanta % di foresta è stata persa 
# qual è la frequenza delle 4 classi  
# funzione freq: funzione generale che genera tavole di frequenza e va a calcolarla
freq(p1c$map)
#        value  count
# [1,]     1    610675  -> 610.675 pixel di foresta tropicale
# [2,]     2    20317   -> 20.317 pixel di suolo nudo 
# [3,]     3    15548   -> 15.548 pixel di acqua
# [4,]     4    222460  -> 222.460 pixel di campi coltivati 

# calcoliamo la proporzione dei pixel per l'immagine p1c (consiste nella %)
# facciamo la somma dei valori di pixel e la chiamiamo s1
s1 <- 610675 + 20317 + 15548 + 222460
prop1 <- freq(p1c$map) / s1 
prop1
#         value      count
# [1,] 1.150748e-06 0.70273303 -> 70% di foresta tropicale
# [2,] 2.301496e-06 0.02337975 -> 2,3% di suolo nudo 
# [3,] 3.452244e-06 0.01789183 -> 1,7% di acqua 
# [4,] 4.602992e-06 0.25599540 -> 25,6% di campi coltivati 



# Frequencies p2c$map 
freq(p2c$map)
#         value  count
# [1,]     1    596799  -> 596.799 pixel di foresta tropicale 
# [2,]     2    140055  -> 140.055 pixel di coltivazioni di palma 
# [3,]     3     32422  -> 32.422 pixel di strade o infrastrutture
# [4,]     4     49625  -> 
#                           49.625 + 50.099 pixel di campi coltivati più acqua 
# [5,]     5     50099  -> 

# facciamo la somma dei valori di pixel e la chiamiamo s2
s2 <- 596799 + 140055 + 32422 + 49625 + 50099
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

# -----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# 4. VARIABILITA' SPAZIALE - INDICE DI VEGETAZIONE - ANALISI DELLE COMPONENTI PRINCIPALI

# La variabilità spaziale è un indice di biodiversità, vado a controllare quanto è eterogenea questa area
# > eterogeneità -> > biodiversità attesa 
# MOVING WINDOW: analizzo la variabilità spaziale tramite una tecnica chiamata moving window, ovvero sull'img originale si fa scorrere una moving window di nxn pixel 
#                e calcola un'operazione (da noi richiesta) per poi riportare il risultato sul pixel centrale 
#                poi la finestra mobile si muove nuovamente di un pixel verso destra e riesegue l'operazione per riportare il risultato sul nuovo pixel centrale
#                in questo modo si crea una nuova mappa finale i cui pixel periferici NON contengono valori, i pixel centrali hanno il risultato da noi calcolato 


# DEVIAZIONE STANDARD: calcolo la ds perchè è correlata con la variabilità siccome racchiude il 68% di tutte le osservazioni
# per calcolarla ci serve solo una banda , dunque bisogna compattare tutte le informazioni relative alle diverse bande in un unico strato

# PRIMO METODO: NDVI (calcolato in precedenza) 
# per l'immagine papua1990 -> ndvi1 
# funzione focal: funzione generica che calcola la statistica che vogliamo
# primo argomento: nome dell’immagine
# secondo argomento: w (window) uguale ad una matrice che è la nostra finestra spaziale e normalmente è quadrata (1/n.pixeltot, n.righe, n.colonne)
# terzo argomento: stiamo calcolando la deviazione standard che viene definita sd
# associamo il risultato della funzione all'oggetto ndvisd3 (deviazione standard di ndvi con una finestra mobile di 3x3 pixel) 
ndvisd3 <- focal(ndvi1, w=matrix(1/9, nrow=3, ncol=3), fun=sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
plot(ndvisd3, col=clsd) 
# Lengeda:
#       rosso: sd alta -> dove si passa da campi coltivati all'acqua del fiume
#       violetto: sd media -> dove ci sono i campi coltivati
#       verde-blu: sd bassa -> parti omogenee di foresta pluviale 


# per l'immagine papua2020 -> ndvi2 
ndvi2sd3 <- focal(ndvi2, w=matrix(1/9, nrow=3, ncol=3), fun=sd)
plot(ndvi2sd3, col=clsd) 
# Legenda:
#       rosso: sd alta -> dove si passa da campi coltivati all'acqua del fiume
#       violetto: sd media -> dove si passa da campi coltivati e coltivazioni di palma 
#       verde: sd bassa -> parti omogenee di coltivazioni di palma
#       blu: sd bassa -> parti omogenee di foresta pluviale 

par(mfrow=c(1,2))
plot(ndvisd3, col=clsd, main="SD-NDVI - 1990")
plot(ndvi2sd3, col=clsd, main="SD-NDVI - 2020") 
# tramite il calcolo della sd si nota che nel 2020 aumenta la copertura di coltivazioni di palme a discapito della foresta pluviale 


# Calcolo la media della biomassa per l'immagine del 1990 e del 2020
# papua1990: 
ndvimean3 <- focal(ndvi1, w=matrix(1/9, nrow=3, ncol=3), fun=mean)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
plot(ndvimean3, col=clsd)
# Legenda: 
#       gialla: media molto alta ed è la biomassa della foresta tropicale
#       violetto: media bassa per i campi agricoli
#       blu: media molto bassa per l'acqua 

# papua2020:
ndvi2mean3 <- focal(ndvi2, w=matrix(1/9, nrow=3, ncol=3), fun=mean)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
plot(ndvi2mean3, col=clsd)
# Legenda:
#      rossa-gialla: media alta ed è la biomassa della foresta tropicale più le coltivazioni di palma
#      violetto: media bassa per i campi agricoli
#      blu: media molto bassa per l'acqua 

par(mfrow=c(1,2))
plot(ndvimean3, col=clsd, main="MEAN-NDVI - 1990")
plot(ndvi2mean3, col=clsd, main="MEAN-NDVI - 2020") 
# tramite il calcolo della media si nota che nel 2020 la biomassa della foresta pluviale tropicale è diminuita a causa delle coltivazioni di palme 



# SECONDO METODO: PCA - ANALISI DELLE COMPONENTI PRINCIPALI

# faccio l'analisi multivariata per ottenere la PC1 e su questa calcolo la deviazione standard
# PCA immagine papua1990
# library(RStoolbox)
p1pca <- rasterPCA(papua1990) 

# funzione summary: fornisce un sommario del modello, voglio sapere quanta variabilità spiegano le varie PC
summary(p1pca$model)
# Importance of components:
#                           Comp.1     Comp.2     Comp.3 Comp.4
# Standard deviation     40.7714908 33.6006175 14.7007470      0
# Proportion of Variance  0.5527363  0.3754043  0.0718594      0
# Cumulative Proportion   0.5527363  0.9281406  1.0000000      1

# La prima componente principale (PC1) è quella che spiega il 55,2% dell’informazione originale

p1pca
# $call
# rasterPCA(img = papua1990)

# $model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])

# Standard deviations:
#   Comp.1   Comp.2   Comp.3   Comp.4 
# 40.77149 33.60062 14.70075  0.00000 

# 4  variables and  869000 observations.

# $map
# class      : RasterBrick 
# dimensions : 869, 1000, 869000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 869  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      :        PC1,        PC2,        PC3,        PC4 
# min values : -306.93958, -192.22703,  -98.31689,    0.00000 
# max values :   80.35738,  244.91039,  135.25631,    0.00000 

# attr(,"class")
# [1] "rasterPCA" "RStoolbox"

# calcolo la deviazione standard sulla PC1
# lego l'immagine p1pca alla sua mapppa e alla PC1 per definire la prima componenete principale: 
pc1 <- p1pca$map$PC1

# funzione focal: calcolo la deviazione standard sulla pc1 tramite la moving windows di 3x3 pixel 
pc1sd3 <- focal(pc1, w=matrix(1/9, nrow=3, ncol=3), fun=sd)

# library(ggplot2)          -> per plottare con ggplot 
# library(gridExtra)        -> per mettere insieme tanti plot con ggplot
# library(viridis)          -> per i colori, colorare i plot con ggplot in modo automatico, funzione scale_fill_viridis

# plotto la sd della PC1 con ggplot: modo migliore perche individua ogni tipo di discontinuità ecologica e geografica:
# legenda Inferno:
p1 <- ggplot() + geom_raster(pc1sd3, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1-1990 by inferno color scale")
p1
# Legenda
#       giallo: sd alta -> dove c'è il passaggio tra aree agricole e l'acqua del fiume
#       violetto: sd media -> in prossimità del fiume dove ci sono le aree agricole 
#       nero: sd bassa -> copertura omogenea di foresta tropicale 


# PCA immgine papua2020
p2pca <- rasterPCA(papua2020) 

summary(p1pca$model)
# Importance of components:
#                            Comp.1     Comp.2     Comp.3 Comp.4
# Standard deviation     40.7714908 33.6006175 14.7007470      0
# Proportion of Variance  0.5527363  0.3754043  0.0718594      0
# Cumulative Proportion   0.5527363  0.9281406  1.0000000      1

# La prima componente principale (PC1) è quella che spiega il 55,2% dell’informazione originale

p2pca
# $call
# rasterPCA(img = papua2020)

# $model
# Call:
# princomp(cor = spca, covmat = covMat[[1]])

# Standard deviations:
#   Comp.1   Comp.2   Comp.3   Comp.4 
# 59.61909 37.62946 11.95059  0.00000 

# 4  variables and  869000 observations.

# $map
# class      : RasterBrick 
# dimensions : 869, 1000, 869000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 869  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : memory
# names      :        PC1,        PC2,        PC3,        PC4 
# min values : -207.00688,  -68.68516,  -96.19451,    0.00000 
# max values :   194.2029,   254.2511,   140.5549,     0.0000 

# attr(,"class")
# [1] "rasterPCA" "RStoolbox"

# calcolo la deviazione standard sulla PC1
# lego l'immagine p2pca alla sua mapppa e alla PC1 per definire la prima componenete principale: 
pc1 <- p2pca$map$PC1

# funzione focal: calcolo la deviazione standard sulla pc1 tramite la moving windows di 3x3 pixel 
pc2sd3 <- focal(pc1, w=matrix(1/9, nrow=3, ncol=3), fun=sd)

# library(ggplot2)          -> per plottare con ggplot 
# library(gridExtra)        -> per mettere insieme tanti plot con ggplot
# library(viridis)          -> per i colori, colorare i plot con ggplot in modo automatico, funzione scale_fill_viridis

# plotto la sd della PC1 con ggplot: modo migliore perche individua ogni tipo di discontinuità ecologica e geografica:
# legenda Inferno:
p2 <- ggplot() + geom_raster(pc2sd3, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1-2020 by inferno color scale")
p2
# Legenda:
#       giallo: sd alta -> dove c'è il passaggio tra aree agricole e l'acqua del fiume
#       violetto: sd media -> in prossimità del fiume dove ci sono le aree agricole e al passaggio tra foresta tropicale e coltivazioni di palma
#       nero: sd bassa -> copertura omogenea di foresta tropicale 

grid.arrange(p1, p2, nrow=1) 
# con le due immagini a confronto si nota la differenza dell'uso del suolo nei due tempi:
#       nel 2020: aumento delle coltivazioni di palma e dei campi agricoli in prossimità del fiume

