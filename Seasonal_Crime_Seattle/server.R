library(shiny)
library(data.table)
library(lubridate)
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
    
    into_text <- "This is the intro text"
    some_value1 <- 1
    some_value2 <- 2
    ending_text <- "This is the ending text"
    
    paste(intro_text, some_value1, some_value2, ending_text)
  }) 
  
  output$crimeTable <- renderTable({
    crime_data$REPORT_DATE <- format(temp, format="%m-%d")
    
    if(input$changeSeason == "Winter") {
      crime_data <- filter(crime_data, REPORT_DATE >= "12-01", REPORT_DATE < "03-01" )
      
    }
    if(input$changeSeason == "Spring") {
      crime_data <- filter(crime_data, REPORT_DATE >= "03-01", REPORT_DATE < "06-01" )
      
    }
    if(input$changeSeason == "Fall") {
      crime_data <- filter(crime_data, REPORT_DATE >= "06-01", REPORT_DATE < "09-01" )
     
    }
    else {
      crime_data <- filter(crime_data, REPORT_DATE >= "09-01", REPORT_DATE < "12-01" )
      
    }
  })
  
})
