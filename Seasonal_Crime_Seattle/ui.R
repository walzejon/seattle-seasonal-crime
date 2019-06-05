library(shiny)

#crime_data <- fread('../macuser/Desktop/info201/seattle-seasonal-crime/data/Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv', header = TRUE,  stringsAsFactors = FALSE)
crime_data <- fread('../data/Seattle_Crime_Stats_by_Police_Precinct_2008-Present.csv', header = TRUE,  stringsAsFactors = FALSE)

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
        choices = c("Winter", "Spring", "Summer", "Fall"),
        selected = "Winter",
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
        
        tabPanel("Plot", plotOutput("crimePlot"), 
                 img(src='~/../../Documents/seattle-seasonal-crime/data/map.jpeg', align = "right")), 
        tabPanel("Summary", textOutput("summaryText")), 
        tabPanel("Table", tableOutput("crimeTable"))
        
      )
      
    )
    
  )
  
 )
)
