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
At2016 <- brick("12_7-15-2016_McMurrayMain_labeled.png")

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
# Monto la banda 1 (Swir) sulla componente Red; la banda 2 (Nir) sulla componente Green; la banda 3(Red) sulla componente Blue;
#     -> r=2, g=1, b=3
# Stretch lineare: prende i valori di riflettanza e li fa variare tra 0 e 1 (estremi) in maniera lineare
#                  serve per mostrare tutte le gradazioni di colore ed evitare uno schiacciamento verso una sola parte del colore
# Funzione par: metto le due immagini del 1990-2020 a confronto in un grafico con due righe e una colonna: 
par(mfrow=c(2,1)) 
plotRGB(At1989, r=1, g=2, b=3, stretch="Lin")
plotRGB(At2016, r=1, g=2, b=3, stretch="Lin")
# Verde: foresta boreale -> riflette molto il Nir (r=2 -> alto valore di riflettanza)
# Viola: miniere, molto aumentate come superficie nel 2016 
# Blu: fiume, stagni sterili
# Rossiccio: suolo nudo (foresta bruciata nel 2016)


# library(ggplot2) 
# funzione ggRGB: plottiamo le immagini raster con informazioni aggiuntive e con una grafica più accattivante rispetto a plotRGB
# abbiamo 3 bande per ogni immagine e possiamo creare una immagine singola di queste 3 bande grazie allo schema RGB
# monto la banda NIR(2) sulla componenete Red; la banda Swir(1) sulla componenete Green, la banda Red(3) sulla componenete Blue dello schema RGB
# library(gridExtra) 
# funzione grid.arrange: compone il multiframe e va a mettere insieme vari pezzi di un grafico plottati con ggRGB 
A1989 <- ggRGB(At1989, r=2, g=1, b=3, stretch="Lin")
A2016 <- ggRGB(At2016, r=2, g=1, b=3, stretch="Lin")
grid.arrange(A1989, A2016, nrow=2)

# ------------------------------------------------------------------------------------------------------------------------------------------------------


# 2. TIME SERIES ANALYSIS 
# La Time Series Analysis è utile per confrontare due o più immagini nel corso degli anni e capire dove sono avvenuti i cambiamenti principali 

# funzione list.files: creo una lista di file riconosciuta grazie al pattern "McMurrayMain" che si ripete nel nome
lista <- list.files(pattern="McMurrayMain")
# funzione lappy: applica la funzione (in questo caso raster) a tutta la lista di file appena creata
# funzione raster: importa i file
importa <- lapply(lista, raster)
# funzione stack: raggruppa i file appena importati in un unico blocco di file 
athabasca <- stack(importa) 

# funzione colorRampPalette: cambio la scala di colori di default proposta dal software con una gradazione di colori che possa marcare le differenze nei due periodi
# ogni colore è un etichetta scritta tra "" e sono diversi caratteri di uno stesso argomento dunque vanno messi in un vettore c 
# (100): argomento che indica i livelli per ciascun colore
cs <- colorRampPalette(c("dark blue","light blue","pink","red"))(100)

# library(rasterVis) 
# funzione levelplot: crea un grafico dove mette a confronto le due immagini in tempi diversi utilizzando un'unica legenda 
levelplot(athabasca, col.regions=cs, main="Sviluppo delle riserve di petrolio nella provincia di Alberta", names.attr=c("2016" , "1989"))
# Si nota in rosa e rosso l'aumento delle miniere a cielo aperto e la diminuzione della foresta boreale 


# Matrix Algebra: guardo la differenza tra il 1989 e il 2016 
# Sottraggo img 2016 - img 1989
athabasca_amount <- athabasca$X12_7.15.2016_McMurrayMain_labeled - athabasca$X4_8.6.1989_McMurrayMain
levelplot(athabasca_amount, col.regions=cs, main="variation 1989-2016")
# in questo modo vengono individuate le nuove riserve di petrolio e le rispettive miniere realizzate dal 1989 al 2016 

# ----------------------------------------------------------------------------------------------------------------------------------------------------------------


# 3. INDICI DI VEGETAZIONE - DVI - NDVI 

# DVI
# Calcolo il DVI per l'immagine del 1989:
# DVI = riflettanza NIR (1989) - riflettanza RED (1989) 
# -255 < DVI < +255
# associo dei nomi immediati alle bande:
nir <- At1989$X4_8.6.1989_McMurrayMain.2
red <- At1989$X4_8.6.1989_McMurrayMain.3
dvi1 <- nir - red 

# per ogni pixel si prende il valore di riflettanza della banda del NIR e questo viene sottratto al valore di riflettanza della banda del red
# dvi1 è la mappa del DVI: in uscita abbiamo una mappa formata da tanti pixel che sono la differenza tra infrarosso e rosso

# creo una ColorRamppalette che metta in risalto le zone con alto e basso valore di dvi:
cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi1, col=cl, main="DVI 1989") 
# rosso: DVI alto, per cui una vegetazione sana rappresentata dalla foresta boreale
# giallo: DVI basso, individua le riserve di petrolio per cui aree in cui la foretsa è stata disboscata 

# Calcolo il DVI per l'immagine del 2016:
# DVI = riflettanza NIR (2016) - riflettanza RED (2016) 
# -255 < DVI < +255
# associo dei nomi immediati alle bande:
nir2 <- At2016$X12_7.15.2016_McMurrayMain_labeled.2
red2 <- At2016$X12_7.15.2016_McMurrayMain_labeled.3
dvi2 <- nir2 - red2 

cl <- colorRampPalette(c('darkblue','yellow','red','black'))(100)
plot(dvi2, col=cl, main="DVI 2016") 
# rosso: DVI alto, per cui una vegetazione sana rappresentata dalla foresta boreale
# giallo: DVI basso, individua un forte aumento delle riserve di petrolio (aree in cui la foresta è stata disboscata) e a sud aree di suolo nudo a causa di un incendio nel 2016


# Com'è cambiata la vegetazione in questo settore dal 1989 al 2016?
# Si può capire facendo la differenza tra i due DVI nei diversi tempi 
diffdvi <- dvi1 - dvi2 
cld <- colorRampPalette(c('blue','white','red'))(100) 
plot(diffdvi, col=cld)
# legenda:
#       rosso: > diff: aree con la maggior perdita di vegetazione e maggiore sofferenza 
#       bianco: < diff: aree con la minor perdita di vegetazione e minore sofferenza



# NDVI
# NDVI = NIR - red / NIR + red 
# - 1 < NDVI < 1 

# Calcolo il NDVI per l'immagine del 1989:
ndvi1 <- (nir - red) / (nir + red)
plot(ndvi1, col=cl)
# legenda:
#     rosso: NDVI alto, foresta borale sana e intatta
#     giallo: NDVI basso, aree di deforestazione per le miniere


# Calcolo il NDVI per l'immagine del 2016:
ndvi2 <- (nir2 - red2) / (nir2 + red2)
plot(ndvi2, col=cl) 
# Legenda:
#    rosso scuro: NDVI alto, foresta borale sana e intatta
#    giallo: NDVI basso, aree di deforestazione per le miniere, si nota un forte aumento di quest'area 


# Cambiamento della vegetazione dal 1989 al 2016
# Differenza tra i due NDVI nei due tempi:
diffndvi <- ndvi1 - ndvi2
plot(diffndvi, col=cld)
# legenda:
#       rosso: > diff -> aree con la maggior perdita di vegetazione per l'aumento delle miniere e a sud per l'incendio del 2016
#       bianco: < diff -> aree con foresta boreale sana e intatta


# Metto a confronto le due differenze degli indici in un grafico con 1 riga e due colonne: 
par(mfrow=c(1,2))
plot(diffdvi, col=cld, main="Differenza DVI / 1989 - 2016")
plot(diffndvi, col=cld, main="Differenza NDVI / 1989 - 2016")
# con entrambi gli indici viene confermato l'aumento delle miniere e la conseguente diminuzione di foresta boreale per deforestazione 

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
# funzione rnorm: normalizza i valori dei pixel fissando la classe scelta
rnorm(1)

# Classificazione NON supervisionata per l'immagine del 1989 
# 3 classi: mi interessa solo: classe foresta - classe miniere
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
# Classe 1: Miniere 
# Classe 2:
#           Foresta boreale
# Classe 3: 


# Classificazione NON supervisionata per l'immagine del 2016
# 4 classi:
set.seed(42)
rnorm(1)
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
# Classe 1
#          Foresta boreale 
# Classe 3
# Classe 2: Miniere



# Frequencies p1c$map 
# ci chiediamo quanta % di foresta è stata persa 
# qual è la frequenza delle 4 classi  
# funzione freq: funzione generale che genera tavole di frequenza e va a calcolarla
freq(p1c$map)
#        value  count
# [1,]     1   18468   -> 18.468 pixel di miniere 
# [2,]     2  496207   
#                      -> 496.207 + 475.325 pixel di foresta boreale 
# [3,]     3  475325

# calcoliamo la proporzione dei pixel per l'immagine p1c (consiste nella %)
# facciamo la somma dei valori di pixel e la chiamiamo s1
s1 <- 18468 + 496207 + 475325
prop1 <- freq(p1c$map) / s1 
prop1
#       value         count
# [1,] 1.010101e-06  0.01865455   -> 2% miniere 
# [2,] 2.020202e-06  0.50121919
#                                 -> 98% foresta boreale 
# [3,] 3.030303e-06  0.48012626


# Frequencies p2c$map 
freq(p2c$map)
#        value  count
# [1,]     1   397648  ->  397.648 pixel di foresta boreale 
# [2,]     2   92936   ->  92.936 pixel di miniere
# [3,]     3   499416  ->  499.416 pixel di foresta boreale 


# facciamo la somma dei valori di pixel e la chiamiamo s2
s2 <- 397648 + 92936 + 499416
prop2 <- freq(p2c$map) / s2
prop2 

#       value        count
# [1,] 1.010101e-06  0.40166465   -> 40% foresta boreale 
# [2,] 2.020202e-06  0.09387475   -> 9,3% miniere
# [3,] 3.030303e-06  0.50446061   -> 50% foresta boreale 



# DataFrame 
# creo una tabella con 3 colonne
# prima colonna -> cover: foresta boreale - miniere 
# seconda colonna -> % di classi dell'immagine p1c ->  percent_1989
# terza colonna -> % di classi dell'immagine p2c -> percent_2016

cover <- c("Foresta boreale" , "Miniere")
percent_1989 <- c(98, 2)
percent_2016 <- c(90.5, 9.5)

# creiamo il dataframe
# funzione data.frame: crea una tabella
# argomenti della funzione: sono le 3 colonne che ho appena creato
percentage <- data.frame(cover, percent_1989, percent_2016)
percentage
#       cover                 percent_1989    percent_2016
# 1     Foresta boreale           98             90.5
# 2     Miniere                   2              9.5



# plotto il Dataframe con ggplot
# p1c -> creo il grafico per l'immagine del 1989 (At1989)
# library(ggplot2) 
# funzione ggplot
#         (nome del dataframe, aes(prima colonna, seconda colonna, color=cover))
#          +
#         geom_bar(stat="identity", fill="white")

# color: si riferisce a quali oggetti vogliamo discriminare/distinguere nel grafico e nel nostro caso vogliamo discriminare le due classi
# geom_bar: tipo di geometria del grafico perchè dobbiamo fare delle barre
# stat: indica il tipo di dati che utilizziamo e sono dati grezzi quindi si chiamano "identity" 
# fill: colore delle barre all'interno e mettiamo "white" 

p1 <- ggplot(percentage, aes(x=cover, y=percent_1989, color=cover))  +  geom_bar(stat="identity", fill="white")
p1


# p2c -> creo il grafico per l'immagine del 2016 (At2016)  
# funzione ggplot 
p2 <- ggplot(percentage, aes(x=cover, y=percent_2016, color=cover))  +  geom_bar(stat="identity", fill="white")
p2

# funzione grid.arrange: mette insieme dei vari plot di ggplot con le immagini
# library(gridExtra) for grid.arrange
# argomenti: p1, p2, numero di righe = 1  
grid.arrange(p1, p2, nrow=1)
# prima immagine: vediamo la foresta con un valore alto e le miniere con un valore abbastanza basso
# seconda immagine: vediamo le miniere che nel frattempo sono state costruite a discapto di un piccolo abbassamento del valore delle foreste disboscate


# ---------------------------------------------------------------------------------------------------------------------------------------------------------------


# 5. VARIABILITA' SPAZIALE - INDICE DI VEGETAZIONE - ANALISI DELLE COMPONENTI PRINCIPALI

# La variabilità spaziale è un indice di biodiversità, vado a controllare quanto è eterogenea questa area
# > eterogeneità -> > biodiversità attesa 
# MOVING WINDOW: analizzo la variabilità spaziale tramite una tecnica chiamata moving window, ovvero sull'img originale si fa scorrere una moving window di nxn pixel 
#                e calcola un'operazione (da noi richiesta) per poi riportare il risultato sul pixel centrale 
#                poi la finestra mobile si muove nuovamente di un pixel verso destra e riesegue l'operazione per riportare il risultato sul nuovo pixel centrale
#                in questo modo si crea una nuova mappa finale i cui pixel periferici NON contengono valori, i pixel centrali hanno il risultato da noi calcolato 


# DEVIAZIONE STANDARD: calcolo la ds perchè è correlata con la variabilità siccome racchiude il 68% di tutte le osservazioni
# per calcolarla ci serve solo una banda , dunque bisogna compattare tutte le informazioni relative alle diverse bande in un unico strato

# PRIMO METODO: NDVI (calcolato in precedenza) 
# per l'immagine At1989 -> ndvi1 
# library(raster) 
# funzione focal: funzione generica che calcola la statistica che vogliamo
# primo argomento: nome dell’immagine
# secondo argomento: w (window) uguale ad una matrice che è la nostra finestra spaziale e normalmente è quadrata (1/n.pixeltot, n.righe, n.colonne)
# terzo argomento: stiamo calcolando la deviazione standard che viene definita sd
# associamo il risultato della funzione all'oggetto ndvisd3 (deviazione standard di ndvi con una finestra mobile di 3x3 pixel) 
ndvisd3 <- focal(ndvi1, w=matrix(1/9, nrow=3, ncol=3), fun=sd)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
plot(ndvisd3, col=clsd)
# Legenda:
#       rosso: sd alta -> passaggio da suolo ad acqua del fiume
#       violetto: sd media -> individua strade, miniere
#       verde e blu: sd bassa  -> copertura omogenea di foresta boreale 


# per l'immagine At2019 -> ndvi2 
ndvi2sd3 <- focal(ndvi2, w=matrix(1/9, nrow=3, ncol=3), fun=sd)
plot(ndvi2sd3, col=clsd)  
# Legenda:
#      rosso: sd alta -> passaggio da suolo ad acqua del fiume 
#      violeto: sd media -> individua le strade e le miniere 
#      verde e blu: sd bassa -> copertura omogenea di foresta boreale 

par(mfrow=c(1,2))
plot(ndvisd3, col=clsd, main="SD-NDVI in 1989")
plot(ndvi2sd3, col=clsd, main="SD-NDVI in 2016")
# tramite il calcolo della sd si nota che nel 2016 è aumentato l'impatto antropico rappresentato da strade e miniere



# Calcolo la media della BIOMASSA per l'immagine del 1989 e del 2016
# At1989: 
ndvimean3 <- focal(ndvi1, w=matrix(1/9, nrow=3, ncol=3), fun=mean)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
plot(ndvimean3, col=clsd)
# Legenda:
#        rosso-giallo: media alta per la foresta boreale
#        verde-blu: media bassa che individua le miniere

# At2016:
ndvi2mean3 <- focal(ndvi2, w=matrix(1/9, nrow=3, ncol=3), fun=mean)
clsd <- colorRampPalette(c('blue','green','pink','magenta','orange','brown','red','yellow'))(100) 
plot(ndvi2mean3, col=clsd)
# Legenda:
#      rosso-giallo: media alta per la parte di foresta borale rimasta
#      verde-blu: media bassa che individua le miniere e le strade 

par(mfrow=c(1,2))
plot(ndvimean3, col=clsd, main="MEAN-NDVI - 1989")
plot(ndvi2mean3, col=clsd, main="MEAN-NDVI - 2016") 
# Tramite il calcolo della biomassa si nota che dal 1989 al 2016 c'è una riduzione della biomassa a causa della realizzazione di nuove miniere a cielo aperto 
# e della relizzazione di nuove strade, inoltre si nota a sud una perdita di biodiversità a causa dell'incendio del 2016 




# SECONDO METODO: PCA - ANALISI DELLE COMPONENTI PRINCIPALI

# faccio l'analisi multivariata per ottenere la PC1 e su questa calcolo la deviazione standard
# PCA immagine papua1990
# library(RStoolbox)
p1pca <- rasterPCA(At1989) 


# funzione summary: fornisce un sommario del modello, voglio sapere quanta variabilità spiegano le varie PC
summary(p1pca$model)
# Importance of components:
#                            Comp.1     Comp.2      Comp.3 Comp.4
# Standard deviation     51.0017266 39.9525617 15.45703283      0
# Proportion of Variance  0.5863387  0.3598057  0.05385562      0
# Cumulative Proportion   0.5863387  0.9461444  1.00000000      1

# La  prima componente principale (PC1) è quella che spiega il 58,6% dell’informazione originale

p1pca
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
# lego l'immagine p1pca alla sua mapppa e alla PC1 per definire la prima componenete principale: 
pc1 <- p1pca$map$PC1

# funzione focal: calcolo la deviazione standard sulla pc1 tramite la moving windows di 3x3 pixel 
pc1sd3 <- focal(pc1, w=matrix(1/9, nrow=3, ncol=3), fun=sd)


# library(ggplot2)          -> per plottare con ggplot 
# library(gridExtra)        -> per mettere insieme tanti plot con ggplot
# library(viridis)          -> per i colori, colorare i plot con ggplot in modo automatico, funzione scale_fill_viridis

# plotto la sd della PC1 con ggplot: modo migliore perche individua ogni tipo di discontinuità ecologica e geografica:
# legenda Inferno:
a1 <- ggplot() + geom_raster(pc1sd3, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 in 1989 by inferno color scale")
a1
# Legenda:
#    giallo: aumento della sd al passaggio tra suolo e fiume 
#    violetto: bassa sd che individua la città, le miniere e le strade
#    nero: bassa sd che indica una copertura omogenea di foresta boreale


# PCA immgine At2016
p2pca <- rasterPCA(At2016) 


summary(p2pca$model)
# Importance of components:
#                            Comp.1     Comp.2      Comp.3
# Standard deviation     78.9600727 49.8364718 23.23955135
# Proportion of Variance  0.6734062  0.2682604  0.05833343
# Cumulative Proportion   0.6734062  0.9416666  1.00000000

# La prima componente principale (PC1) è quella che spiega il 67,3% dell’informazione originale

p2pca
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
# lego l'immagine p2pca alla sua mapppa e alla PC1 per definire la prima componenete principale: 
pc1 <- p2pca$map$PC1

# funzione focal: calcolo la deviazione standard sulla pc1 tramite la moving windows di 3x3 pixel 
pc2sd3 <- focal(pc1, w=matrix(1/9, nrow=3, ncol=3), fun=sd)


# library(ggplot2)          -> per plottare con ggplot 
# library(gridExtra)        -> per mettere insieme tanti plot con ggplot
# library(viridis)          -> per i colori, colorare i plot con ggplot in modo automatico, funzione scale_fill_viridis

# plotto la sd della PC1 con ggplot: modo migliore perche individua ogni tipo di discontinuità ecologica e geografica:
# legenda Inferno:
a2 <- ggplot() + geom_raster(pc2sd3, mapping=aes(x=x, y=y, fill=layer)) + scale_fill_viridis(option="inferno") + ggtitle("Standard deviation of PC1 in 2016 by inferno color scale")
a2
# Legenda
#     violetto: sd media -> individua strade, miniere e la parte urbana a sud
#     nero: sd molto bassa -> copertura omogenea di foresta boreale


grid.arrange(a1, a2, nrow=1) 
# con le due immagini a confronto si nota la differenza nell'uso del suolo nei due periodi:
#       nel 2016: c'è l'aumento della superficie delle miniere e l'aumento delle strade rispetto al 1989 con perdita di copertura forestale 
