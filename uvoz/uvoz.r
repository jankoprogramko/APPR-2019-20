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

#UVOZ TABELE VSEH PODATKOV
#data1 <- read.csv("players_raw.csv")
data1 <- read_csv("podatki/players_raw.csv", locale=locale(encoding="UTF-8"))

#izločevanje nepomembnih podatkov

#pomožen vektor z imeni ekip
ekipe <- c("ARS", "BOU", "BRI", "BUR", "CAR", "CHE", "CRY", "EVE", "FUL", "HUD", "LEI", "LIV", "MCI", "MUN", "NEW", "SOU", "SPU", "WAT", "WSH", "WOL")


igralci_skupaj <- data1[c(19, 42, 47)] %>% mutate(team = ekipe[team])



#UVOZ PODATKOV ZA VSAK KROG POSEBEJ
#data2 <- read.csv("merged_gw.csv")
data2 <- read_csv("podatki/merged_gw.csv", locale=locale(encoding="Windows-1252"),
                  col_types=cols("was_home"=col_logical()))


#izlocevanje nepomembnih podatkov
krogi <-data2[c(-6, -7, -11, -13, -14, -17, -21, -22, -23, -25, -26, -27, -28, -41, -47, -48, -49, -50, -51, -52, -56)]

#locevanje stolpca name na tri različne stolpce
krogi2 <- separate(krogi,1, c("ime", "priimek", "id"), "_")

#izločitev stolpca z imenom id, sprememba stolpca opponent team
krogi3 <- krogi2[-3] %>% mutate(opponent_team = ekipe[opponent_team])

#sprememba stolpca opponent team
#krogi4 = krogi3 %>% mutate(opponent_team = ekipe[opponent_team])

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
