# R_code_copernicus.r
# Visualizing Copernicus data

# importiamo le librerie necessarie per le operazioni
library(raster)
# installiamo la libreria ncdf4 per visualizzare i dati in formato .nc
install.packages("ncdf4")
library(ncdf4) 

# settiamo la working directory
setwd("C:/lab/")

# procediamo con la lettura del file che abbiamo scaricato
# Energy Budget - ALBEDO - Hemispherical Albedo 1km Global V1
# funzione raster: vogliamo caricare un singolo strato/layer
# dobbiamo uscire da R perchè l’immagine è nella cartella lab e quindi mettiamo tutto tra ""
# associamo l'oggetto albedo alla funzione raster
albedo <- raster ("c_gls_ALBH_202006130000_GLOBE_PROBAV_V1.5.1.nc")
albedo
# class: RasterLayer 
# dimensions: 15680, 40320, 632.217.600  (nrow, ncol, ncell)
# resolution: 0.008928571, 0.008928571  (x, y) -> la risoluzione è in coordinate geografiche (gradi)  
# extent: -180.0045, 179.9955, -59.99554, 80.00446  (xmin, xmax, ymin, ymax)
# -180° a + 180° -> estensione possibile dei gradi di longitudine /  - 60° a + 80° -> estesnione possibile dei gradi di latitudine
# crs: +proj=longlat +ellps=WGS84 +no_defs -> sistema di riferimento WGS84 (world geodetic system) ellissoide che copre tutta superficie della terra  
# names: Broadband.hemispherical.albedo.over.total.spectrum -> nome dello strato 
# z-value: 2020-06-13 -> recente 
# zvar: AL_BH_BB -> come viene nominata la variabile per essere utilizzata

# colorRampPalette
# facciamo il plot di albedo con una colorRampPalette decisa da noi 
cl <- colorRampPalette(c('dark blue','green','red','yellow'))(100)
plot(albedo, col=cl) 
# vediamo la superficie dove viene riflessa più energia solare, i deserti riflettono di più perchè è tutto suolo nudo

# ricampionamento bilineare
# ricampioniamo il dato perchè vogliamo diminuire la sua risoluzione
# funzione aggregate: aggrega i pixel dell'immagine 
# > n.pixel -> > peso immagine
# fact: argomento della funzione aggregate, serve per diminuire il numero di pixel
# fact=100: diminuisce linearmente i pixel di 100 volte, prende 100 pixel x 100 pixel e lo trasforma in un solo pixel come media di tutti i pixel all’interno
albedores <- aggregate(albedo, fact=100)
albedores
# class: RasterLayer
# dimensions: 314, 807, 63428 (nrow, ncol, ncell) -> le informazioni sono diminuite di 10.000 volte (100x100) 

# funzione plot
plot(albedores, col=cl) 
# il plot si carica molto più velocemente perchè il file è più grezzo e i pixel al suo interno sono più grandi
