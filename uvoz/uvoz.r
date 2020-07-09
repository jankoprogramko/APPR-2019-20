# 2. faza: Uvoz podatkov
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
library(reshape2)

#uvoz tabele vseh igralcev, vsi statisticni podatki skupaj
data1 <- read.csv("players_raw.csv")
#izločevanje nepomembnih podatkov
igralci_skupaj <- data1[c(19, 42, 47, 31, 22, 1, 6, 21, 41, 58, 40, 36, 37 )]
igralci_skupaj2 = igralci_skupaj %>% mutate(team = ekipe[team])
#vektor z imeni ekip
ekipe <- c("ARS", "BOU", "BRI", "BUR", "CAR", "CHE", "CRY", "EVE", "FUL", "HUD", "LEI", "LIV", "MCI", "MUN", "NEW", "SOU", "SPU", "WAT", "WSH", "WOL")



#uvoz podatkov za igralce, statisticni podatki loceni po krogih
data2 <- read.csv("merged_gw.csv")
#izlocevanje nepomembnih podatkov
krogi <-data2[c(-6, -7, -11, -13, -14, -17, -21, -22, -23, -25, -26, -27, -28, -41, -47, -48, -49, -50, -51, -52, -56)]
#locevanje stolpca name na tri različne stolpce
krogi2 <- separate(krogi,1, c("ime", "priimek", "id"), "_")
#izločitev stolpca z imenom id
krogi3 <- krogi2[-3]
#sprememba stolpca opponent team
krogi4 = krogi3 %>% mutate(opponent_team = ekipe[opponent_team])
#pretvorba v tidy data
krogi5 <- melt(krogi4, id.vars = c("ime","priimek","round","opponent_team","was_home"), measure.vars = names(krogi3)[c(-1,-2,-20,-27,-34)], variable.name = "stat_podatek", value.name = "vrednost")


#,locale=locale(encoding="UTF-8")
# library(reshape2)
# library(dplyr)
# library(readr)
# library(tidyr)
# data <- read_csv("https://raw.githubusercontent.com/H-Cox/FPL/master/alldata.csv")
# 
# igralci <- data[, 1:60]
# igralci2 <- igralci[c(3, 5, 40:50)]
# krogi <- data[c(3, 61:ncol(data))] %>% melt(id.vars="web_name") %>%
#   separate("variable", c("krog", "podatek"), ": ") %>%             
#   mutate(krog=parse_number(krog))

# sl <- locale("sl", decimal_mark=",", grouping_mark=".")
# 
# # Funkcija, ki uvozi občine iz Wikipedije
# uvozi.obcine <- function() {
#   link <- "http://sl.wikipedia.org/wiki/Seznam_ob%C4%8Din_v_Sloveniji"
#   stran <- html_session(link) %>% read_html()
#   tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
#     .[[1]] %>% html_table(dec=",")
#   for (i in 1:ncol(tabela)) {
#     if (is.character(tabela[[i]])) {
#       Encoding(tabela[[i]]) <- "UTF-8"
#     }
#   }
#   colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
#                         "ustanovitev", "pokrajina", "regija", "odcepitev")
#   tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
#   tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
#   tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
#   for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
#     if (is.character(tabela[[col]])) {
#       tabela[[col]] <- parse_number(tabela[[col]], na="-", locale=sl)
#     }
#   }
#   for (col in c("obcina", "pokrajina", "regija")) {
#     tabela[[col]] <- factor(tabela[[col]])
#   }
#   return(tabela)
# }
# 
# # Funkcija, ki uvozi podatke iz datoteke druzine.csv
# uvozi.druzine <- function(obcine) {
#   data <- read_csv2("podatki/druzine.csv", col_names=c("obcina", 1:4),
#                     locale=locale(encoding="Windows-1250"))
#   data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
#     strapplyc("([^ ]+)") %>% sapply(paste, collapse=" ") %>% unlist()
#   data$obcina[data$obcina == "Sveti Jurij"] <- iconv("Sveti Jurij ob Ščavnici", to="UTF-8")
#   data <- data %>% gather(`1`:`4`, key="velikost.druzine", value="stevilo.druzin")
#   data$velikost.druzine <- parse_number(data$velikost.druzine)
#   data$obcina <- parse_factor(data$obcina, levels=obcine)
#   return(data)
# }
# 
# # Zapišimo podatke v razpredelnico obcine
# obcine <- uvozi.obcine()
# 
# # Zapišimo podatke v razpredelnico druzine.
# druzine <- uvozi.druzine(levels(obcine$obcina))
# 
# # Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# # potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# # datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# # 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# # fazah.
