# R_code_knitr.r

# settiamo la working directory
setwd("C:/lab/")

# richiamiamo tutte le library necessarie
library (raster)
library (rasterVis)
# pacchetto knitr: può utilizzare un codice esterno (code.r) per creare un report
install.packages("knitr") 
library(knitr)
# installare un altro pezzo di R per creare il report
install.packages("tinytex")
library(tinytex)

# prendiamo la repository sulla Groenlandia: la copiamo e la incolliamo sul blocco note
# salviamo il blocco note (file di testo) nella cartella lab con il nome: R-code-Greenland.r
# cambiamo l'estensione da .txt a .r
# usiamo il pacchetto knitr che utilizza il codice appena salvato nella cartella lab, lo carica dentro a R e poi genera il report

# funzione stitch: crea automaticamente un REPORT basato su uno script di R
# primo argomento: nome del codice che abbiamo salvato nella cartella lab tra "" -> "R-code-Greenland.r"
# "misc": il tipo di template all'interno di knitr
# "knit-template.Rnw": il file di riferimento 
# "knitr": il pacchetto che si utilizza 
stitch("R-code-Greenland.r", template=system.file("misc","knitr-template.Rnw", package="knitr"))

# 2 azioni per risolvere il problema latex 
# Error: LaTex to compile R-code-Greenland.tex
tinytex::install_tinytex()
tinytex::tlmgr_update()
