The Magnificent Carnac Word Prediction System
========================================================
author: John Fitzpatrick
date: April 25, 2015

How the model is built
========================================================
- All code can be found in the Github repository, https://github.com/consultfitz13/DSCapstone
- separate the input data into separate training (75%) and test (25%) files
- read the training data, clean it, and separate each line into words (tokenize)
- create data tables of most frequent 4, 3, 2 and 1 word combinations (ngrams)
- write each data table to a file so that it can be read in and used by the model

How the model works
========================================================
- take an input sentence, clean and separate into words, extract the last few words of the sentence
- using the data tables from above, try to find a match for the last words in the sentence starting with the 4 ngram table
- if found, use the last word in that combination as the answer
- if no match is found, try the 3 word table, then the 2 word table
- if no match is found in any of the preceding tables, return the most common word

Testing the model
========================================================
- read in the test files created at the start of the process
- create a test phrase by carving out a phrase from the line starting at the first word and ending in a randomly chosen word somewhere in the line. That word will be what we are trying to predict
- run the model with the phrase created above minus the last word
- compare the prediction to the actual last word
- aggregate the results
- the model only got 13.2% of the words correct when run on the test data

How the shiny app works
========================================================
- the data and code for the model above are published as a shiny app
- when the app starts it reads the data tables and waits for user input
- the user enters a phrase and then clicks the Get Next Word button
- this triggers the server code that executes the algorithm above
- the best match is presented to the user in a text box




