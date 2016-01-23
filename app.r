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
  query <- createQuery(0, 0, 0, 100, 0, 100, c("do", "yes", "no"))
  print(query)
  rs <- dbSendQuery(con, query)
  data <- fetch(rs, n=-1)
  print(data)
  dbClearResult(rs)
  
  
  comments <- dbGetQuery(con, commentsQuery)
  users <- dbGetQuery(con, usersQuery)
  
  #plots the comments per day
  output$comment_analysis <- renderPlot({
    plot(as.Date(comments$`date`), comments$`comments`, xlab = "time", ylab = "comments")
    
  })
  #plots the new users per day
  output$users_analysis <- renderPlot({
    plot(as.Date(users$`date`), users$`users`, xlab = "time", ylab = "users")
    
  })
  
  # Cleanup after closing session
  session$onSessionEnded(function() {
    print("Session closed...")
    dbDisconnect(con)
  })
}

shinyApp(ui, server)