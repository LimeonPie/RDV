## app.R ##
library(shiny)
library(RMySQL)
library(ggplot2)

source('./ui.r')
source('./dbQuery.r')
source('./processing.r')

server <- function(input, output, session) {
  # Insert your user and password
  con <- dbConnect(
    MySQL(),
    user="acp", 
    password="acpdev16",
    dbname="acp_dev", 
    host="46.101.153.165", 
    port=3306
  )
  
  observe({
    # Filtering unique subreddits
    # and updating the subreddits input
    subredditsQuery <- findUniqueValues(scheme$subreddit)
    res <- dbSendQuery(con, subredditsQuery)
    subreddits <- fetch(res, n=-1)
    dbClearResult(res)
    updateSelectizeInput(session, "subredditsInput", choices = subreddits$subreddit)
  })
  
  output$patternDescription <- renderText({
    switch(input$patternSelect,
      "1" = "Comment analysis description",
      "2" = "Users analysis description",
      "3" = "Subreddit analysis description",
      "4" = "Subreddit relations description",
      "5" = "Frequency of words description",
      "Default description"
    )
  })
  
  # Launch Button onClick
  observeEvent(input$launchButton, {
    # Gathering input data
    gilded <- input$isGilded
    keywords <- input$keywordsInput
    subreddits <- input$subredditsInput
    periodStart <- input$dates[1]
    periodStartPOSIX <- as.numeric(as.POSIXct(periodStart, tz = "UTC"))
    periodEnd <- input$dates[2]
    periodEndPOSIX <- as.numeric(as.POSIXct(periodEnd, tz = "UTC"))
    pattern <- input$patternSelect
    downVotesMin <- input$downs[1]
    downVotesMax <- input$downs[2]
    upVotesMin <- input$ups[1]
    upVotesMax <- input$ups[2]
    
    query <- commentAnalysis(
      gilded = as.numeric(gilded),
      downsMin = downVotesMin,
      downsMax = downVotesMax,
      upsMin = upVotesMin,
      upsMax = upVotesMax,
      timeFrom = periodStartPOSIX,
      timeBefore = periodEndPOSIX,
      subreddits = subreddits,
      keywords = keywords
    )
    print(query)
    res <- dbSendQuery(con, query)
    data <- fetch(res, n=-1)
    data <- convertTime(data)
    print(head(data))
    dbClearResult(res)
    
    #plotting
    output$graph <- renderPlot({
      if (input$separateSubreddits == FALSE) {
        # All results
        mass <- createAmountFrame(data, "time")
        if (input$plotSelect == "1") {
          ggplot(data=mass, aes(x=time, y=freq, fill=time)) + 
            geom_bar(colour="black", width=.8, stat="identity") + 
            geom_label(aes(label = freq), size = 4) +
            guides(fill=FALSE) +
            xlab("Time") + ylab("Frequency") +
            ggtitle("Comment Analysis")
        }
        else if (input$plotSelect == "2") {
          ggplot(data=mass, aes(x=factor(time), y=freq, group = 1)) +  
            geom_line() + geom_point() +
            xlab("Time") + ylab("Frequency") +
            ggtitle("Comment Analysis")
        }
      }
      else {
        # Separating results by subreddits
        mass <- createAmountFrame(data, c("subreddit", "time"))
        if (input$plotSelect == "1") {
          ggplot(data=mass, aes(x=time, y=freq, fill=subreddit)) + 
            geom_bar(colour="black", width=.8, stat="identity") + 
            xlab("Time") + ylab("Frequency") +
            ggtitle("Comment Analysis by subreddits")
        }
        else if (input$plotSelect == "2") {
          ggplot(data=mass, aes(x=factor(time), y=freq, group=subreddit, colour=subreddit, shape=subreddit)) +  
            geom_line() + geom_point() +
            xlab("Time") + ylab("Frequency") +
            ggtitle("Comment Analysis")
        }
      }
    })
  })
  
  # Cleanup after closing session
  session$onSessionEnded(function() {
    print("Session closed...")
    dbDisconnect(con)
  })
}

shinyApp(ui, server)