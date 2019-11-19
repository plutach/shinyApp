library(shiny)
library(DBI)
library(pool)
library(dplyr)
library(RPostgreSQL)
library(magrittr)


pool <- dbPool(
  drv = RPostgreSQL::PostgreSQL(),
  dbname = "logdb",
  host = "localhost",
  user = "postgres",
  password = "123123"
 )



# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("Shiny App for Sensor Data Virtualization"),
  
  # Sidebar layout with input and output definitions ----
  sidebarLayout(
    
    # Sidebar panel for inputs ----
    sidebarPanel(
      
      # Input: Slider for the number of bins ----
      sliderInput(inputId = "bins",
                  label = "Number of bins:",
                  min = 5,
                  max = 50,
                  value = 30),
      #date input
      dateRangeInput(inputId = "dates",
                     label = "Input date range"),
      
      #select temperature/ gas
      radioButtons(inputId = "select",
                   label = "select sensory type",
                   choices = list("Temperature" = 1, "Gas" = 2)),
      
      #db output and table output
      numericInput("nrows", "Enter the number of rows to display:", 5),
      
      
      
    ),
    
    
    # Main panel for displaying outputs ----
    mainPanel(
      #EX : img(src = "rstudio.png", height=140, width=400) 
      
      
      #db output and table output
      tableOutput("tbl"),
      # Output: Histogram ----
      plotOutput("popPlot")
      
      
    )
  )
)


# Define server logic required to draw a histogram ----
server <- function(input, output, session) {
  
  output$tbl <- renderTable({
    pool %>% tbl("tbsensinglog_humetro") %>% head(5)
  })
  
  
  output$popPlot <- renderPlot({
    
    df <- pool %>% tbl("tbsensinglog_humetro") %>%
      head(as.integer(input$dates)[1]) %>% collect()
    Date <- df$log_dt
    Temperature <- df$temp_val
    qqplot(Date,Temperature)
  })
  
  
}

# Create Shiny app ----
shinyApp(ui = ui, server = server)
