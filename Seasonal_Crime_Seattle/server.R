library(shiny)
library(data.table)
library(dplyr)
library(ggplot2)

crime_data <- fread('~/../../Documents/seattle-seasonal-crime/data/Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv', header = TRUE,  stringsAsFactors = FALSE)
crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "%m/%d/%Y")
crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "$Y-%m-%d")

shinyServer(function(input, output) {
  
  output$crimePlot <- renderPlot({
    
    
    
  })
  
  output$summaryText <- renderText({
    
    into_text <- "This is the intro text"
    some_value1 <- 1
    some_value2 <- 2
    ending_text <- "This is the ending text"
    
    paste(intro_text, some_value1, some_value2, ending_text)
  }) 
  
  output$crimeTable <- renderTable({
    
    
    
  })
  
})
