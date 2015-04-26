library(data.table)
library(tm)
dataDir <- "data\\final\\en_US"

combined.dt1gram <- data.table()
combined.dt2gram <- data.table()
combined.dt3gram <- data.table()
combined.dt4gram <- data.table()

# since there's no context for where the word to be guessed will be entered, we'll combine the
# ngram tables from the 3 sources
# 1 gram
dtngram <- read.table(paste(dataDir,"dt1gram.train.en_US.blogs.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt1gram <- rbindlist(list(combined.dt1gram,dtngram),use.names = TRUE,fill=FALSE)

dtngram <- read.table(paste(dataDir,"dt1gram.train.en_US.news.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt1gram <- rbindlist(list(combined.dt1gram,dtngram),use.names = TRUE,fill=FALSE)

dtngram <- read.table(paste(dataDir,"dt1gram.train.en_US.twitter.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt1gram <- rbindlist(list(combined.dt1gram,dtngram),use.names = TRUE,fill=FALSE)

# 2 gram
dtngram <- read.table(paste(dataDir,"dt2gram.train.en_US.blogs.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt2gram <- rbindlist(list(combined.dt2gram,dtngram),use.names = TRUE,fill=FALSE)

dtngram <- read.table(paste(dataDir,"dt2gram.train.en_US.news.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt2gram <- rbindlist(list(combined.dt2gram,dtngram),use.names = TRUE,fill=FALSE)

dtngram <- read.table(paste(dataDir,"dt2gram.train.en_US.twitter.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt2gram <- rbindlist(list(combined.dt2gram,dtngram),use.names = TRUE,fill=FALSE)

# 3 gram
dtngram <- read.table(paste(dataDir,"dt3gram.train.en_US.blogs.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt3gram <- rbindlist(list(combined.dt3gram,dtngram),use.names = TRUE,fill=FALSE)

dtngram <- read.table(paste(dataDir,"dt3gram.train.en_US.news.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt3gram <- rbindlist(list(combined.dt3gram,dtngram),use.names = TRUE,fill=FALSE)

dtngram <- read.table(paste(dataDir,"dt3gram.train.en_US.twitter.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt3gram <- rbindlist(list(combined.dt3gram,dtngram),use.names = TRUE,fill=FALSE)

# 4 gram
dtngram <- read.table(paste(dataDir,"dt4gram.train.en_US.blogs.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt4gram <- rbindlist(list(combined.dt4gram,dtngram),use.names = TRUE,fill=FALSE)

dtngram <- read.table(paste(dataDir,"dt4gram.train.en_US.news.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt4gram <- rbindlist(list(combined.dt4gram,dtngram),use.names = TRUE,fill=FALSE)

dtngram <- read.table(paste(dataDir,"dt4gram.train.en_US.twitter.txt",sep="/"),stringsAsFactors=FALSE)
combined.dt4gram <- rbindlist(list(combined.dt4gram,dtngram),use.names = TRUE,fill=FALSE)

rm(dtngram)

# since we're targeting the last word in a sentence there are many words that 
# don't make sense as the last word for example "the". We'll eliminate those
# by using the stopwords list from the tm package

combined.dt4gram <- combined.dt4gram[!(target %in% stopwords(kind="en")),]
combined.dt3gram <- combined.dt3gram[!(target %in% stopwords(kind="en")),]
combined.dt2gram <- combined.dt2gram[!(target %in% stopwords(kind="en")),]
combined.dt1gram <- combined.dt1gram[!(target %in% stopwords(kind="en")),]

setkey(combined.dt1gram, ngram)
setkey(combined.dt2gram, ngram)
setkey(combined.dt3gram, ngram)
setkey(combined.dt4gram, ngram)

#remove all but the ngrams with the highest count since the algorithm will always pick
#that one anyway for this exercise
pick.max <- function(dt) {
  dt <- dt[order(ngram,-count)]
  setkey(dt, ngram)
  dt <-dt[J(unique(ngram)),mult="first"]
}

#since you're only predicting the next word narrow the list to the 
#choice for each ngram that has the highest coutn

combined.dt1gram <- pick.max(combined.dt1gram)
combined.dt2gram <- pick.max(combined.dt2gram)
combined.dt3gram <- pick.max(combined.dt3gram)
combined.dt4gram <- pick.max(combined.dt4gram)

setkey(combined.dt1gram, ngram)
setkey(combined.dt2gram, ngram)
setkey(combined.dt3gram, ngram)
setkey(combined.dt4gram, ngram)


write.table(combined.dt1gram,paste(dataDir,"combined.dt1gram.txt",sep="/"))
write.table(combined.dt2gram,paste(dataDir,"combined.dt2gram.txt",sep="/"))
write.table(combined.dt3gram,paste(dataDir,"combined.dt3gram.txt",sep="/"))
write.table(combined.dt4gram,paste(dataDir,"combined.dt4gram.txt",sep="/"))
