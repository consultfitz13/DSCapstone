dataDir <- "data"
dsFileName <- paste(dataDir,"Coursera-SwiftKey.zip",sep="/")  

library(utils)
unzip(dsFileName)

if (!file.exists(dataDir)) {
  dir.create(dataDir)
  
  setInternet2(TRUE)  # set the R_WIN_INTERNET2 to TRUE  
  ds.url <- "https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip"
  download.file(ds.url,dsFileName)

  
  dateDownloaded <- date()
  dateDownloaded
  
  library(utils)
  unzip(dsFileName, exdir=dataDir)

}

