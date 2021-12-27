# R_code_exam.r
# World of Change: manto nevoso in Sierra Nevada


# Sito utilizzato per scaricare le immagini: https://earthobservatory.nasa.gov/world-of-change/SierraNevada
# Luogo di studio: Sierra Nevada (California) 

# LIBRERIE E WORKING DIRECTORY
# Imposto le librerie necessarie per le indagini
# install.packages("raster")
library(raster) # per gestire i dati in formato raster e le funzioni associate 
# install.packages("RStoolbox) 
library(RStoolbox) # 

# Settare la working directory
setwd("C:/esame_telerilevamento_2021/")


# ------------------------------------------------------------------------------------------------------------------------

# INTRODUZIONE - Caricare le immagini - Visualizzare le immagini e le relative informazioni

# funzione brick: serve per importare dentro a R l'intera immagine satellitare costituita da tutte le sue singole bande (intero set di bande)
sn2006 <- brick("sierranevada_tmo_200685.jpg")
sn2015 <- brick("sierranevada_tmo_201590.jpg")

#
sn2006
# class      : RasterBrick 
# dimensions : 720, 720, 518400, 3  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 720  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/esame_telerilevamento_2021/sierranevada_tmo_200685.jpg 
# names      : sierranevada_tmo_200685.1, sierranevada_tmo_200685.2, sierranevada_tmo_200685.3 
# min values :                         0,                         0,                         0 
# max values :                       255,                       255,                       255 

sn2015
# class      : RasterBrick 
# dimensions : 720, 720, 518400, 3  (nrow, ncol, ncell, nlayers)
# resolution : 1, 1  (x, y)
# extent     : 0, 720, 0, 720  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/esame_telerilevamento_2021/sierranevada_tmo_201590.jpg 
# names      : sierranevada_tmo_201590.1, sierranevada_tmo_201590.2, sierranevada_tmo_201590.3 
# min values :                         0,                         0,                         0 
# max values :                       255,                       255,                       255 










