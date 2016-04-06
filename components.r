## components.r ##
## Return UI components for specific issue ##

strings <- list(
  description = "Description",
  timePeriodTitle = "Time period",
  timePeriodDesc = "Select time period",
  goldTitle = "Gold status",
  goldDesc = "Gilded",
  subredditsTitle = "Subreddits",
  subredditsDesc = "Select subreddits",
  keywordsTitle = "Keywords",
  authorsTitle = "Authors",
  authorsDesc = "List authors",
  keywordsDesc = "List keywords"
) 

getCommentAnalysisComponents <- function(startTime, endTime) {
  return(
    tagList(
      fluidRow(
        box(
          title = strings$timePeriodTitle,
          status = "danger",
          dateRangeInput(
            "timeInput",
            label = h4(strings$timePeriodDesc),
            start = startTime,
            end = endTime,
            format = "dd/mm/yy",
            min = startTime, 
            max = endTime
          ),
          h5("Warning! Selecting a long perioid will gradually affect processing time.")
        ),
        box(
          title = strings$subredditsTitle,
          status = "primary",
          selectizeInput(
            'subredditsInput',
            label = h4(strings$subredditsDesc),
            choices = c(), 
            multiple = TRUE,
            options = list(
              create = TRUE, 
              maxItems = 10000, 
              placeholder = '/r/...'
            )
          )
        )
      ),
      
      fluidRow(
        box(
          title = strings$keywordsTitle,
          status = "primary",
          selectizeInput(
            'keywordsInput',
            label = h4(strings$keywordsDesc),
            choices ="",
            multiple = TRUE,
            options = list(
              create = TRUE, 
              maxItems = 10000, 
              placeholder = 'Keywords'
            )
          )
        ),
        box(
          title = strings$authorsTitle,
          status = "primary",
          selectizeInput(
            'authorsInput',
            label = h4(strings$authorsDesc),
            choices ="",
            multiple = TRUE,
            options = list(
              create = TRUE, 
              maxItems = 10000, 
              placeholder = 'Authors'
            )
          )
        )
      ),
      
      fluidRow(
        box(
          title = "Upvotes range",
          status = "primary",
          radioButtons("enableRange", label = NULL, choices = list("All comments" = 0, " Select range:" = 1)),
          uiOutput("upvotesUI")
        ),
        box(
          title = strings$goldTitle,
          status = "primary",
          radioButtons(
            "isGilded",
            label = h4(strings$goldDesc),
            choices = list(
              "All" = 1, 
              "Yes" = 2, 
              "No" = 3
            ), 
            selected = 1
          )
        )
        #box(
        #  title = "Upvotes",
        #  status = "primary",
        #  sliderInput(
        #    "ups", 
        #    label = h4("Select a range of upvotes"), 
        #    min = -50, 
        #    max = 50, 
        #    value = c(-50, 50)
        #  )
      ),
      fluidRow(
        column(width = 4),
        column(
          width = 4,
          offset = 0,
          align = "center",
          bsButton("plotButton", label = "Plot", size = "large", style = "success")),
        column(width = 4)
      )
    )
  )
}

getCommentAnalysisPlotUI <- function() {
  return(
    tagList(
      fluidRow(
        box(
          title = "Plot",
          width = 8,
          status = "primary", 
          solidHeader = TRUE,
          plotOutput(
            "graph", 
            height = 250
          )
        ),
        box(
          title = "Settings",
          status = "primary",
          solidHeader = TRUE,
          width = 4,
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
          br(),
          bsButton(
            "downloadPlot", 
            label = "Save",
            icon = icon("floppy-save", lib = "glyphicon"),
            size = "large"
          )
        )
      ),
      fluidRow(
        box(
          title = "Additional information",
          width = 12,
          status = "info",
          solidHeader = TRUE,
          selectInput(
            'infoSelect', 
            label = NULL,
            choices = list(
              "Empty" = 1, 
              "Show query" = 2, 
              "Show query results" = 3
            ),
            selected = 1
          ),
          uiOutput("queryInfoUI")
        )
      ),
      fluidRow(
        column(width = 4),
        column(
          width = 4,
          offset = 0,
          align = "center",
          bsButton("backButton", label = "Back", size = "large", style = "danger")),
        column(width = 4)
      )
    )
  )
}

getSubredditRelationsComponents <- function(startTime, endTime) {
  return(
    tagList(
      fluidRow(
        box(
          title = "Shared commenters",
          status = "primary",
          sliderInput(
            "percentage",
            label = h4("Select percentage"),
            min = 0,
            max = 100,
            value = 10
          )
        ),
        box(
          title = "The minimum size of a subreddit",
          status = "primary",
          numericInput("minSubredditSize", label = h4("Select min size"), min = 1, value = 5)
        )
        
        #is it better if we combine relations spesific settings to one box with two tabs?
        #tabBox(
        #  title = "Subreddit settings",
        #  tabPanel(
        #    "Percentage",
        #    sliderInput(
        #      "Percentage",
        #      label = h4("Select percentage"),
        #      min = 0,
        #      max = 100,
        #      value = 10
        #    )
        #    
        #  ),
        #  tabPanel(
        #    "Min size",
        #    numericInput("minSubredditSize", label = h4("Min size"), min = 1, value = 5)
        #  )
        #)
      ),
      
      fluidRow(
        box(
          title = strings$timePeriodTitle,
          status = "danger",
          dateRangeInput(
            "timeInput",
            label = h4(strings$timePeriodDesc),
            start = startTime,
            end = endTime,
            format = "dd/mm/yy",
            min = startTime, 
            max = endTime
          ),
          h5("Warning! Selecting a long period will gradually affect processing time.")
        ),
        box(
          title = strings$subredditsTitle,
          status = "primary",
          selectizeInput(
            'subredditsInput',
            label = h4(strings$subredditsDesc),
            choices = c(), 
            multiple = TRUE,
            options = list(
              create = TRUE, 
              maxItems = 10000, 
              placeholder = '/r/...'
            )
          )
        )
      ),
      
      fluidRow(
        box(
          title = strings$keywordsTitle,
          status = "primary",
          selectizeInput(
            'keywordsInput',
            label = h4(strings$keywordsDesc),
            choices ="",
            multiple = TRUE,
            options = list(
              create = TRUE, 
              maxItems = 10000, 
              placeholder = 'Keywords'
            )
          )
        ),
        box(
          title = "Upvotes range",
          status = "primary",
          radioButtons("enableRange", label = NULL, choices = list("All comments" = 0, " Select range:" = 1)),
          uiOutput("upvotesUI")
          )
      ),
      
      fluidRow(
        box(
          title = strings$goldTitle,
          status = "primary",
          radioButtons(
            "isGilded",
            label = h4(strings$goldDesc),
            choices = list(
              "All" = 1, 
              "Yes" = 2, 
              "No" = 3
            ), 
            selected = 1
          )
        )
      ),
      
      fluidRow(
        column(width = 4),
        column(
          width = 4,
          offset = 0,
          align = "center",
          bsButton("plotButton", label = "Plot", size = "large", style = "success")
          ),
        column(width = 4)
      )
    )
  )
}

getSubredditRelationsPlotUI <- function() {
  return(
    tagList(
      fluidRow(
        box(
          title = "Plot",
          width = 8,
          status = "primary", 
          solidHeader = TRUE,
          simpleNetworkOutput(
            "network", 
            height = 500)
        ),
        
        box(
          title = "Settings",
          status = "primary",
          solidHeader = TRUE,
          width = 4,
          bsButton(
            "downloadPlot", 
            label = "Save",
            icon = icon("floppy-save", lib = "glyphicon"),
            size = "large"
          )
        )
      ),
      fluidRow(
        box(
          title = "Additional information",
          width = 12,
          status = "info",
          solidHeader = TRUE,
          selectInput(
            'infoSelect', 
            label = NULL,
            choices = list(
              "Empty" = 1, 
              "Show query" = 2, 
              "Show query results" = 3
            ),
            selected = 1
          ),
          
          uiOutput("queryInfoUI")
        )
      ),
      fluidRow(
        column(width = 4),
        column(
          width = 4,
          offset = 0,
          align = "center",
          bsButton("backButton", label = "Back", size = "large", style = "danger")),
        column(width = 4)
      )
    )
  )
}

getFrequencyComponents <- function(startTime, endTime) {
  return(
    tagList(
      fluidRow(
        box(
          title = strings$timePeriodTitle,
          status = "danger",
          dateRangeInput(
            "timeInput",
            label = h4(strings$timePeriodDesc),
            start = startTime,
            end = endTime,
            format = "dd/mm/yy",
            min = startTime, 
            max = endTime
          ),
          h5("Warning! Selecting a long period will gradually affect processing time.")
        ),
        box(
          title = strings$subredditsTitle,
          status = "primary",
          selectizeInput(
            'subredditsInput',
            label = h4(strings$subredditsDesc),
            choices = c(), 
            multiple = TRUE,
            options = list(
              create = TRUE, 
              maxItems = 10000, 
              placeholder = '/r/...'
            )
          )
        )
      ),
      fluidRow(
        box(
          title = strings$goldTitle,
          status = "primary",
          radioButtons(
            "isGilded",
            label = h4(strings$goldDesc),
            choices = list(
              "All" = 1, 
              "Yes" = 2, 
              "No" = 3
            ), 
            selected = 1
          )
        ),
        box(
          title = "Upvotes range",
          status = "primary",
          radioButtons("enableRange", label = NULL, choices = list("All comments" = 0, " Select range:" = 1)),
          uiOutput("upvotesUI")
        )
      ),
      fluidRow(
        #the columns center the actionbutton
        column(width = 4),
        column(
          width = 4,
          offset = 0,
          align = "center",
          bsButton("plotButton", label = "Plot", size = "large", style = "success")
          ),
        column(width = 4)
      )
    )
  )
}

getFrequencyPlotUI <- function() {
  return(
    tagList(
      fluidRow(
        box(
          title = "Plot",
          width = 8,
          status = "primary", 
          solidHeader = TRUE,
          plotOutput(
            "graph", 
            height = 350
          )
        ),
        box(
          title = "Settings",
          status = "primary",
          solidHeader = TRUE,
          width = 4,
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
          ),
          br(),
          bsButton(
            "downloadPlot", 
            label = "Save",
            icon = icon("floppy-save", lib = "glyphicon"),
            size = "large"
          ),
          textOutput("timer")
        )
      ),
      fluidRow(
        box(
          title = "Additional information",
          width = 12,
          status = "info",
          solidHeader = TRUE,
          selectInput(
            'infoSelect', 
            label = NULL,
            choices = list(
              "Empty" = 1, 
              "Show query" = 2, 
              "Show query results" = 3
            ),
            selected = 1
          ),
          
          uiOutput("queryInfoUI")
        )
      ),
      fluidRow(
        column(width = 4),
        column(
          width = 4,
          offset = 0,
          align = "center",
          bsButton("backButton", label = "Back", size = "large", style = "danger")),
        column(width = 4)
      )
    )
  )
}


getDefaultPlotUI <- function() {
  return(
    tagList(
      h4("There is nothing, because you haven't chosen a pattern.")
    )
  )
}

getUpvotesUI <- function() {
  return(
      tagList(
        column(6,numericInput("upsMin", label = h5("Min"), value = -50)),
        column(6,numericInput("upsMax", label = h5("Max"), value = 50)) 
      )
  )
}
