#converts ECCC hourly data into daily average values#
#Mariaelisa Polsinelli for AAFC#

library(data.table)

#set working directory. Change Station ID/file name as necessary
dir_add <- "C:/Users/Maria/Documents/AAFC/get_weather/"
file_name <- "Maple Plains/Hourly"
setwd(paste(dir_add, file_name, sep=""))

#read EC csv weather file
dat <- read.csv(file = "compiled_data_MP.txt", header=TRUE, sep=";")

#~~~~~~~~~~~FORMAT csv file~~~~~~~~~~~~~~~~~~~~~~~~~~~
#select station name, date, month, day, time, RH, windspeed from ECCC data
dat_2 <- subset(dat, select = c(3, 5, 6, 7, 8, 14, 20))

#remove months not in season (season = may - oct)
weather_data <- dat_2[!(dat_2$Month==1 | dat_2$Month==2 | dat_2$Month==3 | dat_2$Month==4 | dat_2$Month==11 | dat_2$Month==12),]

#save file
write.csv(weather_data, file="hourly_weather_data.csv")

#----Calculate Daily Averages-------

#create table to store data, add columns as necessary
daily_avgs <- data.frame('Day'= character(),'Daily Avg. Relative Humidity (%)'=integer(), 'Daily Avg. Wind Speed (km/h)'=integer())

calculate_avgs = function(data_table, data_cols, output_table){
  #Calculate daily averages from hourly data
  #data_cols = data vector of column numbers to be processed, in same order as will be inserted into daily_avgs table
  
  cur_date <- weather_data$Date.Time..LST.[1] #current day. Starts at value in first row of data table.
  j <- 1 # counter for retrieving date at row in for loop
  k <- 1 #row in daily_avgs table
  hr_counter <- 24 
  
  #insert dates
  for (i in weather_data$Date.Time..LST.){
    if (!(hr_counter==0)){
      hr_counter <- hr_counter - 1
    } else {
      #write to table
      output_table[k,1] <- cur_date
      k <- k + 1
      #reset current date, counters
      cur_date <- i
      hr_counter <- 23
    }
    j <- j + 1
  }
  
  write_col <- 2
  
  for (c in data_cols){
  #reset values
  daily_sum <- 0 #sum of hourly data
  denom <- 0 #denomenator for avg calc
  j <- 1 # counter for retrieving date at row in for loop
  k <- 1 #row in daily_avgs table
  hr_counter <- 24 
  
    for (i in data_table[,c]){
      if (!(hr_counter==0)){
        hr_counter <- hr_counter - 1
      } else {
        #write to table
        output_table[k,write_col] <- daily_sum/denom
        k <- k + 1
        #reset counters
        daily_sum <- 0
        denom <- 0
        hr_counter <- 23
      }
      if (!(is.na(i))){
        denom <- denom + 1
        daily_sum <- daily_sum + i
      }
      j <- j + 1
    }
  write_col <- write_col +1
  }
  return(output_table)
}

#call calculate_avgs function
#Edit columns of data from weather data table to calculate averages for
cols <- c(6,7)

daily_avgs <- calculate_avgs(weather_data, cols, daily_avgs)

#write to file
file_name <- paste("hourly2daily_avgs_",weather_data$Station.Name[1],".csv", sep="")
write.csv(daily_avgs, file=file_name)
