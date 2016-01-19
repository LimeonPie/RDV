## app.R ##
library(shiny)
library(RMySQL)

source('./ui.r')
source('./dbQuery.r')

server <- function(input, output, session) {
  # Insert your user and password
  con <- dbConnect(MySQL(),
                   user="acp", password="acpdev16",
                   dbname="acp_dev", host="46.101.153.165", port=3306)
  #query <- createQuery(0, 0, 0, 100, 0, 100, c("do", "yes", "no"))
  query <- commentAnalysis(0, 0, 100, 0, 100, 0, 100, c("know"))
  print(query)
  rs <- dbSendQuery(con, query)
  data <- fetch(rs, n=-1)
  print(data)
  dbClearResult(rs)
  
  # Cleanup after closing session
  session$onSessionEnded(function() {
    print("Session closed...")
    dbDisconnect(con)
  })
}

shinyApp(ui, server)