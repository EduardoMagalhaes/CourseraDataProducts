
# Coursera - Developing Data Products Course
# Course Project: Shiny Application and Reproducible Pitch
# Eduardo Magalhaes Barbosa

# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

## Quandl Library allows you to use online data sets

library(Quandl)
Quandl.auth("o_7e9aEakBmkPksQXFZW")  ## MyPersonal Token


## Read historic gold daily prices

GoldDailyUSD <- Quandl("WGC/GOLD_DAILY_USD")

## Read historic Kinross GOld Corp Stock prices

KGCStockPrice <- Quandl("GOOG/NYSE_KGC")

## Merge the two datasets and clean unused collumns

Prices <- merge(GoldDailyUSD, KGCStockPrice, all=TRUE)
Prices$Open <- NULL
Prices$High <- NULL
Prices$Low <- NULL

## Remove NA data

Prices <- na.omit(Prices)

library(shiny)

shinyServer(function(input, output) {
 
  
  ds <- reactive({
    
    ## Create a reactive function that re-filter the dataset every time one of the inputs are changed
    
    FilteredPrices <- Prices[ Prices$Date >= as.Date(input$dateRange[1]) & Prices$Date <= as.Date(input$dateRange[2]), ]
        
  })
    
  output$StockGoldPlot <- renderPlot({
    
    FilteredPrices <- ds()
   
    ## add extra space to right margin of plot within frame
    par(mar=c(6, 4, 4, 6) + 0.1)
    
    ## Plot first set of data and draw its axis
    plot(FilteredPrices$Date, FilteredPrices$Value, pch=16, axes=FALSE,  xlab="", ylab="", 
         type="o",col="black", main="Stock & Gold Prices")
    axis(2,col="black",las=1)  ## las=1 makes horizontal labels
    mtext("Gold Price",side=2,line=3)
    box()
    
    par(new=TRUE) # Allow a second plot on the same graph
    
    ## Plot the second plot and put axis scale on right
    plot(FilteredPrices$Date, FilteredPrices$Close, pch=15,  xlab="", ylab="",  
         axes=FALSE, type="o", col="red")
    mtext("Stock Options Close Price",side=4,col="red",line=3) 
    axis(4, col="red",col.axis="red",las=1)
    ## Draw the time axis
    axis(1, FilteredPrices$Date, format(FilteredPrices$Date, "%Y-%m-%d" ), cex.axis = .6, las=2)
    mtext("Date",side=1,col="black",line=5)  
        
  })
  
  output$FittedPlot <- renderPlot({
    
    FilteredPrices <- ds()
    
    plot(FilteredPrices$Value, FilteredPrices$Close,  pch=16, axes=FALSE,  xlab="", ylab="", 
         type="p",col="black", main="Fitted Stock Prices")
    axis(2,col="black",las=1)  ## las=1 makes horizontal labels
    mtext("Stock Close Price",side=2,line=3)
    
    axis(1,col="black",las=1)  ## las=1 makes horizontal labels
    mtext("Gold Price",side=1,line=3)
    
    abline(lm(Close ~ Value, data=FilteredPrices), col="red")
    
    
  })
  
  output$Retorno <- renderText({
    # make sure end date later than start date
    validate( 
      need(input$dateRange[2] > input$dateRange[1], "end date is earlier than start date")
      )
    
    # make sure greater than 2 week difference
    validate( 
      need(difftime(input$dateRange[2], input$dateRange[1], "days") > 14, "date range less the 14 days")
      )
   
    ## Calculate Liner Regression (Simple)
    
    FilteredPrices <- ds()
    
    GoldPriceLM = lm(Close ~ Value, data=FilteredPrices)
    
    
    Coeffs = coefficients(GoldPriceLM)
        
    paste("Your date range is", difftime(input$dateRange[2], input$dateRange[1], units="days") ,
          " days. Based on those dates, the estimated stock price should be ", format(Coeffs[1], 2), 
          " + (", format(Coeffs[2], 2) , " * ", input$Target,  " ) = ", format( Coeffs[2]* input$Target + Coeffs[1], 2)
    )
     
        
  })
  
 

})
