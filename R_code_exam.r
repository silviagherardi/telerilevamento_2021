# R_code_exam.r
# Crescita dell'industria dell'olio di palma in Papua (pronvincia dell'Indonesia) 

# Sito utilizzato per scaricare le immagini: https://eros.usgs.gov/image-gallery/earthshot/papua-indonesia
# Luogo di studio: Papua pronvincia dell'Indonesia 

# LIBRERIE E WORKING DIRECTORY
# Imposto le librerie necessarie per le indagini
# install.packages("raster")
library(raster) # per gestire i dati in formato raster e le funzioni associate 
# install.packages("RStoolbox) 
library(RStoolbox) # 

# Settare la working directory
setwd("C:/esame_telerilevamento_2021/")

# img 1990: Landsat 5
# Bande: 
#       5: Swir; 4: Nir; 3: Red

# img 2020: Landsat 8
# Bande: 
#       6: Swir; 5: Nir; 4: Red


# ------------------------------------------------------------------------------------------------------------------------

# 1. INTRODUZIONE - Caricare le immagini - Visualizzare le immagini e le relative informazioni associate

# Funzione brick: serve per importare dentro a R l'intera immagine satellitare costituita da tutte le sue singole bande (intero set di bande)
# la funzione crea un oggetto che si chiama rasterbrick: serie di bande in formato raster in un'unica immagine satellitare
papua1990 <- brick("1_11-20-1990_Papua_Main(chs. 5,4,3).png")
papua2020 <- brick("8-18-2020_Papua_Main(chs_6,5,4).png")

# Controllo le informazioni dei due file: 
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


# Con la funzione plot visualizzo le 3 bande di ciascuna immagine
plot(papua1990)
plot(papua2020)


# SCHEMA RGB: attraverso lo schema RGB visualizzo l'immagine a colori falsi: 
# posso utilizzare solo 3 bande per volta per visualizzare l'immagine intera 
# Monto la banda 2(Nir) sulla componente Red; la banda 1 (Swir) sulla componente Green; la banda 3(Red) sulla componente Blue;
# -> r=2, g=1, b=3
# stretch lineare: prende i valori di riflettanza e li fa variare tra 0 e 1 
#                  serve per mostrare tutte le gradazioni di colore ed evitare uno schiacciamento verso una sola parte del colore
# Funzione par: metto le due immagini del 1990-2020 a confronto in un grafico con una riga e due colonne: 
par(mfrow=c(1,2)) 
plotRGB(papua1990, r=2, g=1, b=3, stretch="Lin")
plotRGB(papua2020, r=2, g=1, b=3, stretch="Lin")








