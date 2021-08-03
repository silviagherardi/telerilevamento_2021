# R_code_no2.r

# Stima della variazione della quantità degli ossidi di azoto nell’aria durante il primo lockdown
# Dati del satellite Sentinel
# Serie multitemporale di dati (immagini) da Gennaio a Marzo 2020
# Dati contenuti nella cartella EN (dentro la cartella lab) 

# 1. Set the working directory (cartella EN) 
setwd("C:/lab/EN") 
# impostiamo le librerie necessarie
library(raster) # for raster function
library(RStoolbox) # for PCA

# 2. Importiamo solo la prima immagine delle 13 possibili 
# funzione raster: serve per IMPORTARE singoli dati/singoli strati, quindi crea un oggetto chiamato raster layer
EN1 <- raster("EN_0001.png")

EN1
# class      : RasterLayer 
# band       : 1  (of  3  bands)
# dimensions : 432, 768, 331776  (nrow, ncol, ncell)
# resolution : 1, 1  (x, y)
# extent     : 0, 768, 0, 432  (xmin, xmax, ymin, ymax)
# crs        : NA 
# source     : C:/lab/EN/EN_0001.png 
# names      : EN_0001 
# values     : 0, 255  (min, max)

# 3. Plottiamo la prima immagine importanta con la colorRampPalette scelta da noi 
cls <- colorRampPalette(c("red","pink","orange","yellow")) (200)
plot(EN1, col=cls)
# il colore giallo individua le zone con NO2 più alto nel periodo di Gennaio 

# 4. Importiamo l'ultima immagine e plottiamo con la coloRampPalette precedente
EN13 <- raster("EN_0013.png")
plot(EN13, col=cls)
# il colore giallo individua le zone con NO2 più alto nel periodo di Marzo 

# 5. Facciamo la differenza tra le due immagini e plottiamo l’immagine risultante con la colorRampPalette precedente
# immagine 13 (Marzo) - immagine 1 (Gennaio) 
# se ho un valore basso a marzo e un valore alto a gennaio = il numero è negativo (-)
# se ho un valore alto a marzo e un valore basso a gennaio = il numero è positivo (+)
ENdif <- EN13 - EN1
plot(ENdif, col=cls)
# colore rosa: diminuzione dell'NO2 tra Gennaio (valore alto) a Marzo (valore basso)

# facciamo immagine 1 (Gennaio) - immagine 13 (Marzo)
ENdiff <- EN1 - EN13 
plot(ENdiff, col=cls)
# colore giallo: diminuzione forte dell'NO2 tra Gennaio e Marzo 

# 6. Plottiamo tutte e 3 le immagini insieme in 3 righe e 1 colonna
par(mfrow=c(3,1))
plot(EN1, col=cls, main="NO2 in January")
plot(EN13, col=cls, main="NO2 in March")
plot(ENdiff, col=cls, main="Difference of NO2 between January - March")

# 7. Importiamo tutto il set di bande insieme (13 immagini totali) 
# funzione list.files: creiamo la lista di file dove il pattern che si ripete in tutti i file è la parola "EN"
rlist <- list.files(pattern="EN")
# funzione lapply: applichiamo sulla lista (rlist) che contiene tutti file la funzione raster
import <- lapply(rlist, raster)
import
# funzione stack: compatta tutti i 13 file 
EN <- stack(import)
# plottiamo il risultato 
plot(EN, col=cls)

# 8. Replicare il plot dell'immagine 1 e 13 usando lo stack 
# usare lo stack di base, quindi l'oggetto EN 
# plottare entrambe le immagini in 2 righe e 1 colonna e usare la colorRampPalette precedente 
par(mfrow=c(2,1))
plot(EN$EN_0001, col=cls)
plot(EN$EN_0013, col=cls)

# 9. Facciamo una analisi multivariata di questo set (13 immagini a disposizione)
# abbiamo un set con 13 file e diminuiamo il set con una PCA
# library(RStoolbox) 
# funzione rasterPCA: Principal Component Analysis for Rasters: prende il pacchetto di dati e va a compattarli in un numero minore di bande
ENpca <- rasterPCA(EN)
summary(ENpca$model)
# Importance of components: 
#                             Comp.1      Comp.2      Comp.3      Comp.4    Comp.5     Comp.6      Comp.7      Comp.8     Comp.9        Comp.10        Comp.11       Comp.12         Comp.13
# Standard deviation     163.5712335 38.08295072 31.80383638 30.29988935  25.16267825 23.7453996 21.33981833  18.70124275 17.213091323  12.202732705  10.813131729  9.86088656   7.867219452
# Proportion of Variance   0.8142581  0.04413767  0.03078274  0.02794025 0.01926912   0.0171596   0.01385893   0.01064361  0.009017081   0.004531713   0.003558371    0.00295924      0.001883609
# Cumulative Proportion    0.8142581  0.85839573  0.88917847  0.91711872 0.93638784   0.9535474   0.96740637   0.97804999  0.987067068    0.991598781    0.995157151    0.99811639       1.000000000                      
plotRGB(ENpca$map, r=1, g=2, b=3, stretch="Lin")
# gran parte dell’informazione è nella componente red (prima banda)
# tutto quello che diventa rosso è quello che si è mantenuto stabile nel tempo

# 10. Vediamo la variabilità nella prima componente principale: compute the local variability (local standard deviation) of the first PC
# calcolo della variabilità sulla prima componente: 
PC1sd <- focal(ENpca$map$PC1, w=matrix(1/9, nrow=3, ncol=3), fun=sd)
plot(PC1sd, col=cls)
