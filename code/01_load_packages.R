##If pacman package not installed uncomment and run below code
#install.packages("pacman")

##Run code below to install/load the following packages: 
#here: easily load files stored within the Rproj without having to dictate directories
#dplyr: streamlining data manipulation using pipes and simple functions
#tidyverse:
#openxlsx: simple reading and editing of excel workbooks, especially helpful with multitple sheets
pacman::p_load(here, tidyverse, dplyr, openxlsx, parameters, COR)
