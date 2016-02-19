## app.R ##
library(shiny)
library(RMySQL)
library(ggplot2)
library(wordcloud)
library(networkD3)

source('./ui.r')
source('./dbQuery.r')
source('./processing.r')



server <- function(input, output, session) {
  startTime <- Sys.time()
  
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
  output$plotUI <- renderUI({
    #the node chart for subreddit relations requires networkplot
    if(input$patternSelect == "4"){
      simpleNetworkOutput("network", height = 250)
    } else {
      plotOutput(
        "graph",
        height = 250
      )
    }
  })
  

  #if(timer_variable == '1'){
  #  output$timer <- renderText({
  #    sprintf("% s", i)
  #    print(i)
  #    i <<- i + 1
  #    invalidateLater(1000, session)
  #  })
  #}

  
  output$settingsUI <- renderUI({
    switch(input$patternSelect,
      "1" = {
        # Comment analysis UI
        tagList(
          selectInput(
            'plotSelect',
            label = h4("Plot type"),
            choices = list(
              "Bar chart" = 1, 
              "Line chart" = 2
            ),
            selected = 1
          ),
          checkboxInput(
            "separateSubreddits", 
            label = "Separate subreddits", 
            value = FALSE
          ),
          sliderInput(
            "slider", 
            label = h4("Time period"), 
            min = 0, 
            max = 100, 
            value = c(0, 100)
          )
        )
        
      },
      "2" = {
        # Users analysis UI
      },
      "3" = {
        # Subreddit analysis UI
      },
      "4" = {
        # Subreddit relations UI
      },
      "5" = {
        # Frequency of words UI
        tagList(
          sliderInput(
            "frequencyMin",
            label = h4("Minimum frequency:"),
            min = 1,  
            max = 50, 
            value = 15
          ),
          sliderInput(
            "numberOfWordsMax",
            label = h4("Maximum number of words:"),
            min = 1,  
            max = 100,
            value = 50
          )
        )
      },
      {
        # Default UI
      }
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
    relation <- input$percentage

    
    switch(pattern,
      "1" = {
        # Comment analysis
        print("Starting comment analysis")
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
        output$query_info <-renderText({query
        })
        output$query_results <-renderDataTable({data
        })
        
        
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
      },
      "3" = {
        # Subreddits analysis
      },
      "4" = {
        # Subreddits relations
        print("Starting subreddits relations analysis")
        timer_variable <<- '1'
        query <- subredditsRelations(
          gilded = as.numeric(gilded),
          downsMin = downVotesMin,
          downsMax = downVotesMax,
          upsMin = upVotesMin,
          upsMax = upVotesMax,
          timeFrom = periodStartPOSIX,
          timeBefore = periodEndPOSIX,
          subreddits = subreddits,
          keywords = keywords,
          percentage = relation
        )
        
        timer_variable <<- '0'
        res <- dbSendQuery(con, query)
        data <- fetch(res, n=-1)
        print(head(data))
        dbClearResult(res)
        print(data)
        
        output$query_info <-renderText({query
        })
        output$query_results <-renderDataTable({data
        })
        
        #plotting
        output$network <- renderSimpleNetwork({
          subreddits_a <- data$subreddit_a
          subreddits_b <- data$subreddit_b
          networkData <- data.frame(subreddits_a, subreddits_b)
          simpleNetwork(networkData, fontSize = 20)
        })
      },
      "5" = {
        # Frequency of words
        print("Starting frequence of words")
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
        output$query_info <-renderText({query
        })
        output$query_results <-renderDataTable({data
        })
        
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
    endTime <- Sys.time()
    print("Session closed...")
    print(endTime - startTime)
    dbDisconnect(con)
  })
}

shinyApp(ui, server)