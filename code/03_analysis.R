##Loading Chl data from Rproj 
chl_dat <- read.csv(here::here("data", "guana_chl.csv"))

View(chl_dat)

##Messing with CHL data

#Splitting into two data frames

#One including only MDL values
MDL_dat <- chl_dat %>% 
  filter(CHLa_C == 1.25 & CHLa_UnC == 1.25)

arrange 
#No MDL values
rm_dat <- chl_dat %>% 
  filter(!CHLa_C == 1.25 & !CHLa_UnC == 1.25)  %>% 
  filter(!CHLa_C > 200 & !CHLa_UnC > 200)

#Linear Regression for corrected extracted CHLa and in situ
plot(x = rm_dat$CHLa_C, y = rm_dat$CHL, main = "scatterplot")
cormod <- lm(formula = rm_dat$CHL ~ rm_dat$CHLa_C)
summary(cormod)
abline(cormod)

#Linear Regression for uncorrected extracted CHLa and in situ
plot(x = rm_dat$CHLa_UnC, y = rm_dat$CHL, main = "scatterplot")
uncmod <- lm(formula = rm_dat$CHL ~ rm_dat$CHLa_UnC)
summary(uncmod)
abline(uncmod)

#variability between the values remains unaffected 
plot(x = rm_dat$CHL, y = rm_dat$cordiff, main = "scatterplot")
plot(x = rm_dat$CHL, y = rm_dat$uncdiff, main = "scatterplot")
plot(x = rm_dat$WTEM, y = rm_dat$uncdiff, main = "scatterplot")
plot(x = rm_dat$SALT, y = rm_dat$cordiff,  main = "scatterplot")

diffmod <- lm(formula = cordiff ~ WTEM, data = rm_dat)
abline(diffmod)

ggplot(rm_dat, aes(x = WTEM, y = cordiff, color = StationCode)) +
  geom_point() + 
  scale_color_brewer(type = "qua", palette = 3)


#Calculate the percent differences for each value in the data set
percent_diff <- function (x, y) {
  diff = x - y
  avg = (x + y)/2
  pct_diff = (diff/avg)*100
  return(pct_diff)
}

#Adding columns for percentage difference between the three CHL types
pct_rm_dat <- rm_dat %>% 
  mutate(
    cordiff = percent_diff(CHLa_C, CHL), 
    uncdiff = percent_diff(CHLa_UnC, CHL)
  ) %>% 
  group_by(StationCode) %>% 
  summarise(
    cordiff = mean(cordiff), 
    uncdiff = mean(uncdiff)
  )

#Cor test time 
cor_dat <- chl_dat[,4:8]
m <- cor(cor_dat, method = "spearman")
COR::corplot(m, method = circle)
corrplot::corrplot(m, method = "circle", order = "FPC", type = "lower", diag = F)
