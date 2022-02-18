library(shiny)
library(tidyverse)

### import and clean dataset
url <- "https://raw.githubusercontent.com/asouzujoseph/Dashboard/master/dataset.csv"
df <- data.frame(read.csv(url, skip=1)) #
climate <-as.tibble(df[1:10])
climate <- select(climate,-c("Temperature.1..C.","Temperature.2..c.","Valve.1.upper....","Valve.2.extra.under...."))
climate$Datetime <- as.POSIXct((climate$Datetime),format="%m/%d/%Y %M:%S",tz="UTC")
climate = climate %>% group_by(Day)%>%summarise_all(mean)
climate <- climate[-c(31:42),]

### build shiny app
ui <- fluidPage(
  titlePanel(h1("Smart Farm Analytics", align="center")),
  selectInput("xcol", "X Variable", choices = "Datetime", selected = names(climate)[[1]]),
  selectInput("ycol", "Choose Y variable", choices = names(climate), selected = names(climate)[[3]]),
  plotOutput("plot")
)

server <-function(input,output){
  selected_data <- reactive(climate[,c(input$xcol,input$ycol)])
  output$plot <- renderPlot({plot(selected_data(), lwd = 2, col='red',type="l")}, res = 96)
}

### run shiny app
shinyApp(ui,server)