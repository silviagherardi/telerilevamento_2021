# Il mio primo codice in R per il telerilevamento!
install.packages(“raster”)
library(raster) 

setwd("C:/lab/") # percorso per Windows

p224r63_2011 <- brick("p224r63_2011_masked.grd")
p224r63_2011

plot(p224r63_2011)
