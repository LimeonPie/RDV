## app.R ##
library(shiny)
library(RMySQL)
library(ggplot2)
library(wordcloud)

source('./ui.r')
source('./dbQuery.r')
source('./processing.r')
source('./components.r')

# Des server details
# user="acp"
# password="acpdev16"
# dbname="acp_dev"
# host="46.101.153.165"
# port=3306

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
  
  # Getting start time of dataset
  minTimeQuery <- getMinValue(scheme$createTime)
  rs <- dbSendQuery(con, minTimeQuery)
  minTime <- fetch(rs, n=-1)
  startTime <- convertTime(minTime)
  dbClearResult(rs)
  
  # Getting end time of dataset
  maxTimeQuery <- getMaxValue(scheme$createTime)
  rs <- dbSendQuery(con, maxTimeQuery)
  maxTime <- fetch(rs, n=-1)
  endTime <- convertTime(maxTime)
  dbClearResult(rs)
  
  # Fetching all subreddits in this dataset
  subredditsQuery <- findUniqueValuesWithinTime(
    field = scheme$subreddit,
    timeFrom = minTime,
    timeBefore = maxTime
  )
  rs <- dbSendQuery(con, subredditsQuery)
  datasetSubreddits <- fetch(rs, n=-1)
  dbClearResult(rs)
  
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
  
  observeEvent(input$patternSelect, {
    # Filtering unique subreddits
    # and updating the subreddits input
    updateSelectizeInput(session, "subredditsInput", choices = datasetSubreddits$subreddit)
  })
  
  output$inputComponents <- renderUI(
    switch(input$patternSelect,
      "1" = {
        # Comment analysis input components
        getCommentAnalysisComponents(startTime$time, endTime$time)
      },
      "2" = {
        # Users analysis input components
        getUserAnalysisComponents(startTime$time, endTime$time)
      },
      "3" = {
        # Subreddit analysis input components
        getSubredditAnalysisComponents(startTime$time, endTime$time)
      },
      "4" = {
        # Subreddit relations input components
        getSubredditRelationsComponents(startTime$time, endTime$time)
      },
      "5" = {
        # Frequency of words input components
        getFrequencyComponents(startTime$time, endTime$time)
      },
      {
        # Default input components
      }
    )
  )
  
  output$plotUI <- renderUI({
    switch(input$patternSelect,
      "1" = {
        # Comment analysis plot UI
        getCommentAnalysisPlotUI()
      },
      "2" = {
        # Users analysis UI
        getUserAnalysisPlotUI()
      },
      "3" = {
        # Subreddit analysis UI
        getSubredditAnalysisPlotUI()
      },
      "4" = {
        # Subreddit relations UI
        getSubredditRelationsPlotUI()
      },
      "5" = {
        # Frequency of words UI
        getFrequencyPlotUI()
      },
      {
        # Default UI
      }
    )
  })
  
  # Launch Button onClick
  observeEvent(input$launchButton, {
    # Gathering input data
    
    # The main thing is pattern
    pattern <- input$patternSelect
    # Time is common component everywhere
    periodStart <- input$timeInput[1]
    periodStartPOSIX <- as.numeric(as.POSIXct(periodStart, tz = "UTC"))
    periodEnd <- input$timeInput[2]
    periodEndPOSIX <- as.numeric(as.POSIXct(periodEnd, tz = "UTC"))
    
    switch(pattern,
      "1" = {
        # Comment analysis
        print("Starting comment analysis")
        # Taking input parameters
        gilded <- input$isGilded
        keywords <- input$keywordsInput
        subreddits <- input$subredditsInput
        downVotesMin <- input$downs[1]
        downVotesMax <- input$downs[2]
        upVotesMin <- input$ups[1]
        upVotesMax <- input$ups[2]
        # Making query
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
      },
      "2" = {
        # Users analysis
        print("Starting users analysis")
        # Taking input parametres
        gilded <- input$isGilded
        keywords <- input$keywordsInput
        subreddits <- input$subredditsInput
        downVotesMin <- input$downs[1]
        downVotesMax <- input$downs[2]
        upVotesMin <- input$ups[1]
        upVotesMax <- input$ups[2]
        # Making query
        query <- usersAnalysis(
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
          mass <- createAmountFrame(data, "time")
          ggplot(data=mass, aes(x=time, y=freq, fill=time)) + 
            geom_bar(colour="black", width=.8, stat="identity") + 
            geom_label(aes(label = freq), size = 4) +
            guides(fill=FALSE) +
            xlab("Time") + ylab("Frequency") +
            ggtitle("Users Analysis")
        })
      },
      "3" = {
        # Subreddits analysis
        print("Starting subreddits analysis")
      },
      "4" = {
        # Subreddits relations
        print("Starting subreddits analysis")
      },
      "5" = {
        # Frequency of words
        print("Starting frequence of words")
        # Taking input parametres
        gilded <- input$isGilded
        keywords <- input$keywordsInput
        subreddits <- input$subredditsInput
        downVotesMin <- input$downs[1]
        downVotesMax <- input$downs[2]
        upVotesMin <- input$ups[1]
        upVotesMax <- input$ups[2]
        # Making a query
        query <- frequencyOfWords(
          gilded = as.numeric(gilded),
          downsMin = downVotesMin,
          downsMax = downVotesMax,
          upsMin = upVotesMin,
          upsMax = upVotesMax,
          timeFrom = periodStartPOSIX,
          timeBefore = periodEndPOSIX,
          subreddits = subreddits
        )
        print(query)
        res <- dbSendQuery(con, query)
        data <- fetch(res, n=-1)
        dbClearResult(res)
        
        corpus <- createCorpus(data, scheme$comment)
        output$graph <- renderPlot({
          wordcloud(
            corpus, 
            scale = c(3.5, 0.5),
            min.freq = input$frequencyMin,
            max.words = input$numberOfWordsMax, 
            random.order = FALSE,
            random.color = FALSE,
            colors = brewer.pal(8, "Dark2")
          )
        })
      },
      {
        # Default
      }
    )
  })
  
  # Cleanup after closing session
  session$onSessionEnded(function() {
    print("Session closed...")
    dbDisconnect(con)
  })
}

shinyApp(ui, server)