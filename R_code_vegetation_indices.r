# R_code_vegetation_indices.r

# librerie e working directory: 
library(raster)
setwd("C:/lab/") 

# funzione brick: importiamo le due immagini dentro R
defor1 <- brick("defor1.jpg")
defor2 <- brick("defor2.jpg")
# b1 = NIR; b2 = red; b3 = green 

# parmfrow 
# plotRGB
par(mfrow=c(2,1))
plotRGB(defor1, r=1, g=2, b=3, stretch="Lin")
plotRGB(defor2, r=1, g=2, b=3, stretch="Lin")
