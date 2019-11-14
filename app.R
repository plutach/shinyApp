library(shiny)
library(DBI)
library(pool)
library(dbplyr)

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
      
      # Output: Histogram ----
      plotOutput(outputId = "tbl"),
      
      #db output and table output
      tableOutput("tbl")
      

    )
  )
)


# Define server logic required to draw a histogram ----
server <- function(input, output, session) {

  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  
  #output$distPlot <- renderPlot({

  #   x    <- faithful$waiting
  #  bins <- seq(min(x), max(x), length.out = input$bins + 1)

  #  hist(x, breaks = bins, col = "#75AADB", border = "white",
  #       xlab = "Waiting time to next eruption (in mins)",
  #       main = "Histogram of waiting times")

  #  })
  
  output$tbl <- renderTable({
    conn <- dbConnect(
      drv = RPostgreSQL::PostgreSQL(),
      dbname = "logdb",
      host = "192.168.10.232",
      user = "postgres",
      password = "!123qwe")
    on.exit(dbDisconnect(conn), add = TRUE)
    dbGetQuery(conn, paste0(
      
      "SELECT station_id,log_dt,temp_val,gas_val FROM tbsensinglog_humetro WHERE site_id = 5 ORDER BY log_dt ASC LIMIT ", input$nrows, ";"))
    
  })


}

# Create Shiny app ----
shinyApp(ui = ui, server = server)