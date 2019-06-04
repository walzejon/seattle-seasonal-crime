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
  
  # where main visual data is presented alongside map showing the precincts.
  output$crimePlot <- renderPlot({
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")
    crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "%m-%d")
    
    if(input$changeSeason == "Winter") {
      
      crime_data1 <- subset(crime_data, REPORT_DATE >= "2019-12-01")
      crime_data2 <- subset(crime_data, REPORT_DATE < "2019-03-01")
      crime_data <- rbind(crime_data1, crime_data2)
    }
    if(input$changeSeason == "Spring") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-03-01" & REPORT_DATE < "2019-06-01")
      
    }
    if(input$changeSeason == "Fall") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-03-01" & REPORT_DATE < "2019-06-01")
      
    }
    else {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-09-01" & REPORT_DATE < "2019-12-01")
      
    }
    
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")   
    crime_data <- crime_data %>% filter(CRIME_TYPE == input$Pick_Crime)
    crime_data_plot <- (barplot(crime_data$Precinct, xlab = "Precinct", ylab = "Frequency of Specified Crime", border = 'white' ))
    
    crime_data_plot
    
    
  })
  
  # Where the analysis is put together and presented.
  output$summaryText <- renderText({
    
    into_text <- "This is the intro text"
    some_value1 <- 1
    some_value2 <- 2
    ending_text <- "This is the ending text"
    
    paste(intro_text, some_value1, some_value2, ending_text)
  }) 
  
  # Table allows for crime by crime comparison of frequency during specific seasons
  output$crimeTable <- renderTable({
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")
    crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "%m-%d")
    
    if(input$changeSeason == "Winter") {
      
      crime_data1 <- subset(crime_data, REPORT_DATE >= "2019-12-01")
      crime_data2 <- subset(crime_data, REPORT_DATE < "2019-03-01")
      crime_data <- rbind(crime_data1, crime_data2)
      
    }
    if(input$changeSeason == "Spring") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-03-01" & REPORT_DATE < "2019-06-01")
      
    }
    if(input$changeSeason == "Fall") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-03-01" & REPORT_DATE < "2019-06-01")
      
    }
    else {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-09-01" & REPORT_DATE < "2019-12-01")
      
    }
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")   
    crime_data <- crime_data %>% filter(CRIME_TYPE == input$Pick_Crime)
    crime_data <- head( crime_data, n = 20 )
    
    crime_data
    
  })
  
})
