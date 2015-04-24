# Coursera - Developing Data Products Course
# Course Project: Shiny Application and Reproducible Pitch
# Eduardo Magalhaes Barbosa

# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)

shinyUI(fluidPage(

  # Application title
  titlePanel("Gold Stock Prices"),

  # Sidebar with a range dates
  sidebarLayout(
    sidebarPanel(
      
      dateRangeInput('dateRange',
                     label = 'Date range input: yyyy-mm-dd',
                     start = Sys.Date() - 30, end = Sys.Date() ),
      
      numericInput("Target", "Gold Price USD/AuOz:", 1200),
      
      HTML("<B><I>Instructions:</I></B>"),

      helpText(
        " Based on the date range you select and the app will gather historic gold prices ",
        " and Gold Companys Stock Close Prices and correlate them for that period. Choose a new target", 
        " Gold Price and the app will estimate the Stock price!"),      
      
      strong("Note: The first time this Shiny app runs, it will load a dataset from external sources,",
        "it may take a little while, please be patient!")
      
      ),
    
    # Show two plots and the predicted Stock price for targeted gold price inputed
    mainPanel(
   
      h4("Estimation"),
      
      textOutput("Retorno"),
      
      plotOutput("StockGoldPlot"),
      
      h4("Fitted Plot"),
      
      plotOutput("FittedPlot"),
      
            
      helpText("Disclaimer: Do not use this for real-world transactions. This is a simple Shiny project for Coursera Course!")
      
   
   )
  )
))
