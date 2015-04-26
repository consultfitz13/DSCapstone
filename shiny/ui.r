library(shiny)

# Define UI for word prediction app
shinyUI(fluidPage(
  
  # Application title.
  titlePanel("Carnac the Magnificent Word Prediction System "),
  
  # Sidebar with controls to select a dataset and specify the
  # number of observations to view. The helpText function is
  # also used to include clarifying text. Most notably, the
  # inclusion of a submitButton defers the rendering of output
  # until the user explicitly clicks the button (rather than
  # doing it immediately when inputs change). This is useful if
  # the computations required to render output are inordinately
  # time-consuming.
  sidebarLayout(
    sidebarPanel(
    
      textInput("ngram", "English Phrase:", ""),
      
      helpText("Note: Submit a phrase or sentence without the last word and click the Get Next Word button.
               Carnac the Magnificent will guess the next word"),
      
      submitButton("Guess Next Word")
    ),
    
    # Show the guess at the next word
    mainPanel(
      h4("And the next word is"),
      verbatimTextOutput("next.word")
      
    )
  )
))