# R_code_classification.r

# settiamo la working directory
setwd("C:/lab/")

# impostiamo le librerie che ci servono
library(raster)
# library(RStoolbox) 

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



















