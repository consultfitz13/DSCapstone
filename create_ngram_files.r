library(data.table)

dataDir <- "data\\final\\en_US"

step.size <-  50000
max.lines <- 2000000

trim <- function (x) gsub("^\\s+|\\s+$", "", x)

cleanLines <- function(x){
  x.clean <- tolower(x)
  x.clean <- gsub("[^a-zA-Z]+"," ",x.clean)
  x.clean <- trim(x.clean)
}

count.ngrams <- function(x){
  
  samplewords <- strsplit(cleanLines(x)," +")
  
  ngrams=4
  
  #unigram
  
  predictions <- unlist(lapply (samplewords, function(x){c(character(ngrams-1),x)}))
  names(predictions) <- NULL
  lengthneeded <- length(predictions)-1
  
  #bigram
  onestepback <- c(character(1), predictions[1:lengthneeded])
  
  #trigram
  twostepsback <- c(character(1), onestepback[1:lengthneeded])
  
  #quadgram
  threestepsback <- c(character(1), twostepsback[1:lengthneeded])

  #rm(samplewords)
  
  dt <- data.table(predictions,onestepback,twostepsback,threestepsback)
  setnames(dt,c("predictions","onestepback","twostepsback","threestepsback")) 
  
  dt1gram <- dt[nchar(predictions) > 0, .N ,by = predictions]  
  setnames(dt1gram,c("ngram","count"))  
  dt1gram <- dt1gram[,.(ngram,ngram,count)]
  setnames(dt1gram,c("ngram","target","count"))
  setkey(dt1gram, ngram)  
  
  dt2gram <- dt[nchar(predictions) > 0 & nchar(onestepback) > 0, .(onestepback,predictions)]    
  setnames(dt2gram,c("ngram","target"))  
  dt2gram <- dt2gram[, .N ,by = .(ngram,target)]    
  setnames(dt2gram,c("ngram","target","count"))
  setkey(dt2gram, ngram)
  
  
  dt3gram <- dt[nchar(predictions) > 0 & nchar(onestepback) > 0& nchar(twostepsback) > 0, .(paste(twostepsback,onestepback),predictions)]    
  setnames(dt3gram,c("ngram","target"))  
  dt3gram <- dt3gram[, .N ,by = .(ngram,target)]    
  setnames(dt3gram,c("ngram","target","count"))
  setkey(dt3gram, ngram)
  
  dt4gram <- dt[nchar(predictions) > 0 & nchar(onestepback) > 0& nchar(twostepsback) > 0 & nchar(threestepsback) > 0, .(paste(threestepsback,twostepsback,onestepback),predictions)]    
  setnames(dt4gram,c("ngram","target"))  
  dt4gram <- dt4gram[, .N ,by = .(ngram,target)]    
  setnames(dt4gram,c("ngram","target","count"))
  setkey(dt4gram, ngram)
  
  return (list(dt1gram,dt2gram,dt3gram,dt4gram))
  
}

build.ngrams.fm.file <- function(filename) {
  
  tot.dt1gram <- data.table()
  tot.dt2gram <- data.table()
  tot.dt3gram <- data.table()
  tot.dt4gram <- data.table()
  
  lines.read <- 0
  
  ff <- file(paste(dataDir,filename,sep="/"), open="rt")  # rt is read text 
  
  ttm <- proc.time()  
  
  for (i in 1:(max.lines / step.size)) { 
    
    ptm <- proc.time()  
    
    x <- readLines(ff, n=step.size) 
    lines.read <- lines.read + length(x)
    
    cat("lines read: ",lines.read,"\n")
    
    ngram.counts <- count.ngrams(x)  
    
    if (nrow(tot.dt1gram) == 0) {
      tot.dt1gram <- ngram.counts[[1]]
      tot.dt2gram <- ngram.counts[[2]]
      tot.dt3gram <- ngram.counts[[3]]
      tot.dt4gram <- ngram.counts[[4]]
    } else {
      tot.dt1gram <- rbindlist(list(tot.dt1gram,ngram.counts[[1]]),use.names = TRUE,fill=FALSE)
      setkey(tot.dt1gram, ngram)
      tot.dt1gram <- tot.dt1gram[, sum(count, na.rm = TRUE),by = .(ngram,target)]
      setnames(tot.dt1gram,c("ngram","target","count"))
      
      tot.dt2gram <- rbindlist(list(tot.dt2gram,ngram.counts[[2]]),use.names = TRUE,fill=FALSE)
      setkey(tot.dt2gram, ngram)
      tot.dt2gram <- tot.dt2gram[, sum(count, na.rm = TRUE),by = .(ngram,target)]
      setnames(tot.dt2gram,c("ngram","target","count"))
      
      tot.dt3gram <- rbindlist(list(tot.dt3gram,ngram.counts[[3]]),use.names = TRUE,fill=FALSE)
      setkey(tot.dt3gram, ngram)
      tot.dt3gram <- tot.dt3gram[, sum(count, na.rm = TRUE),by = .(ngram,target)]
      setnames(tot.dt3gram,c("ngram","target","count"))
      
      tot.dt4gram <- rbindlist(list(tot.dt4gram,ngram.counts[[4]]),use.names = TRUE,fill=FALSE)
      setkey(tot.dt4gram, ngram)
      tot.dt4gram <- tot.dt4gram[, sum(count, na.rm = TRUE),by = .(ngram,target)]
      setnames(tot.dt4gram,c("ngram","target","count"))
    }
    
    
    print(paste("done batch:",i))
    print(proc.time() - ptm)
    
    if (length(x) < step.size) {
      break
    }
    
    rm(x)  
    
    
  } 
  
  close(ff) 
  cat("lines read: ",lines.read,"\n")
  
  #purge ngrams that have only occurred once in the sample
  tot.dt1gram <- tot.dt1gram[count > 2,]
  tot.dt2gram <- tot.dt2gram[count > 2,]
  tot.dt3gram <- tot.dt3gram[count > 2,]
  tot.dt4gram <- tot.dt4gram[count > 2,]
  
  dt1gram.filename <- paste("dt1gram",filename,sep=".")
  write.table(tot.dt1gram,paste(dataDir,dt1gram.filename,sep="/"))
  
  dt2gram.filename <- paste("dt2gram",filename,sep=".")
  write.table(tot.dt2gram,paste(dataDir,dt2gram.filename,sep="/"))

  dt3gram.filename <- paste("dt3gram",filename,sep=".")
  write.table(tot.dt3gram,paste(dataDir,dt3gram.filename,sep="/"))

  dt4gram.filename <- paste("dt4gram",filename,sep=".")
  write.table(tot.dt4gram,paste(dataDir,dt4gram.filename,sep="/"))
  
  print("total time")
  print(proc.time() - ttm)
  
  rm(ngram.counts)
}

build.ngrams.fm.file("train.en_US.blogs.txt")
build.ngrams.fm.file("train.en_US.news.txt")
build.ngrams.fm.file("train.en_US.twitter.txt")

      