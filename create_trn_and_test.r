#create training and test datasets from the original files

## set the seed to make your partition reproductible
set.seed(365)

dataDir <- "data\\final\\en_US"

train.prefix <- "train"
test.prefix <- "test"

make.trn.and.test <- function(filename) {

  lines <- readLines(paste(dataDir,filename,sep="/")) 
  
  print(paste("reading file: ",filename))  
  print(paste("original file rows: ",length(lines)))
  
  ## 75% of the sample size
  smp_size <- floor(0.75 * length(lines))
  
  train_ind <- sample(seq_len(length(lines)), size = smp_size)
  
  train <- lines[train_ind]
  test <- lines[-train_ind]
  
  print(paste("train file rows: ",length(train)))
  print(paste("test file rows: ",length(test)))
  
  train.filename <- paste(train.prefix,filename,sep=".")
  test.filename <- paste(test.prefix,filename,sep=".")
  
  writeLines(train,paste(dataDir,train.filename,sep="/"))
  writeLines(test,paste(dataDir,test.filename,sep="/"))
  
  rm(lines)
  rm(train_ind)
  rm(train)
  rm(test)
}


blogs.filename <- "en_US.blogs.txt"
news.filename <- "en_US.news.txt"
twitter.filename <- "en_US.twitter.txt"

make.trn.and.test(blogs.filename)
make.trn.and.test(news.filename)
make.trn.and.test(twitter.filename)

  
