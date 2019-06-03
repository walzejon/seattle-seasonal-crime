library(shiny)

shinyUI(fluidPage(
  
  
  titlePanel("Seasonality of Crime in Seattle"),
  
  sidebarLayout(
    
    sidebarPanel(
      # All the inputs will go in side panel, right now I have basic inputs as placeholders (although selectinput works pretty well)
      dateRangeInput(
        inputId = "setDate",
        label = "Range of observation:", 
        start = "2008-01-01", 
        end = "2014-04-30",
        min = "2008-01-01",
        max = "2014-04-30"
        # start/end are values that can be changed & min./max are the furthest options you can choose
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
        
        tabPanel("Plot", plotOutput("crimePlot"), img(src='~/../../Documents/seattle-seasonal-crime/data/myImage.png', align = "right"), 
        tabPanel("Summary", textOutput("summaryText")), 
        tabPanel("Table", tableOutput("crimeTable"))
      )
      
    )
    
  )
  
 )
 
)