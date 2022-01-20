# Download file automatically using urllib.request and Python 3:
# https://stackoverflow.com/a/8286449
# Download page:
# http://climate.weather.gc.ca/historical_data/search_historic_data_e.html
# Download daily/hourly climate data csv files from EnvCan for given year.
import os
import time
import calendar
import urllib.request

#search of stations with available weather data: http://climate.weather.gc.ca/historical_data/search_historic_data_stations_e.html?searchType=stnProv&timeframe=1&lstProvince=&optLimit=yearRange&StartYear=1840&EndYear=2019&Year=2019&Month=7&Day=28&selRowPerPage=25
#station ID's can be found in the url of a data file that is being viewed

#Harrington             Hourly 2004-2019, Daily 2000-2019
#Charlottetown          Hourly 2012-2019, Daily 2012-2019
#Charlottetown A        Hourly 1953-2012, Daily 1943-2012
#Charlottetown CDA      Hourly xxxx-xxxx, Daily 1910-1992
#Fredericton CDA        ????
class Station:
	def __init__(self, name, id, firstyear, lastyear):
		self.name = name
		self.id = id
		self.firstyear = firstyear
		self.lastyear = lastyear


# creating list        
list = []

#list.append( Station('Harrington', '30308', 2000, 2021) )
#list.append( Station('Charlottetown', '50621', 1872, 1872) )
#list.append( Station('Charlottetown_A', '6526', 1943, 2020) )
#list.append( Station('Charlottetown_CDA', '6527', 1910, 1992) )
#list.append( Station('Kentville_CDA', '6375', 1913, 1996 ) )
#list.append( Station('Fredericton_A', '6157', 1871, 1952) )
# list.append( Station('Alberton Snow', '49988', 2012, 2019))
# list.append( Station('Alliston Snow', '47227', 2008, 2009))
# list.append( Station('Argyle Shore', '6521', 1988, 1991))
# list.append( Station('Borden', '6523', 1958, 1967))
# list.append( Station('Brackley Beach', '6524', 1952, 1956))
# list.append( Station('Elmwood','6929' , 1993, 2015))
# list.append( Station('Elmwood Snow', '49770', 2011, 2015))
# list.append( Station('Hunter River', '6533', 1971, 1984))
# list.append( Station('Kingsboro', '30618', 2000, 2007))
# list.append( Station('Kingsboro Snow', '49771', 2011, 2016))
# list.append( Station('Long Creek Snow', '49768', 2011, 2014))
# list.append( Station('Montague', '6535', 1961, 1977))
# list.append( Station('Morell Snow', '49772', 2011, 2016))
# list.append( Station('Newtown Cross', '6539', 1984, 1997))
# list.append( Station('North Cape', '10814', 2002, 2021))
#list.append( Station('Souris', '6543', 1967, 1987))
#list.append( Station('South Pinette', '6544', 1982, 1983))
#list.append( Station('St. Nicolas', '6930', 1992, 1994))
#list.append( Station('St. Peters', '41903', 2003, 2021))
list.append( Station('Stanhope', '6545', 1961, 2021))
#list.append( Station('Summerside Snow 2', '49773', 2011, 2015))
#list.append( Station('Tignish', '6548', 1971, 1993))
#list.append( Station('Tyne Valley', '6549', 1990, 2009))
#list.append( Station('Tyne Vally 2', '49788', 2011, 2013))
#list.append( Station('Vernon Brigde', '30701', 2000, 2001))
#list.append( Station('Victoria', '6931', 1993, 2004))

root = os.getcwd()
for obj in list:
	station_name = obj.name
	# create a folder for the station ...
	# define the name of the directory to be created

	path = root+'/'+str(obj.name)

	try:
		os.mkdir(path)
	except OSError:
		print ("Creation of the directory %s failed" % path)
	else:
		print ("Successfully created the directory %s " % path)

	# moving into station folder
	os.chdir(path)

	# create file name in right format eng-daily-01012017-12312017.csv
	A=('01','02','03','04','05','06','07','08','09','10','11','12')  #array of month numbers
	dwn='urllib' #options firefox explorer urllib <-- urllib works, firefox and explorer currently do not
	parent=os.getcwd()

	for k in range(obj.firstyear,obj.lastyear + 1): #set year range
		yr=k

		if calendar.isleap(yr)==True:
			B=('31','29','31','30','31','30','31','31','30','31','30','31') #array of last day of month numbers (leap year)
		else:
			B=('31','28','31','30','31','30','31','31','30','31','30','31') #array of last day of month numbers (not leap year)



		# create a folder for each iteration and name it by year ...
		# define the name of the directory to be created
		#path = parent+'/'+str(k)

		#try:
			#os.mkdir(path)
		#except OSError:
			#print ("Creation of the directory %s failed" % path)
		#else:
			#print ("Successfully created the directory %s " % path)

		# moving into folder to download csv(s)
		#os.chdir(path)

		#downloading the daily data (1 file for the selected year) and hourly data (12 files)


		#URL
		ulr1=('http://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID='+obj.id+'&Year='+str(yr)+'&Month=12&Day=1&timeframe=2&submit=Download+Data')
		fname=('eng-daily-0101'+str(yr)+'-1231'+str(yr)+'.csv')
		print(r'downloading  %s' %fname)

		#download request
		urllib.request.urlretrieve(ulr1, fname)

		#for i in range(0,13):
			#ulr1=('http://climate.weather.gc.ca/climate_data/bulk_data_e.html?format=csv&stationID='+obj.id+'&Year='+str(yr)+'&Month='+str(i)+'&Day='+B[i-1]+'&timeframe=1&submit=Download+Data')
			#fname=('eng-hourly-'+A[i-1]+'01'+str(yr)+'-'+A[i-1]+B[i-1]+str(yr)+'.csv')
			#print(r'downloading  %s' %fname)

			#download request
			#urllib.request.urlretrieve(ulr1, fname)

		os.chdir(parent)
		# return to root dir
	print(root)
	os.chdir(root)
    
