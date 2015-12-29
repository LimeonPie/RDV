## app.R ##
library(shiny)
library(RMySQL)

source('./ui.r')

server <- function(input, output, session) {
  # Insert your user and password
  con <- dbConnect(MySQL(),
                   user="acp", password="acpdev16",
                   dbname="acp_dev", host="46.101.153.165", port=3306)
  
  set.seed(122)
  histdata <- rnorm(500)
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    hist(data)
  })
  
  # Cleanup after closing session
  session$onSessionEnded(function() {
    dbDisconnect(con)
  })
}

shinyApp(ui, server)