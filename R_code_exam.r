# R_code_exam.r
# PAPUA-INDONESIA 1990-2020

# Sito utilizzato per scaricare le immagini: https://eros.usgs.gov/image-gallery/earthshot/papua-indonesia
# Luogo di studio: Papua (provincia dell'Indonesia) 

# LIBRERIE E WORKING DIRECTORY
# Imposto le librerie necessarie per le indagini
# install.packages("raster")
library(raster) # per gestire i dati in formato raster 
# install.packages("RStoolbox) 
library(RStoolbox) 

# Settare la working directory
setwd("C:/esame_telerilevamento_2021/")

# Satellite LANDSAT 5 -> immagini 1990 - 2007  
# BANDE: 
#   -5: Swir
#   -4: Nir
#   -3: Red

# Satellite LANDSAT 8 -> immagini 2015 - 2020
#   -6: Swir 
#   -5: Nir
#   -4: Red
# ------------------------------------------------------------------------------------------------------------------------

# INTRODUZIONE - Caricare le immagini - Visualizzare le immagini e le relative informazioni

# Importo tutte le immagini:
# funzione brick: serve per importare dentro a R l'intera immagine satellitare costituita da tutte le sue singole bande (intero set di bande)
papua1990 <- brick("1_11-20-1990_Papua_Main(chs. 5,4,3).png")
papua2007 <- brick("3_1-19-2007_Papua_Main(chs. 5,4,3).png")
papua2015 <- brick("7_9-22-2015_Papua_Main(chs. 6,5,4).png")
papua2020 <- brick("8-18-2020_Papua_Main(chs_6,5,4).png")

# Leggo le informazioni di ogni file RasterBrick: 
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

papua2007
# class      : RasterBrick 
# dimensions : 869, 1000, 869000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 869  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/esame_telerilevamento_2021/3_1-19-2007_Papua_Main(chs. 5,4,3).png 
# names      : X3_1.19.2007_Papua_Main.chs._5.4.3..1, X3_1.19.2007_Papua_Main.chs._5.4.3..2, X3_1.19.2007_Papua_Main.chs._5.4.3..3, X3_1.19.2007_Papua_Main.chs._5.4.3..4 
# min values :                                     0,                                     0,                                     0,                                     0 
# max values :                                   255,                                   255,                                   255,                                   255 

papua2015
# class      : RasterBrick 
# dimensions : 869, 1000, 869000, 4  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 1000, 0, 869  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/esame_telerilevamento_2021/7_9-22-2015_Papua_Main(chs. 6,5,4).png 
# names      : X7_9.22.2015_Papua_Main.chs._6.5.4..1, X7_9.22.2015_Papua_Main.chs._6.5.4..2, X7_9.22.2015_Papua_Main.chs._6.5.4..3, X7_9.22.2015_Papua_Main.chs._6.5.4..4 
# min values :                                     0,                                     0,                                     0,                                     0 
# max values :                                   255,                                   255,                                   255,                                   255

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

# le 4 immagini sono dei RasterBrick e ognuna di queste è composta da 4 bande
# 869.000 pixel per ciascuna banda
# immagini a 8 bit -> 2^8 = 256 -> 0-255 valori 


# funzione plot: serve per visualizzare i dati, in questo caso visualizziamo tutte le 7 bande dell'intera immagine satellitare
plot(papua1990)
plot(papua2020) 

















