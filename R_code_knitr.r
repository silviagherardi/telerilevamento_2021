# R_code_knitr.r

# settiamo la working directory
setwd("C:/lab/")

# richiamiamo tutte le library
# pacchetto knitr: può utilizzare un codice esterno (code.r) per creare un report
install.packages("knitr") 
library(knitr)
library (raster)
library (rasterVis)
# installare un altro pezzo di R per creare il report
install.packages("tinytex")
library(tinytex)

# prendiamo la repository su Greenland - copia e incolla sul blocco note
# salvare il file (blocco note) nella cartella lab con il nome: R-code-Greenland.r
# dunque cambiamo l'estensione da .txt a .r
# funzione stitch
# primo argomento: nome del nostro codice tra "" (R-code-Greenland.r) 
stitch("R-code-Greenland.r", template=system.file("misc","knitr-template.Rnw", package="knitr"))

# 2 azioni per risolvere il problema latex 
# Errore: LaTex to compile R-code-Greenland.tex. 
tinytex::install_tinytex()
tinytex::tlmgr_update()
