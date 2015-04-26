library(shiny)
library(data.table)

source("load_ngram_dts.r")
source("make_predictions.r")

# Define server logic required to summarize and view the 
# selected dataset
shinyServer(function(input, output) {
  
  output$next.word <- renderText({
    predict.next.word(input$ngram)
  })
  
})