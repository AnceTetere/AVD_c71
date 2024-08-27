f <- data.frame()

for (i in 1:length(SMUD_subTables)) {
  f <- rbind(f, get(SMUD_subTables[i]))
  rm(list = SMUD_subTables[i])
}
rm(i, aile, pil_vec, reg_vec, SMUD_subTables)

f <- f[match(rindas2, f$rindas), ]
name <- paste0("final_", year, "Q", Q)
assign(name, f)
save(list = name, file = paste0(d, name, ".RData"))
rm(list = name)

additional_AVD_c71 <- f
save(additional_AVD_c71, file = paste0(paste0(d, "2_additional_AVD_c71.RData")))
rm(f)

load(paste0(d, "1_initial_AVD_c71.RData"))
f <- rbind(initial_AVD_c71, additional_AVD_c71)
f <- f[match(rindas,f$rindas), ]
f$rindas <- NULL
rownames(f) <- NULL
final_AVD_c71 <- f
rm(f, initial_AVD_c71, additional_AVD_c71, rindas, rindas2)

save(final_AVD_c71, file = paste0(d, "3_final_AVD_c71.RData"))
write.table(final_AVD_c71, paste0(path, "final_AVD_c71.csv"), sep = ";", col.names = TRUE, row.names = FALSE, qmethod = "double")

rm(final_AVD_c71, base_path, name, path, Q, year, "rename_dataframes", d)
