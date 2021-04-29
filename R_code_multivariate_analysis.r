# R_code_multivariate_analysis.r 
# Analisi multivariata: PCA (dati Landsat, 30m)
# usiamo una PCA per compattare il sistema in un numero inferiore di bande ma conservando la stessa proporzione

# librerie e working directory
library(raster)
library(RStoolbox)
setwd("C:/lab/") 

# bande di Landsat:
# b1: blu
# b2: verde
# b3: rosso 
# b4: NIR 

# funzione brick: carichiamo l'immagine intera costiuita da 7 bande (RasterBrick) 
p224r63_2011 <- brick("p224r63_2011_masked.grd")
# plottiamo l'immagine per vedere le 7 bande
plot(p224r63_2011)
# vediamo le informazioni dell'immagine
p224r63_2011
# class: RasterBrick
# dimensions: 1499, 2967, 4.447.533, 7  (nrow, ncol, ncell, nlayers)
# resolution: 30, 30  (x, y)
# extent: 579765, 668775, -522705, -477735  (xmin, xmax, ymin, ymax)
# crs: +proj=utm +zone=22 +datum=WGS84 +units=m +no_defs 
# source:    
# names: B1_sre, B2_sre, B3_sre, B4_sre, B5_sre, B6_bt, B7_sre 
# min values: 0.000000e+00, 0.000000e+00, 0.000000e+00, 1.196277e-02, 4.116526e-03, 2.951000e+02, 0.000000e+00 
# max values:    0.1249041,    0.2563655,    0.2591587,    0.5592193,    0.4894984,  305.2000000,    0.3692634 

# correliamo la banda del blu e la banda del verde: dobbiamo plottare la banda del blu contro la banda del verde
# banda blu: B1_sre -> asse X
# banda verde: B2_sre -> asse Y
# $: leghiamo le bande all'immagine completa
# col="red": colore del plot e in questo modo i punti sono rossi
# pch=19: point character e in questo modo i punti sono dei cerchietti pieni
# cex=2: aumentiamo la dimensione dei punti
plot(p224r63_2011$B1_sre,p224r63_2011$B2_sre, col="red", pch=19, cex=2) 
# Warning message: In .local(x, y, ...): plot used a sample of 2.2% of the cells. You can use "maxpixels" to increase the sample
# i pixel da plottare sono oltre 4 milioni, dunque il sistema ci dice che plotta solo il 2.2% di questo totale
# in statistica il sistema si chiama multicollinearità: le due bande sono molto correlate tra loro e sono correlate positivamente
# le info del punto sulla X sono molto simili alle info del punto sulla Y
# spesso questa forma di correlazione è usata in modo causale

# plottiamo di nuovo la stessa immagine ma con B2_sre -> asse X e B1_sre -> asse Y 
plot(p224r63_2011$B2_sre,p224r63_2011$B1_sre, col="red", pch=19, cex=2)

# funzione pairs: serve per plottare tutte le correlazione possibili tra tutte le variabili di un dataset
# mette in correlazione a due a due tutte le variabili di un certo dataset
pairs(p224r63_2011)
# sulla diagonale vediamo tutte le bande
# parte sottostante alla diagonale: grafico che mostra la correlazione tra le bande 
# parte sopra alla diagonale: indice di correlazione che varia tra -1 e 1
# ----------------------------------------------------------------------------------------------------------------------

# la PCA è un’analisi piuttosto impattante
# funzione aggregate: ricampioniamo il dato creando un dato più leggero 
# riduciamo la dimensione dell’immagine diminuendone la risoluzione e aumentando la dimensione dei pixel, lo facciamo per tutte e 7 le bande
# fattore 10 lineare: aggreghiamo i pixel del dato iniziale di 10 volte per ottenere un dato con una risoluzione più bassa
# associamo l'oggetto p224r63_2011res (resampled) al risultato della funzione
p224r63_2011res <- aggregate(p224r63_2011, fact=10)
p224r63_2011res 
# class: RasterBrick 
# dimensions: 150, 297, 44550, 7  (nrow, ncol, ncell, nlayers)
# resolution: 300, 300  (x, y)  -> la risoluzione iniziale è diminuita, ora è di 300 m (30x10)

# per vedere la diminuzione della risoluzione nel nuovo dato facciamo un parmfrow
# 2 righe e 1 colonna
# plottiamo con plotRGB le due immagini a diversa risoluzione
# banda NIR (4) sulla componente red, banda rossa (3) sulla componente green, banda verde (2) sulla componente blue
par(mfrow=c(2,1))
plotRGB(p224r63_2011, r=4, g=3, b=2, stretch="Lin")
plotRGB(p224r63_2011res, r=4, g=3, b=2, stretch="Lin")
# immagine sopra: immagine dettagliata con risoluzione 30mx30m di pixel
# immagine sotto: immagine molto sgranata con risoluzione 300mx300m di pixel 

# facciamo la PCA della nuova immagine a minor risoluzione (p224r63_2011res) 
# funzione rasterPCA - Principal Component Analysis for Rasters: prende il pacchetto di dati e va a compattarli in un numero minore di bande
# associamo l'oggetto p224r63_2011res_pca al risultato della funzione
p224r63_2011res_pca <- rasterPCA(p224r63_2011res)
# --------------------

# la funzione rasterPCA ci restituisce in uscita un’immagine che contiene la mappa e il modello
# vogliamo visualizzare le informazioni solo del modello: leghiamo l’immagine totale (p224r63_2011res_pca) con il suo modello (model)
# vogliamo sapere qual è la variabilità spiegata dalle componenti principali del nostro sistema
# funzione summaries: ci da un sommario del modello
summary(p224r63_2011res_pca$model)
# Importance of components:
#                           Comp.1      Comp.2       Comp.3       Comp.4
# Standard deviation     1.2050671  0.046154880   0.0151509526  4.575220e-03
# Proportion of Variance 0.9983595  0.001464535   0.0001578136  1.439092e-05
# Cumulative Proportion  0.9983595  0.999824022   0.9999818357  9.999962e-01
#                              Comp.5       Comp.6       Comp.7
# Standard deviation     1.841357e-03   1.233375e-03  7.595368e-04
# Proportion of Variance 2.330990e-06   1.045814e-06  3.966086e-07
# Cumulative Proportion  9.999986e-01   9.999996e-01  1.000000e+00

# Proportion of Variance: ci dice che la PC1 spiega il 99,835% della varianza
# Cumulative Proportion: ci dice che con le prime 3 componenti (PC1-PC2-PC3) si spiega il 99,998% di variabilità quindi bastano le prime 3 componenti

# facciamo il plot dell'immagine_res_pca legata alla sua mappa: $map
plot(p224r63_2011res_pca$map)
# ci mostra tutte le 7 componenti principali e le variabilità che spiegano
# PC1: spiega praticamente tutta la variabilità, dunque si vede bene la foresta, la parte agricola, i tagli dentro la foresta ecc
# PC7: non si distingue più niente perchè spiega la minore variabilità del sistema
# ----------------------------

# scriviamo il nome dell'immagine_res_pca per vedere le informazioni che contiene
p224r63_2011res_pca
# $call -> ci dice qual è la funzione che abbiamo usato 
# rasterPCA(img = p224r63_2011res)

# $model -> ci da le informazioni sulle componenti principali e la variabilità che spiegano 
# Call:
# princomp(cor = spca, covmat = covMat[[1]])
# Standard deviations:
#       Comp.1       Comp.2       Comp.3       Comp.4       Comp.5       Comp.6       Comp.7 
# 1.2050671158 0.0461548804 0.0151509526 0.0045752199 0.0018413569 0.0012333745 0.0007595368    
# 7  variables and  44550 observations.

# $map -> ci da le informazioni relative alla mappa 
# class: RasterBrick 
# dimensions: 150, 297, 44550, 7  (nrow, ncol, ncell, nlayers)
# resolution: 300, 300  (x, y)
# extent: 579765, 668865, -522735, -477735  (xmin, xmax, ymin, ymax)
# crs: +proj=utm +zone=22 +datum=WGS84 +units=m +no_defs 
# source: memory
# names: PC1,         PC2,         PC3,         PC4,         PC5,         PC6,         PC7 
# min values: -1.96808589, -0.30213565, -0.07212294, -0.02976086, -0.02695825, -0.01712903, -0.00744772 
# max values: 6.065265723, 0.142898435, 0.114509984, 0.056825372, 0.008628344, 0.010537396, 0.005594299 

# attr(,"class")
# [1] "rasterPCA" "RStoolbox"
# ----------------------------------------

# plottiamo in RGB le prime 3 componenti principali (PC1 - PC2 - PC3) 
# l'immagine è p224r63_2011res_pca
# plottiamo questa immagine insieme alla sua mappa: $map
# montiamo la PC1 sulla componente red, la PC2 sulla componente green, la PC3 sulla componente blue
# stretch lineare
plotRGB(p224r63_2011res_pca$map, r=1, g=2, b=3, stretch="Lin")
# i colori sono legati alle 3 componenti quindi a livello di colori non abbiamo modo di intuire nulla e non ci danno informazioni
# questa è un'immagine risultante da una analisi delle componenti principali
