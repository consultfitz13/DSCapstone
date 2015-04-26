# read the test data and randomly pick a word from each line to predict. 
# Take the words preceeding the picked word as the base for the prediction
# count the number of times you accurately guessed the word vs the number of lines read
# to get the overall accuracy of your algorithm
library(data.table)

dataDir <- "data\\final\\en_US"

#source("load_ngram_dts.r")
source("make_predictions.r")



predict.test.file <- function(filename) {
  predict.correct <- 0
  lines.processed <- 0
  step.count <- 10000
  
  test.lines <- readLines(paste(dataDir,filename,sep="/")) 
  max.lines <- length(test.lines)
  #max.lines <- 100
  for(i in 1:max.lines) {
    
    clean.search.for <- cleanLines(test.lines[i])
    search.words <- strsplit(clean.search.for," +")[[1]]
    
    # if the line only consists of 1 word, no prediction to make
    if (length(search.words) > 1) {
      lines.processed <- lines.processed + 1
      
      actual.word <- search.words[length(search.words)]
      sent.frag <- paste(search.words[1:length(search.words) - 1],collapse=" ")      
      predict.word <- predict.next.word(sent.frag)
      #print("sentence fragment: ")
      #print(paste(search.words[1:(actual.word.num - 1)],collapse=" "))
      #print(paste("actual next word: ",actual.word,"predicted next word: ",predict.word))
      
      if (actual.word == predict.word) {
        predict.correct <- predict.correct + 1
      }
      
    }
    
    
    if ((i %% step.count) == 0) {
      print(paste("completed ", i, " of ",max.lines, " lines"))
    }
    

  }
  
  return (list(lines.processed,predict.correct))
  
}


dataDir <- "data\\final\\en_US"

total.lines.tested <- 0
total.predict.correct <- 0

ptm <- proc.time()  

test.result <- predict.test.file("test.en_US.blogs.txt")
print(paste("blogs lines tested: ",test.result[[1]]))
print(paste("correct count: ",test.result[[2]]))      
total.lines.tested <- total.lines.tested  + test.result[[1]]
total.predict.correct <- total.predict.correct + test.result[[2]]

test.result <- predict.test.file("test.en_US.news.txt")
print(paste("news lines tested: ",test.result[[1]]))
print(paste("correct count: ",test.result[[2]]))      
total.lines.tested <- total.lines.tested  + test.result[[1]]
total.predict.correct <- total.predict.correct + test.result[[2]]

test.result <- predict.test.file("test.en_US.twitter.txt")
print(paste("twitter lines tested: ",test.result[[1]]))
print(paste("correct count: ",test.result[[2]]))      
total.lines.tested <- total.lines.tested  + test.result[[1]]
total.predict.correct <- total.predict.correct + test.result[[2]]

print(paste("percent correct: ",total.predict.correct / total.lines.tested))
print(proc.time() - ptm)
