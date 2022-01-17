library(shiny)
library(ggplot2)
library(tidyverse)

### import and clean dataset
url <- "https://raw.githubusercontent.com/asouzujoseph/Dashboard/master/dataset.csv"
df <- data.frame(read.csv(url, skip=1)) #
climate <-as.tibble(df[1:10])
climate$Datetime <- as.POSIXct((climate$Datetime),format="%m/%d/%Y %M:%S",tz="UTC")
head (climate)
tail(climate)
#### design the user interface of the shiny app
ui <- fluidPage(
  titlePanel(h1("Smart Farm Analytics", align="center")),
  selectInput("xcol", "X Variable", choices = names(climate), selected = names(climate)[[1]]),
  selectInput("ycol", "Y Variable", choices = names(climate), selected = names(climate)[[3]]),
  plotOutput("plot")
)

#### design the server segment / backend of the shiny app
server <- function(input, output, session) {
      selected_data <- reactive(climate[,c(input$xcol,input$ycol)])
      output$plot <- renderPlot({plot(selected_data (), lwd = 2, col='red',type="p")}, res = 96) 
  }


### Launch the app
shinyApp(ui, server)
