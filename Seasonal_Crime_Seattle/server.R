library(shiny)
library(data.table)
library(lubridate)
library(dplyr)
library(ggplot2)
library(lubridate)

crime_data <- read.csv('Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv', header = TRUE,  stringsAsFactors = FALSE)

crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "%m/%d/%Y")
crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "$Y-%m-%d")

shinyServer(function(input, output) {
  
  # where main visual data is presented alongside map showing the precincts.
  output$crimePlot <- renderPlot({
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")
    crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "%m-%d")
    
    
    # filtering done for season chosen from input
    if(input$changeSeason == "Winter") {
      
      crime_data1 <- subset(crime_data, REPORT_DATE >= "2019-12-01")
      crime_data2 <- subset(crime_data, REPORT_DATE < "2019-03-01")
      crime_data <- rbind(crime_data1, crime_data2)
    }
    if(input$changeSeason == "Spring") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-03-01" & REPORT_DATE < "2019-06-01")
      
    }
    if(input$changeSeason == "Fall") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-09-01" & REPORT_DATE < "2019-12-01")
      
    }
    if(input$changeSeason == "Summer") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-06-01" & REPORT_DATE < "2019-09-01")
      
    }
    
    # reformatting and filtering done based on chosen crime type
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")   
    crime_data <- crime_data %>% filter(CRIME_TYPE == input$Pick_Crime)
    
    #region specific crime counts collected
    west_crime_data <- crime_data %>% filter(Precinct == "W")
    west_sum_crime <- sum(west_crime_data$STAT_VALUE)
    
    east_crime_data <- crime_data %>% filter(Precinct == "E")
    east_sum_crime <- sum(east_crime_data$STAT_VALUE)
    
    north_crime_data <- crime_data %>% filter(Precinct == "N")
    north_sum_crime <- sum(north_crime_data$STAT_VALUE)
    
    southW_crime_data <- crime_data %>% filter(Precinct == "SW")
    southW_sum_crime <- sum(southW_crime_data$STAT_VALUE)
    
    southE_crime_data <- crime_data %>% filter(Precinct == "SE")
    southE_sum_crime <- sum(southE_crime_data$STAT_VALUE)
    
    crime_count <- c(north_sum_crime, west_sum_crime,east_sum_crime, southW_sum_crime, southE_sum_crime)
    
    Regions <- c("N", "E", "W", "SE", "SW")
    
    df <- data.frame(SeattleRegions=Regions, SeattleCount=crime_count)
    
    
    # plot of regions and their crime counts made (simple distribution plot)
    crime_data_plot <- ggplot(data=df, aes(x=SeattleRegions, y=SeattleCount, fill = SeattleRegions)) +
      geom_bar(stat="identity") +
      scale_fill_manual(breaks = c("E", "N", "SE", "SW", "W"), 
                        values=c("#13a516", "#f0091b", "#83127c", "#915c0e", "#0905cc"))
    
    
    
    crime_data_plot
    
    
  })
  
  #Where the analysis is put together and presented.
  output$summaryText <- renderText({
    
    # filtering for chosen season
    if(input$changeSeason == "Winter") {
      
      crime_data1 <- subset(crime_data, REPORT_DATE >= "2019-12-01")
      crime_data2 <- subset(crime_data, REPORT_DATE < "2019-03-01")
      crime_data <- rbind(crime_data1, crime_data2)
    }
    if(input$changeSeason == "Spring") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-03-01" & REPORT_DATE < "2019-06-01")
    }
    if(input$changeSeason == "Fall") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-09-01" & REPORT_DATE < "2019-12-01")
    }
    if(input$changeSeason == "Summer") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-06-01" & REPORT_DATE < "2019-09-01")
      
    }
    
    #Generates the sum of all crime commited in Seattle within user specified season of interest
    sum_all_crime <- sum(crime_data$STAT_VALUE)
    
    #filter for crime that is picked
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")   
    crime_data <- crime_data %>% filter(CRIME_TYPE == input$Pick_Crime)
    
    #Generates the sum of specific crime within user specified season of interest
    sum_crime_selected <- sum(crime_data$STAT_VALUE)
    
    #Generates the % of the specified crime type to the sum of all crime committed in specified season
    perc_crime_selected <- round( (sum_crime_selected / sum_all_crime) * 100, digits = 1)
    
    # simple analysis text
    analysis_text <- paste("This analysis shows data of seasonal crime accross different precincts in \n Seattle, WA. \nThe percentage of", input$Pick_Crime,  "crimes in Seattle, 
                           on average, is", perc_crime_selected,  " % in", input$changeSeason , ". There were, ", sum_crime_selected, "of" , input$Pick_Crime, "type crimes and ", sum_all_crime, " total \ncrimes
                           from 2008 to 2014")
    analysis_text
    
  }) 
  
  # Table allows for crime by crime comparison of frequency during specific seasons
  output$crimeTable <- renderTable({
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")
    crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "%m-%d")
    
    #filtering for chosen season
    if(input$changeSeason == "Winter") {
      
      crime_data1 <- subset(crime_data, REPORT_DATE >= "2019-12-01")
      crime_data2 <- subset(crime_data, REPORT_DATE < "2019-03-01")
      crime_data <- rbind(crime_data1, crime_data2)
      
    }
    if(input$changeSeason == "Spring") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-03-01" & REPORT_DATE < "2019-06-01")
      
    }
    if(input$changeSeason == "Fall") {
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-09-01" & REPORT_DATE < "2019-12-01")
      
    }
    if(input$changeSeason == "Summer"){
      
      crime_data <- subset(crime_data, REPORT_DATE >= "2019-06-01" & REPORT_DATE < "2019-09-01")
      
    }
    # filtering for user-selected crime type
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")   
    crime_data <- crime_data %>% filter(CRIME_TYPE == input$Pick_Crime)
    # data shortened to 15 cases to be viewable
    crime_data <- head( crime_data, n = 15 )
    
    crime_data 
    
  })
  
})