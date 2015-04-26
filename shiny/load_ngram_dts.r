library(data.table)
dataDir <- "data"

combined.dt1gram <- data.table()
combined.dt2gram <- data.table()
combined.dt3gram <- data.table()
combined.dt4gram <- data.table()

# since there's no context for where the word to be guessed will be entered, we'll combine the
# ngram tables from the 3 sources
# 1 gram
dtngram <- read.table(paste(dataDir,"combined.dt1gram.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt1gram <- rbindlist(list(combined.dt1gram,dtngram),use.names = TRUE,fill=FALSE)

dtngram <- read.table(paste(dataDir,"combined.dt2gram.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt2gram <- rbindlist(list(combined.dt2gram,dtngram),use.names = TRUE,fill=FALSE)

dtngram <- read.table(paste(dataDir,"combined.dt3gram.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt3gram <- rbindlist(list(combined.dt3gram,dtngram),use.names = TRUE,fill=FALSE)

dtngram <- read.table(paste(dataDir,"combined.dt4gram.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt4gram <- rbindlist(list(combined.dt4gram,dtngram),use.names = TRUE,fill=FALSE)

setkey(combined.dt1gram, ngram)
setkey(combined.dt2gram, ngram)
setkey(combined.dt3gram, ngram)
setkey(combined.dt4gram, ngram)

rm(dtngram)

