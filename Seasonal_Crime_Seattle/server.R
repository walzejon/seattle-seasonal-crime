library(shiny)
library(data.table)
library(lubridate)
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
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")
    crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "%m-%d")
    
    if(input$changeSeason == "Winter") {
      
      crime_data1 <- subset(crime_data, REPORT_DATE >= "2019-12-01")
      crime_data2 <- subset(crime_data, REPORT_DATE < "2019-03-01")
      crime_data <- rbind(crime_data1, crime_data2)
      crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")
      
      
      
    }
    if(input$changeSeason == "Spring") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-03-01" & REPORT_DATE < "2019-06-01")
      crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")      
      
      
      
    }
    if(input$changeSeason == "Fall") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-03-01" & REPORT_DATE < "2019-06-01")
      crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")     
      
      
      
    }
    else {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-09-01" & REPORT_DATE < "2019-12-01")
      crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")   
      
      
      
      
      
    }
  })
  
})
