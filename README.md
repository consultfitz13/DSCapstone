# DSCapstone
Contains files used for the Data Science Capstone project taught by instructors at Johns Hopkins
The Capstone project is to produce a prediction algorithm based on files in the " HC Corpora (www.corpora.heliohost.org)" 
to guess the last word in a sentence. This project uses the English language files as the source for its model

# Summary
The prediction algoritm is fast but not very accurate. It achieved only a 13.2% accuracy on the test data set.

The entire process can be executed by running the capstone.r file. It takes about 5 hours to run.

# Directories and files
## Base Directory
Contains all of the R programming code

## data
Contains the input files will be downloaded and unzipped. It will also be where the ngram files used
in the prediction model are housed

## shiny
Contains the code for the shiny app

## shiny/data
Contains the consolidated ngram files used by the shiny app to predict the next word

## rpresenter
Contains the rpresenter app


# Reproducing the results
Source the file "capstone.r". This program will source other files to download the data, separate it into training and test data 
implement the prediction algorithm, and test it


# Description of programming files

## download_data.r
Downloads the input file and unzip it in the data directory

## create_trn_and_test.r
Create training files be randomly selecting 75% of the lines in each input file. These will be used to build the model
Create test files from the remaining 25% of lines in each file. These will be used to test the model

## create_ngram_files.r
Create files containing the most common 4,3,2, and 1 word combinations in the training files. 
Thanks to TA David Hood for the code to do this. Got me over a big problem with not having enough memory

## make_combined_ngram_files.r
Since we don't have a specific content for what kind of data our prediction algorithm needs to handle. Combine the ngram
files from each source. In addition since we're only looking to predict the last word we can eliminate a number of words that
don't make sense as the last word in a sentence, for example, "the"

Also, since we can only predict one word we can eliminate all but the max count for each combination containing the same antecedent
words

## make_predictions.r
Contains the prediction algorithm. It's a very simple one. Take the last words of the sentence and try to find a match starting
with the 4gram file, then the 3 gram, 2gram, and finally the most common word. If you find a match, that's the word that will be
predicted.

## predict_test_last_word.r
Reads the test files in and runs the prediction algorithm on each line of the test file. Compares the actual last word to the predicted
last word and computes an accuracy score

