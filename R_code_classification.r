# R_code_classification.r
# CLASSIFICAZIONE: processo che accorpa pixel con valori simili, una volta che questi pixel sono stati accorpati rappresentano una classe

# settiamo la working directory
setwd("C:/lab/")
# impostiamo le librerie che ci servono
library(raster)
library(RStoolbox) 

# funzione brick: inseriamo l'immagine RGB con 3 livelli (pacchetto di dati) 
# associamo l'oggetto so (solar orbiter) al risultato della funzione
so <- brick("Solar_Orbiter_s_first_views_of_the_Sun_pillars.jpg")
# vediamo le informazioni relative alle 3 bande
so
# calss: RasterBrick 
# values: 0 , 255 → immagine a 8 bit → 2^8 = 256 valori 

# visualizziamo i 3 livelli dell'immagine RGB
# funzione plotRGB: ci serve per visualizzare i 3 livelli dell'immagine RGB
# X = oggetto
# banda 1 sulla componenete red, banda 2 sulla componente green, banda 3 sulla componente blue
# stretch lineare
plotRGB(so, 1, 2, 3, stretch="Lin")
# vediamo diversi livelli energitici, da alti (colore acceso) a bassi (grigio/nero) 

# classifichiamo l'immagine per individuare le 3 classi
# classificazione non supervisionata: si lascia al software la possibilità di definire il training set sulla base delle riflettanze dei pixel
# training set: il software cattura pochi pixel all’interno dell’immagine per creare un set di controllo e poi si classifica l'intera immagine
# maximum likelihood: per ogni pixel si calcola la distanza nello spazio multispettrale, in base a questa si associa il pixel ad una determinata classe 
# per la classificazione serve la library(RStoolbox) -> libreria che contiene la funzione unsuperClass
# library(RStoolbox) 

# funzione unsuperClass: opera la classificazione non supervisionata (dentro al pacchetto RStoolbox) 
# so: inserimento dell'immagine 
# nClasses=3: numero di classi sulla base dell'immagine 
# associamo l'oggetto soc (solar orbiter classified) al risultato della funzione
soc <- unsuperClass(so, nClasses=3)

# funzione unsuperClass: ha creato l'immaigine classificata (soc) formata da più pezzi: modello + mappa 
# facciamo un plot dell'immagine classificata (soc) e in particolare della mappa
# $: leghiamo l'immagine classificata (soc) alla sua mappa (map)
plot(soc$map)
# 3 classi: classe 1: bianca; classe 2: gialla; classe 3: verde
# queste classi corrispondono ai diversi livelli di energia (alto - medio - basso)

# la mia mappa finale è diversa dalle altre -> i pixel selezionati in entrata per il training set sono diversi di volta in volta
# funzione set.seed: serve per fare una classificazione che sia sempre la stessa (usa sempre le stesse repliche per fare il modello) 
set.seed(42)

# esercitazione: Unsupervised Classification with 20 classes
set.seed(42)
soc20 <- unsuperClass(so, nClasses=20)
plot(soc20$map)

# esercitazione: download an image from: https://www.esa.int/ESA_Multimedia/Missions/Solar_Orbiter/(result_type)/images
# funzione brick: importiamo l'immagine dentro R
sun <- brick("sun.png")
# classificazione dell'immaigne sun - Unsupervised classification
# 3 classi 
set.seed(42)
sunc <- unsuperClass(sun, nClasses=3)
# plottiamo la mappa dell'immagine sun classificata 
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
# la discriminazione più alta è nella zona centrale
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
# abbiamo usato solo le bande red-green-blue, se avessimo usato anche la banda dell'infrarosso vicino, l'acqua sarebbe stata inserita in una classe a sè
# ------------------------------------------------------------------------------------------------------------------------------------------------------------
