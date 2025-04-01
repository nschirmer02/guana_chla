##Loading Chl data from Rproj 
chl_dat <- read.csv(here::here("data", "guana_chl.csv"))

View(chl_dat)

#Scatter plot of relationship between Uncorrected Extracted CHLa and In situ CHLa 
plot(x = chl_dat$CHL, y = chl_dat$CHLa_UnC, main = "Scatterplot")

#Scatter plot of relationship between corrected extracted CHLa and in situ CHLa
plot(x = chl_dat$CHL, y = chl_dat$CHLa_C, main = "Scatterplot")

#normality tests
qqnorm(chl_dat$CHL)
qqline(chl_dat$CHL)

qqnorm(chl_dat$CHLa_C)
qqline(chl_dat$CHLa_C)

qqnorm(chl_dat$CHLa_UnC)
qqline(chl_dat$CHLa_UnC)
#Definitely not normal 

#Testing skewness
parameters::skewness(chl_dat$CHLa_UnC)


