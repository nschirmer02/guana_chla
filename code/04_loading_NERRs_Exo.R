files <- list.files(here::here("data", "reserve-chla-data"))
setwd(here::here("data", "reserve-chl-data"))
getwd()
for (i in files) {
  dat <- xlsx::read.xlsx(here::here("data", "reserve-chla-data", i), 1)
  
  xlsx::write.xlsx(dat, here::here("data", substr(i, start = nchar(i) - 9, stop = nchar(i))))
  print(substr(i, start = nchar(i) - 9, stop = nchar(i)))
}

dat <- xlsx::read.xlsx(here::here("data", "reserve-chla-data", "chla_2.1_hee.xlsx"), 1)

substr(files )