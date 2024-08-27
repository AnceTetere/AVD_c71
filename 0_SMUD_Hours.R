base_path <- "C:/Users/../AVD_c71/"
year <- readline(prompt = "Ievadīt gadu: ")
Q <- readline(prompt = "Ievadīt ceturksni: ")
path <- paste0(base_path, year, "Q", Q, "/")

library(XLConnect)
tab_name <- paste0("HOURS_", substr(year, 3, 4), "c", Q)
wb <- loadWorkbook(paste0("F:/DP/../SVD_c10/", year, "Q", Q, "/", tab_name, ".xlsx"))
ws <- readWorksheet(wb, sheet = 1)                   
x <- ws
detach("package:XLConnect", unload = TRUE)
rm(tab_name, wb, ws)

x$NSV <- factor(x$NSV)
levels(x$NSV)
