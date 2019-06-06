library(shiny)

#crime_data <- fread('../macuser/Desktop/info201/seattle-seasonal-crime/data/Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv', header = TRUE,  stringsAsFactors = FALSE)
#crime_data <- fread('../data/Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv', header = TRUE,  stringsAsFactors = FALSE)
crime_data <- fread('~/../../Documents/seattle-seasonal-crime/data/Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv', header = TRUE,  stringsAsFactors = FALSE)


crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "%m/%d/%Y")
crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "$Y-%m-%d")


shinyUI(fluidPage(
  
  
  
  titlePanel("Seasonality of Crime in Seattle"),
  
  sidebarLayout(
    
    sidebarPanel(
      # All the inputs will go in side panel, right now I have basic inputs as placeholders (although selectinput works pretty well)
      selectInput("Pick_Crime", label = h3("Select Crime"),
                  choices = unique(crime_data$CRIME_TYPE, incomparables = FALSE),
                  selected = "Burglary"
      ),
      
      selectInput(
        inputId = "changeSeason", 
        label = "Select Season", 
        choices = c("Summer", "Fall", "Winter", "Spring"),
        selected = "Fall",
        multiple = FALSE
        # not sure if choices/selected works with strings like that but can test that later
      )
    ),
    
    mainPanel(
      #In the main panel there will be three panels to go through for analysis
      tabsetPanel(
        
        # A plot (probably a map) that shows trends/relationships/density/whatever, a summary page
        # that has values in summary change based off of inputs, and a table which will just be selected data 
        # from the data frame represented as a table. 
        
        tabPanel(
          "Plot", plotOutput("crimePlot"), 
          img(src='/map.jpg')
        ), 
        tabPanel(
          "Summary", 
          
          p("Seattle is one of the most populated cities in America and as such deals with a lot of crime. In recent data collected from the Seattle Police Data (SPD) from 2008 to 2014, 
            data of crime type and their frequencies was linked to each sector. In Seattle, there are 5 police sectors: The North, West, East, SouthEast, and SouthWest, with the North biggest the largest sector.
            Tourism is another main staple of Seattle, and seasons like Summer and Spring display a larger amount of foot traffic, increased revenue, and of course drastic effects on crime.
            This analysis looks to analyze the various types of crime that take place in Seattle, as well as their seasonality - the change that occurs to their prevalence based off of season of the year."),
          
          textOutput("summaryText"),
          
          p("With this analysis we can further make judgements about the most ideal crime types to target, as well as provide the Seattle Police Department with amply evidence
            to inform the best seasons to target crime especially. By looking at this data we also indirectly come to informally define what stands as Tourist season in Seattle as some months of Spring and Summer do actually see reduced
            values for crime. This data analysis can be both interesting to consider as a Tourist to Seattle, as well as a law enforcer trying to prevent crimes. Though it is impossible to definitively claim that this data will predict crime, 
            it can stand as a basis to understand broader patterns of crime that take place in the city of Seattle.")
          ), 
        
        tabPanel("Table", tableOutput("crimeTable"))
        
          )
      
          )
    
      )
  
  )
)