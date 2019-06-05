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
    
    #Generates the sum of all crime commited in Seattle within user specified season of interest
    sum_all_crime <- input$changeSeason %>% 
      sum(crime_data$STAT_VALUE)
    
    #Generates the sum of specific crime within user specified season of interest
    sum_crime_selected <- input$changeSeason %>%
      filter(input$Pick_Crime) %>% 
      sum(input$STAT_VALUE)
    
    
  })
  
  # Where the analysis is put together and presented.
  output$summaryText <- renderText({
    
    #This generates the % of the specified crime type to the sum of all crime committed in specified season
    perc_crime_selected <- sum_crime_selected / sum_all_crime
    
    into_text <- paste("This map shows data of seasonal crime accross different precincts in 
    Seattle, WA from 2008 to present. The percentage of" + input$Pick_Crime + "crimes in Seattle, 
    on average, is" + perc_crime_selected + "in" + input$changeSeason + ".")
    
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
