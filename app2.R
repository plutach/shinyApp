library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")

con <- dbConnect(PostgreSQL(),host='192.168.10.232',user='postgres',password='!123qwe',dbname='sidp_lotte')
rs <- dbSendQuery(con, "Select station_id,log_dt,temp_val,gas_val,battery_level from tbsensinglog where log_dt between '2019-02-03' and '2019-02-04'");
ds <- fetch(rs, n=-1)

dst_station <- subset(dataset_lotte ["station_id"])


library(shiny)
library(plotly)
library(ggplot2)

ui <- fluidPage(
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "y",
                  label="Y-axis:",
                  choices = c("temp_val","gas_val"),
                  selected ="temp_val"),
      selectInput(inputId = "x",
                  label="X-axis:",
                  choices = c("log_dt"),
                  selected ="log_dt"),
    
    selectInput(inputId = "z", 
                label = "select station_id",
                choices = dataset_lotte$station_id, 
                selected = "select"),
    
    #date range input
    dateRangeInput(inputId = "dates", 
                   "Date range",
                   start = as.character(Sys.Date()) , 
                   end = as.character(Sys.Date())),
    
    br(),
    
    submitButton("Update")
    ),
    
    mainPanel(plotOutput(outputId = "qplot")
  )
)
)
  
server <- function(input,output){

output$qplot <- renderPlot({ 
ggplot(data=dataset_lotte, aes_string(x=input$x, y=input$y, z=input$z, color=input$y)) + 
#geom_point()
geom_line()
})



}

shinyApp(ui, server)



======================================================================================================================================================================



library(RPostgreSQL)
drv <- dbDriver("PostgreSQL")

con <- dbConnect(PostgreSQL(),host='192.168.10.232',user='postgres',password='!123qwe',dbname='sidp_lotte')
rs <- dbSendQuery(con, "Select station_id,log_dt,temp_val,cid,gas_val,battery_level from tbsensinglog where site_id=3");
dataset_lotte <- fetch(rs, n=-1);



con <- dbConnect(PostgreSQL(),host='192.168.10.232',user='postgres',password='!123qwe',dbname='sidp_lotte')
rs <- dbSendQuery(con, "Select station_id,log_dt,temp_val,gas_val,battery_level from tbsensinglog where log_dt between '2019-02-03' and '2019-02-04'");
ds <- fetch(rs, n=-1)



#subsets
dataset_stdt <- subset(dataset_lotte, station_id==70125 & log_dt > "2019-02-03" & log_dt < "2019-02-05")

#subsets
dataset_stations <- subset(dataset_lotte["station_id"])

library(shiny)
library(ggplot2)
library(plotly)
#dataset_station <- subset(dataset_lotte, station_id)library(ggplot2)

#runExample("01_hello")

# Define UI for app that draws a histogram ----
ui <- fluidPage(
  
  # App title ----
  titlePanel("data analysis of Lotte"),
  
  #sidebarlayout with a input and output definitions
  sidebarLayout(
    
    sidebarPanel(
      
      #select variable for y-axis
      selectInput(inputId = "y",
                  label = "Y-axis:",
                  choices = c("temp_val", "gas_val", "battery_level"), 
                  selected = "temp_val"
      ),
      # select variable for x-axis
      selectInput(inputId = "x", 
                  label = "X-axis:",
                  choices = c("log_dt"), 
                  selected = "log_dt"),
      
      #select station_id
      selectInput(inputId = "z", 
                  label = "station_id",
                  choices = ds$station_id, 
                  selected = "select"),
      
      #date range input
      dateRangeInput('dateRange',
                     label = 'Date range input',
                     start = Sys.Date() - 2, 
                     end = Sys.Date() + 2
      ),
      
      
      submitButton("Update")
    
  ),
  
  mainPanel(
    plotOutput(outputId = "scatterplot")
  )
)
)

#server <- function(input,output) {
#  output$scatterplot <- renderPlot({ 
#    ggplot(data=dataset_lotte, aes_string(x=input$x, y=input$y)) + 
#      geom_point()
  
server <- function(input,output) {
  output$scatterplot <- renderPlot({ 
    ggplot(data=ds, aes_string(x=input$x, y=input$y, z=input$z, color=input$y)) + 
      #geom_point()
      geom_line()
    
  })
}
shinyApp(server=server, ui=ui)
