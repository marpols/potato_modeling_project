## ---------------------------
##
## Script name: EC_Compile_Files.R
##
## Purpose of script: Compile daily or hourly EC weather data files into one single file.
##
## Author: René Morissette
##
## Date Created: 2020-08-20
##
## Copyright (c) René Morissette, 2020
## Email: rene.morissette2@canada.ca
##
## ---------------------------
##
## Notes:
##   
##
## ---------------------------

## set working directory and path to data

setwd("C:/Users/Maria/Documents/AAFC/get_weather")    # Rene's working directory (PC)

## ---------------------------

## set intitial parameters (uncomment as required)

# variable = TRUE

## ---------------------------

options(scipen = 6, digits = 4) # I prefer to view outputs in non-scientific notation
memory.limit(30000000)     # this is needed on some PCs to increase memory allowance, but has no impact on macs.

## ---------------------------

## load up the packages we will need:  (uncomment as required)

## ---------------------------

## load up our functions into memory

fun_compile = function(path) {
  list_files <- list.files(path, pattern=".csv",recursive = F)
  all_data <- NULL
  for (i in 1:length(list_files)){
    file_data<-read.csv(paste(path,list_files[i],sep="/"),header=T,sep=",",check.names = F)
    all_data <- rbind(all_data,file_data)
  }
  write.table(all_data,paste(path, "compiled_data.txt", sep="/"),sep=";",quote = F,col.names=T,row.names=F,na="NA") #écriture output
}

## ---------------------------

datadir = "Summerside CDA"
datapath =paste(getwd(),datadir,sep = "/")

fun_compile(datapath)
