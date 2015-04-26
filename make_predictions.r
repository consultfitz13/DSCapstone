library(data.table)


trim <- function (x) gsub("^\\s+|\\s+$", "", x)

cleanLines <- function(x){
  x.clean <- tolower(x)
  x.clean <- gsub("[^a-zA-Z]+"," ",x.clean)
  x.clean <- trim(x.clean)
}

find.matches <- function(search.words, ngrams, ngram.size) {
  
  if (length(search.words) >= (ngram.size - 1)) { 
    start.idx <- length(search.words) - (ngram.size - 2)
    end.idx <- length(search.words)
    search.gram <- paste(search.words[start.idx:end.idx],collapse = ' ')
    matches <- ngrams[ngram == search.gram,]
    matches <- matches[order(-count),] #order by descending count
  } else {
    matches <- data.table()
  }
  
}


predict.next.word <- function(sent.frag) {
  predict.word <- ""
  
  
  if (nchar(sent.frag) > 0) {
    
    search.words <- strsplit(cleanLines(sent.frag)," +")[[1]]
    
    matches <- find.matches(search.words,combined.dt4gram,4)
    
    if (nrow(matches) > 0) {
      predict.word <- matches[1,target]
    } else {
      matches <- find.matches(search.words,combined.dt3gram,3)  
      if (nrow(matches) > 0) {
        predict.word <- matches[1,target]
      } else {
        matches <- find.matches(search.words,combined.dt2gram,2)      
        if (nrow(matches) > 0) {
          predict.word <- matches[1,target]
        } else {
          predict.word <- combined.dt1gram[order(-count),][1,target] #order by descending count      
        }
      }
    }
  }
  
  
  predict.word
  
}



