options(digits = 15)
##Merging all sheets in the Guana Masterdata excel file so that all years are together
#generating a list of all sheet names
merged <- openxlsx::read.xlsx("C:/Users/schirmer_n/Documents/Data/Guana_data/Guana_MASTERDATA_merged_NS.xlsx", 1)
#creating an empty data frame to bind forloop outputs into
data <- data.frame()


##Formatting dates
#when importing dates they get converted to numerical or character strings that look like this: 45302.6486111111
#these excel dates must be converted to POSIXct class dates using the below code
#using convertToDateTime() requires excel dates be in numeric format
#EDT or EST automatically based on the date
merged1 <- merged %>% 
  mutate(
    SampleDate = openxlsx::convertToDateTime(SampleDate, origin = "1900-01-01"), 
    DateReceived = openxlsx::convertToDateTime(DateReceived, origin = "1900-01-01"), 
    DateAnalyzed = openxlsx::convertToDateTime(as.numeric(DateAnalyzed), origin = "1900-01-01")
  )

##Preparing data for regression
merged_chl <- merged1 %>% 
  
  #Filtering data to only include CHL values
  filter(ComponentShort %in% c("CHLa_C", "CHLa_UnC", "CHL", "WTEM", "SALT")) %>% 
  
  #Mutating Result column to convert values to numeric class
  mutate(Result = as.numeric(Result)) %>% 
 
  #Removing columns containing NA's 
  tidyr::drop_na(Result) %>% 
  
  #Pivoting wider to allow for easier graphical comparison
  tidyr::pivot_wider(
    names_from = ComponentShort, 
    values_from = Result
    ) %>% 
  
  #Merging the new columns into a single row paired with the right SampleDate and StationCode 
  select(SampleDate, StationCode, CHLa_C, CHLa_UnC, CHL, WTEM, SALT) %>% 

  group_by(SampleDate, StationCode) %>% 
  
  summarise(across(c("CHLa_C", "CHLa_UnC", "CHL", "SALT", "WTEM"), ~ sum(., na.rm = T)))  

#Changing the MDL values so they are 1/2 the MDL  
merged_chl1 <- filter(merged_chl, !CHL == 0, !CHLa_C == 0, !CHLa_UnC == 0)
merged_chl1$CHLa_C[merged_chl1$CHLa_C == 2.5] <- 1.25
merged_chl1$CHLa_UnC[merged_chl1$CHLa_UnC == 2.5] <- 1.25
merged_chl2 <- merged_chl1 %>% 
  tidyr::drop_na(CHLa_C, CHLa_UnC)

##Writing data into Rproj
write.csv(merged_chl2, file = here::here("data", "guana_chl.csv"))


