### This is the stump script to read the data and plot the maps
### You have to write the code suggested here.
### Feel free to follow the ideas in a different manner/in a different file.
### However, you have to submit your main code file.
###
### The file must be executable on the server!
### I.e. someone else must be able to just run it with 'Rscript maps.R'
### /on server/ and get the correct output.

library(data.table)
library(R.utils)
library(dplyr)
library(ggplot2)
library(mapproj)
## read the data
## 
## hint1: figure out the correct format and use the correct function.
##
## hint2: read.table and friends are slow (about 6 min to read data).
## You may use data.table::fread instead (a few seconds)
data <- data.table::fread("../../opt/data/temp_prec_middle_encrypted.csv.bz2", sep = "\t", header = TRUE, stringsAsFactors = FALSE)
decryptedData <- decrypt::decryptData(data)
## filter out North American observations
data <- decryptedData %>% filter(longitude > 180, longitude < 310, latitude < 85, latitude > 15)

## delete the original (large data) from R workspace
## this is necessary to conserve memory.


## -------------------- do the following for 1960, 1986, 2014 and temp/precipitation --------------------

## select jpg graphics device
#
# ## select the correct year - plot longitude-latitude and color according to the temp/prec variable
# ## I recommend to use ggplot() but you can use something else too.
# ##
# ## Note: if using ggplot, you may want to add "+ coord_map()" at the end of the plot.  This
# ## makes the map scale to look better.  You can also pick a particular map projection, look
# ## the documentation.  (You need 'mapproj' library).
# ## Warning: map projections may be slow (several minutes per plot).

createMaps <- function(years) {
  for (year in years) {
    newData <- data %>% filter(year(time)==year, month(time)==06)
    jpeg(filename=paste0(year, "_precip.png"), width = 1000, height = 1000)
    print(ggplot(newData) + geom_point(mapping = aes(x = longitude, y = latitude, col = precipitation, size = 4), na.rm=TRUE) + labs(title = paste0("Precipitation in June, ", year)) + coord_quickmap())
    dev.off()
    
    jpeg(filename=paste0(year, "_temp.png"), width = 1000, height = 1000)
    print(ggplot(newData) + geom_point(mapping = aes(x = longitude, y = latitude, col = airtemp, size = 4), na.rm=TRUE) + labs(title = paste0("Air Temperature in June, ", year)) + coord_quickmap())
    dev.off()
  }
}

createMaps(c(1960, 1986, 2014))
## close the device

## -------------------- you are done.  congrats :-) --------------------

