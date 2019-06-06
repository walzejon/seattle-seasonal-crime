library(shiny)

crime_data <- read.csv('Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv', header = TRUE,  stringsAsFactors = FALSE)

# format dates correctly for data
crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "%m/%d/%Y")
crime_data$REPORT_DATE <- as.Date(crime_data$REPORT_DATE, "$Y-%m-%d")


shinyUI(fluidPage(
  
  
  
  titlePanel("Seasonality of Crime in Seattle"),
  
  sidebarLayout(
    
    sidebarPanel(
      # All the inputs will go in side panel,
      ## the first will be a widget to select type of crime to look through
      
      selectInput("Pick_Crime", label = h3("Select Crime"),
                  choices = unique(crime_data$CRIME_TYPE, incomparables = FALSE),
                  selected = "Burglary"
      ),
      # the other will be to change season of year
      selectInput(
        inputId = "changeSeason", 
        label = "Select Season", 
        choices = c("Summer", "Fall", "Winter", "Spring"),
        selected = "Fall",
        multiple = FALSE
      )
    ),
    
    mainPanel(
      #In the main panel there will be three panels to go through for analysis
      tabsetPanel(
        
        # Plot and picture will show the distribution of crime, and how a specific precinct of Seattle has
        # more or less crime than another. Data will take into account user input of season and crime type, and 
        # the image will be to reference location of crimes to precinct
        tabPanel(
          "Plot", plotOutput("crimePlot"), 
          img(src='map.jpg')
        ), 
        
        # An introduction to the dataset, some analysis of the data, and possible implications of the analysis.
        tabPanel(
          "Summary", 
          
          p("Seattle is one of the most populated cities in America and as such deals with a lot of crime. In recent data collected from the Seattle Police Data (SPD) from 2008 to 2014, 
            data of crime type and their frequencies was linked to each sector. In Seattle, there are 5 police sectors: The North, West, East, SouthEast, and SouthWest, with the North being the largest sector.
            Tourism is another main staple of Seattle, and seasons like Summer and Spring display a larger amount of foot traffic, increased revenue, and of course drastic effects on crime.
            This analysis looks to analyze the various types of crime that take place in Seattle, as well as their seasonality - the change that occurs to their prevalence based off of season of the year."),
          
          textOutput("summaryText"),
          
          p("With this analysis we can further make judgements about the most ideal crime types to target, as well as provide the Seattle Police Department with ample evidence
            to inform their offices of the best times to target specific crimes, as well as in which region. By looking at this data we also indirectly come to informally define what stands as Tourist season in Seattle
            as some months of Spring and Summer do actually see reduced values for crime and foot traffic. This data analysis can be both interesting to consider as a tourist to Seattle, as well as a law enforcer trying to prevent crimes.
            Though it is impossible to definitively claim that this data will predict crime, this analysis can stand as a basis to understand broader patterns of crime that take place in the city of Seattle.")
          ), 
        # table will allow users to view around 15 observations of crime chosen for selected season. This will provide
        # data such as precinct, geographical location (through police beat coordinates), the report date, and how many times that crime was reported.
        tabPanel("Table", tableOutput("crimeTable"))
        
          )
      
          )
    
      )
  
  )
)