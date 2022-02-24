library(data.table)

#set working directory. Change Station ID/file name as necessary
dir_add <- "C:/Users/Maria/Documents/AAFC/get_weather/"
file_name <- "Maple Plains/Hourly"
setwd(paste(dir_add, file_name, sep=""))

#read EC csv weather file
dat <- read.csv(file = "compiled_data_MP.txt", header=TRUE, sep=";")

#~~~~~~~~~~~FORMAT csv file~~~~~~~~~~~~~~~~~~~~~~~~~~~
#select station name, date, month, day, time, RH, windspeed
dat_2 <- subset(dat, select = c(3, 5, 6, 7, 8, 14,20))

#remove months not in season (season = may - oct)
weather_data <- dat_2[!(dat_2$Month==1 | dat_2$Month==2 | dat_2$Month==3 | dat_2$Month==4 | dat_2$Month==11 | dat_2$Month==12),]

#save file
write.csv(weather_data, file="hourly_weather_data.csv")


#~~~~~~~~~~~~~~FIND MISSING DATA~~~~~~~~~~~~~~~~~~~~~~

#check how many individual missing data points and how many missing in a row
#total missing data points
missing_data_RH <- sum(is.na(weather_data$Rel.Hum....))
missing_data_WS <- sum(is.na(weather_data$Wind.Spd..km.h.))


#find ranges of missing data

#format table
missing_data <- data.frame('Day'= character(),'Percent Missing RH Data'=integer(), 'Day'=character(), 'Precent Missing WS'=integer())

get_missing = function(datacol,col_1,col_2) {
  #Find missing data in each day. 
  #datacol = column of desired data to parse
  #co1_1, col_2 = columns to write values to. 1,2 for RH. 3,4 for WS.
  
  missing_data_count <- 0 #number of NAs
  cur_date <- weather_data$Date.Time..LST.[1] #current day. Starts at value in first row of data table.
  j <- 0 # counter for retrieving date at row in for loop
  hr_counter <- 24 
  
  for (i in datacol){
    sprintf("i is %s",i)
    if (!(hr_counter==0)){
      hr_counter <- hr_counter - 1
      sprintf("hr count is %s", hr_counter)
    } else {
      #write to missing_data_table
      missing_data[j,col_1] <- cur_date
      missing_data[j,col_2] <- (missing_data_count/24)*100
      #reset current date, counters
      print(cur_date)
      print(missing_data[j,col_2])
      cur_date <- weather_data$Date.Time..LST.[j]
      missing_data_count <- 0
      hr_counter <- 24
    }
    if (is.na(i)){
      missing_data_count <- missing_data_count + 1
      sprintf("missing data = %s", missing_data_count)
    }
  }
}

#get_missing(weather_data$Rel.Hum....,1,2)
#get_missing(weather_data$Wind.Spd..km.h.,3,4)

#determine daily missing data for RH
missing_data_count <- 0 #number of NAs
cur_date <- weather_data$Date.Time..LST.[1] #current day. Starts at value in first row of data table.
j <- 1 # counter for retrieving date at row in for loop
k <- 1 #row in missing_data table
hr_counter <- 24 

for (i in weather_data$Wind.Spd..km.h.){
  if (!(hr_counter==0)){
    hr_counter <- hr_counter - 1
  } else {
    #write to missing_data_table
    missing_data[k,3] <- cur_date
    missing_data[k,4] <- (missing_data_count/24)*100
    k <- k + 1
    #reset current date, counters
    cur_date <- weather_data$Date.Time..LST.[j]
    missing_data_count <- 0
    hr_counter <- 23
  }
  if (is.na(i)){
    missing_data_count <- missing_data_count + 1
  }
  j <- j + 1
}

missing_data[nrow(missing_data)+1,1] <- "% Total Missing"
missing_data[nrow(missing_data),2] <- missing_data_RH/nrow(weather_data)*100
missing_data[nrow(missing_data),3] <- "% Total Missing"
missing_data[nrow(missing_data),4] <- missing_data_WS/nrow(weather_data)*100

#write to file
file_name <- paste("missing_data_",weather_data$Station.Name[1],".csv", sep="")
write.csv(missing_data, file=file_name)