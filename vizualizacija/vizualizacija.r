# 3. faza: Vizualizacija podatkov
library(knitr)
library(rvest)
library(gsubfn)
library(tidyr)
library(tmap)
library(shiny)
library(rgdal)
library(rgeos)
library(dplyr)
library(readr)
library(ggplot2)
library(digest)
library(mosaic)

#USTVARJANJE NOVIH TABEL

#tabela ki poodatke za vse kroge komulativno sesteje
kom_tabela <- krogi5 %>% group_by(ime,priimek,stat_podatek) %>% summarise(vrednost=sum(vrednost))

#tabela s stevilom povprečnih celotnih tekem, ki jih je igralec odigral
odigranih_90 <- filter(kom_tabela, stat_podatek == "minutes") %>% summarise(st_90 = round(vrednost/90, digits=2))


#kom_tabela_vec_kot_90 <- kom_tabela %>% filter(stat_podatek == "minutes")
#povp_90 <- kom_tabela %>% 
#  group_by(ime,priimek,stat_podatek) %>% summarise(vrednost=vrednost/stat_podatek["minutes"]/90)
#salah <- filter(kom_tabela, priimek == "Salah")
#odigrane_min <- kom_tabela %>% filter(stat_podatek = minutes) %>% group_by(ime, priimek, stat_podatek) %>% summarise(vrednost=vrednost)


# # Uvozimo zemljevid.
# zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip", "OB",
#                              pot.zemljevida="OB", encoding="Windows-1250")
# levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
#   { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
# zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels=levels(obcine$obcina))
# 
# # Izračunamo povprečno velikost družine
# povprecja <- druzine %>% group_by(obcina) %>%
#   summarise(povprecje=sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
