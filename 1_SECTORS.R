#Iztrādā šablonu un apakštabulas

#1 Datubāzes fails
AVD_c71 <- read.csv2(paste0(base_path, "datubazes_fails/AVD_c71.csv"))
initT <- AVD_c71
rm(AVD_c71)

initT$rindas <- paste0(initT$T, initT$S, initT$A)
rindas1 <- initT$rindas

d <- paste0(path, "intermediate_tables/")
if(!dir.exists(path)) {dir.create(path)}
if(!dir.exists(d)) {dir.create(d)}
saveRDS(rindas1, file = paste0(d, "rindas1.RDS"))

initT$EMPL_FTU[is.na(initT$EMPL_FTU)] <- ""
initT$EMPL_FTU_X[is.na(initT$EMPL_FTU_X)] <- ""

initial_AVD_c71 <- initT
save(initial_AVD_c71, file = paste0(d, "1_initial_AVD_c71.RData"))
rm(initial_AVD_c71)
#

cet <- ifelse(Q == "1", 
              paste0(as.numeric(year) - 1, "Q4"), 
              paste0(year, "Q", as.numeric(Q)-1))

c <- initT[initT$TIME == cet, ]
rm(initT, cet)

new_cet <- paste0(year, "Q", Q)
c$TIME <- new_cet
rm(new_cet)

rownames(c) <- NULL
c$rindas <- paste0(c$T, c$S, c$A)
rindas2 <- c$rindas
saveRDS(rindas2, file = paste0(d, "rindas2.RDS"))

rindas <- append(rindas1, rindas2)
saveRDS(rindas, file = paste0(d, "rindas.RDS"))
rm(rindas1)

c$EMPL_FTU <- ""
c$S <- factor(c$S)
levels(c$S)

template_name <- paste0("template_AVD_c71_", year, "Q", Q)
assign(template_name, c)
save(list = template_name, file = paste0(d, template_name, ".RData"))
rm(list = template_name, template_name)

# Split the data frame into a list of data frames by factor levels
c <- split(c, c$S)
list2env(c, envir = .GlobalEnv)

GEGOV_S <- `GEGOV-S`
GEGOV_S_ST <- `GEGOV-S_ST`
GEGOV_S_L_GOV <- `GEGOV-S_L_GOV`
PRIVs <- `PRIV-S`
PUBs <- `PUB-S`
rm(`PUB-S`, c,  `PRIV-S`, `GEGOV-S`, `GEGOV-S_ST`, `GEGOV-S_L_GOV`)

subSS <- readRDS(paste0(base_path, "R_kods/templates/subSS.RDS"))

for (i in 1:length(subSS)) {
  df <- get(subSS[i])
  rownames(df) <- NULL
  assign(subSS[i], df)
  save(list = subSS[i], file = paste0(d, subSS[i], "_", year, "Q", Q, ".RData"))
  rm(df)
}
rm(i)

reg_vec <- readRDS(paste0(base_path, "R_kods/templates/regi.RDS"))
pil_vec <- readRDS(paste0(base_path, "R_kods/templates/pili.RDS"))
