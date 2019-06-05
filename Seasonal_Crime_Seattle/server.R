library(shiny)
library(data.table)
library(lubridate)
library(dplyr)
library(ggplot2)
library(lubridate)
library(data.table)


#crime_data <- fread('../macuser/Desktop/info201/seattle-seasonal-crime/data/Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv', header = TRUE,  stringsAsFactors = FALSE)
crime_data <- fread('../data/Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv', header = TRUE,  stringsAsFactors = FALSE)


crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "%m/%d/%Y")
crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "$Y-%m-%d")

shinyServer(function(input, output) {
  
  output$crimePlot <- renderPlot({
    crime_data$REPORT_DATE <- format(temp, format="%m-%d")
    crime_data <- crime_data %>% filter(CRIME_TYPE == input$Pick_Crime)
    return (barplot(crime_data$Precinct, xlab = "Precinct", ylab = "Frequency of Specified Crime", border = 'white' ))
    
  })
  

    
    
    Regions <- c("N", "E", "W", "SE", "SW")
    N_crime_count <- 0
    W_crime_count <- 0
    E_crime_count <- 0
    SW_crime_count <- 0
    SE_crime_count <- 0
    
    
    for(i in nrow(crime_data)) {
      
      if(crime_data[i,7] == Regions[1]) {
        N_crime_count <- N_crime_count + 1
        
      }
      if(crime_data[i,7] == Regions[2]) {
        E_crime_count <- E_crime_count + 1
        
      }
      if(crime_data[i,7] == Regions[3]) {
        W_crime_count <- w_crime_count + 1
        
      }
      if(crime_data[i,7] == Regions[4]) {
        SE_crime_count <- SE_crime_count + 1 
        
      }
      if(crime_data[i,7] == Regions[5]) {
        SW_crime_count <- SW_crime_count + 1
        
      }
    }
    
    crime_count <- c(N_crime_count, E_crime_count, W_crime_count, SW_crime_count, SE_crime_count)
    
    df <- data.frame(SeattleRegions=Regions, SeattleCount=crime_count)
    
    
    
    crime_data_plot <- ggplot(data=df, aes(x=SeattleRegions, y=SeattleCount)) +
      geom_bar(stat="identity", fill="steelblue")
    # geom_text(aes(label=Sightings), vjust=1.0, color="white", size=3.5)
    
    
    
    crime_data_plot
    
    
  })
  
  #Where the analysis is put together and presented.
  output$summaryText <- renderText({
    
    
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
    #Generates the sum of all crime commited in Seattle within user specified season of interest
    sum_all_crime <- sum(crime_data$STAT_VALUE)
    
    #filter for crime that is picked
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")   
    crime_data <- crime_data %>% filter(CRIME_TYPE == input$Pick_Crime)
    
    #Generates the sum of specific crime within user specified season of interest
    sum_crime_selected <- sum(crime_data$STAT_VALUE)
    
    #This generates the % of the specified crime type to the sum of all crime committed in specified season
    perc_crime_selected <- round( (sum_crime_selected / sum_all_crime) * 100, digits = 1)
    
    
    intro_text <- paste("This map shows data of seasonal crime accross different precincts in \n Seattle, WA from 2008 to 2014. \nThe percentage of", input$Pick_Crime,  "crimes in Seattle, 
                    on average, is", perc_crime_selected,  " % in", input$changeSeason , ".")
    
    intro_text
    
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
    crime_data$REPORT_DATE <- format(crime_data$REPORT_DATE, format="%m-%d")   
    crime_data <- crime_data %>% filter(CRIME_TYPE == input$Pick_Crime)
    
    crime_data <- head( crime_data, n = 20 )
    
    crime_data 
    
  })
  

