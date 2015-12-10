## app.R ##
library(shiny)

#setwd(dirname(sys.frame(1)$ofile))

source('./ui.r')

server <- function(input, output) { 
  set.seed(122)
  histdata <- rnorm(500)
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
}

shinyApp(ui, server)