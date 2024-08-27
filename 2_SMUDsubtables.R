s <- x
s <- s[s$NOZ2 == "0", ]
rm(x)

aile <- paste0("G", Q)
s <- s[,c("SV", "DAT", "nT", "RAJ", "Nos", aile)]
rownames(s) <- NULL

source(paste0(base_path, "R_kods/fnc_rename_dataframes.R"))

s$SV <- factor(s$SV)
s_split <- split(s, s$SV)
s_split <- rename_dataframes(s_split, "k")
list2env(s_split, envir = .GlobalEnv)
if(exists("k_025")){rm(k_025)}

k_SMUD <- c("k_001", "k_023", "k_024", "k_050", "k_058", "k_083")
SMUD_subTables <- vector()

for(i in 1:length(subS)) {
a <- get(subS[i])
b <- get(k_SMUD[i])
mT <- paste0(subS[i], substr(k_SMUD[i], 2, 5))
#Kodi atšķiras, tāpēc pirms sapludināšanas vajag tos pārveidot.
b$RAJ[b$RAJ %in% substr(pil_vec, 1, nchar(pil_vec)-2)] <-
  paste0(b$RAJ[b$RAJ %in% substr(pil_vec, 1, nchar(pil_vec)-2)], "00")

#Dubultniekus izņem sapludināšanas procesā.
if(sum(unique(b$RAJ) %in% a$A) == 53) {
  M <- merge(a, b[!duplicated(b$RAJ), c("RAJ", aile)], by.x = "A", by.y = "RAJ", all.x = TRUE)
} else {
  stop("Vērtības A ailē tabulā ", subS[i], " nesakrīt ar vērtībām RAJ ailē tabulā ", k_SMUD[i])
}

M$EMPL_FTU <- M[ ,aile]
M <- M[,colnames(a)]

assign(mT, M)
SMUD_subTables <- append(SMUD_subTables, mT)
rm(list = c(subS[i], k_SMUD[i]), a, b, mT, M)
}

rm(k_SMUD, subS, s, s_split, i)

#SMUD_subTables <- c("TOTAL_001", "PUBs_023", "PRIVs_024", "GEGOV_S_050", "GEGOV_S_ST_058", "GEGOV_S_L_GOV_083")

for (i in 1:length(SMUD_subTables)) {
save(list = SMUD_subTables[i], 
     file = paste0(d, "k", substr(SMUD_subTables[i], nchar(SMUD_subTables[i])-2, nchar(SMUD_subTables[i])), "_", substr(SMUD_subTables[i], 1, nchar(SMUD_subTables[i])-4), "_", year, "Q", Q, ".RData"))
  #rm(list = subS[i])
}
rm(i)
