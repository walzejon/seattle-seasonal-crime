library(shiny)
library(data.table)
library(dplyr)
library(ggplot2)
library(lubridate)

crime_data <- fread('~/../../Documents/seattle-seasonal-crime/data/Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv', header = TRUE,  stringsAsFactors = FALSE)
crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "%m/%d/%Y")
crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "$Y-%m-%d")

shinyServer(function(input, output) {
  
  output$crimePlot <- renderPlot({
    crime_data$REPORT_DATE <- format(temp, format="%m-%d")
    
    
  })
  
  output$summaryText <- renderText({
    
    
    
  }) 
  
  output$crimeTable <- renderTable({
    
    
    
  })
  
})
