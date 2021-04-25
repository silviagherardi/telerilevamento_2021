# R_code_classification.r

# settiamo la working directory
setwd("C:/lab/")
# impostiamo le librerie che ci servono
library(raster)
library(RStoolbox) 

# 
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
# vediamo le informazioni relative alle 3 bande
so
# values: da 0 a 255 → immagini a 8 bit → 28 = 256 valori 

# visualizziamo i livelli RGB
# funzione plotRGB: ci serve per visualizzare i 3 livelli dell'immagine
plotRGB(so, 1, 2, 3, stretch="Lin")

# classifichiamo l'immagine - classificazione non supervisionata
# 

library(RStoolbox)

# funzione unsupervised classification: dentro al pacchetto RStoolbox, si occupa della classificazione non supervisionata
# so: inserimento dell'immagine 
# ci serve il numero di classi: nClasses=3
# soc: associamo un oggetto al risultato della funzione e lo chiamiamo soc (solar orbiter classified) 
soc <- unsuperClass(so, nClasses=3)

# funzione plot per visualizzare l'oggetto soc
#
# 
# 
plot(soc$map)

# funzione set.seed: 
set.seed(42)

# esercitazione: Unsupervised Classification with 20 classes
set.seed(42)
soc20 <- unsuperClass(so, nClasses=20)
plot(soc20$map)

# Download an image from: https://www.esa.int/ESA_Multimedia/Missions/Solar_Orbiter/(result_type)/images
sun <- brick("sun.png")
# classificazione dell'immaigne sun - Unsupervised classification
# 3 classi 
set.seed(42)
sunc <- unsuperClass(sun, nClasses=3)
plot(sunc$map)
# -----------------------------------------------------------------------------------------------------------------------------

# Grand Canyon 
# https://landsat.visibleearth.nasa.gov/view.php?id=80948

# richiamare le librerie
library(raster)
library(RStoolbox) # indispensabile per la classificazione e l'analisi multivariata
# settare la working directory
setwd("C:/lab/") 

# carichiamo l’immagine che è un RGB: formata da 3 livelli
# funzione brick: per IMPORTARE tutti e 3 i livelli e creare la classe raster brick 
# oggetto gc associato al risultato della funzione
gc <- brick("dolansprings_oli_2013088_canyon_lrg.jpg")

# visualizzare l'immagine RGB
# funzione plotRGB: oggetto raster brick e con la funzione lo plottiamo 
# x: oggetto dell'immagine (gc)
# red = 1 (banda 1 sul rosso); green = 2 (banda 2 sul verde); blue = 3 (banda 3 sul blu)
# stretch lineare: per aumentare la potenza visiva di tutti i colori possibili
plotRGB(gc, r=1, g=2, b=3, stretch="Lin")

# histogram stretch
plotRGB(gc, r=1, g=2, b=3, stretch="hist")

# Grand Canyon classified 2
# n. classi = 2
gcc2 <- unsuperClass(gc, nClasses=2)
gcc2
# *************** Map ******************
# class: RasterLayer
# dimensions: 6222, 9334, 58.076.148 (nrow, ncol, ncell)
# resolution : 1, 1 (x, y)
# extent: 0, 9334, 0, 6222 (xmin, xmax, ymin, ymax)
# crs: NA
# source: 
# names: layer
# values: 1, 2 (min, max)

# plottiamo la mappa di gcc2
# $: legare la mappa all’immagine intera
plot(gcc2$map)
# vediamo le due classi e possiamo fare un confronto con l'immagine originale
# discriminazione più alta è nella zona centrale
# tipo di roccia e composizione mineralogico molto caratteristica

# Grand Canyon classified 4
# n.classi = 4
gcc4 <- unsuperClass(gc, nClasses=4)
gcc4
# *************** Map ******************
# class: RasterLayer 
# dimensions: 6222, 9334, 58076148  (nrow, ncol, ncell)
# resolution: 1, 1  (x, y)
# extent: 0, 9334, 0, 6222  (xmin, xmax, ymin, ymax)
# crs: NA 
# source: 
# names: layer 
# values: 1, 4  (min, max)

# plottiamo la mappa di gcc4
# $: legare la mappa all’immagine intera
plot(gcc4$map)
# vediamo una differenziazione più alta
# rilevamento: si va a terra per vedere quanto l'immagine può essere utilizzabile, quanto le classi individuate sono veritiere a terra
# abbiamo usato solo le bande red-green-blue, se avessimo usato anche la banda dell'infrarosso vicino l'acqua sarebbe stata inserita in una classe a sè
