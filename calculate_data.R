library(data.table)
library(ggplot2)

#set working directory. Change Station ID as necessary
setwd("C:/Users/Maria/Documents/AAFC/get_weather/6526/daily")
#get file 
#format from find_missing_data.R
dat_frame <- fread(file = "weather_data.csv", header=TRUE)

#~~~~~~~~~~~~~~~~~CALCULATE DATA~~~~~~~~~~~~~~~~~~~~~~~~~~

#calculate yearly precip sum
yearly_precip <- aggregate(dat_frame$Total.Precip..mm., by=list(Year=dat_frame$Year), FUN=sum)

#calculate daily GDD and cumulative yearly GDD
dat_frame$"Daily GDD" <- ((dat_frame$Max.Temp..Â.C.+ dat_frame$Min.Temp..Â.C.)/2 - 5)
yearly_GDD <- aggregate(dat_frame$`Daily GDD`, by=list(Year=dat_frame$Year), FUN=sum)

#Calculate quartiles
IQR_gdd_q1 <-quantile(yearly_GDD[,2],0.25,na.rm=T)
IQR_precip_q1 <- quantile(yearly_precip[,2],0.25,na.rm=T)
IQR_gdd_q3 <-quantile(yearly_GDD,0.75,na.rm=T)
IQR_precip_q3 <- quantile(yearly_precip[,2],0.75,na.rm=T)


#Calculate 30 year averages
average_yearly_GDD = mean(yearly_GDD$x, na.rm=TRUE)
average_yearly_precip = mean(yearly_precip$x, na.rm=TRUE)


stn_averages <- data.frame(dat_frame$Station.Name[1], average_yearly_precip,average_yearly_precip-IQR_precip_q1,IQR_precip_q3-average_yearly_precip,average_yearly_GDD, average_yearly_GDD-IQR_gdd_q1,IQR_gdd_q3-average_yearly_GDD)

#save to master file
setwd("C:/Users/Maria/Documents/AAFC/get_weather")
write.table(stn_averages, file = "station_30year_averages.csv", append = T, sep = ',', quote = F, row.names = F, col.names = F)

#~~~~~~~~~~~~~~~~~~~~~CREATE PLOT GRAPH~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

graph_data <- fread(file = "station_30year_averages.csv", header=TRUE)

ggplot(data=graph_data, aes(x = graph_data$avg_yrly_gdd, y =graph_data$avg_yrly_precip, shape=graph_data$`Station Name`, color=graph_data$`Station Name`)) + geom_point() + 
  geom_errorbar(aes(ymin=graph_data$avg_yrly_precip-graph_data$precip_q1,ymax=graph_data$avg_yrly_precip+graph_data$precip_q3)) + 
  geom_errorbar(aes(xmin=graph_data$avg_yrly_gdd-graph_data$gdd_q1, xmax=graph_data$avg_yrly_gdd+graph_data$gdd_q3)) +
  xlab("Growing Degree Days (GDD)") + ylab("Precipitation (mm)") + guides(shape=guide_legend("Station"), color=FALSE)


