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
          title = "Upvotes",
          status = "primary",
          sliderInput(
            "ups", 
            label = h4("Select a range of upvotes"), 
            min = -50, 
            max = 50, 
            value = c(-50, 50)
          )
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
      ),
      actionButton(
        "launchButton", 
        label = "Release the Kraken!"
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
          )
        )
      )
    )
  )
}

getSubredditRelationsComponents <- function(startTime, endTime) {
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
        )
      ),
      actionButton(
        "launchButton", 
        label = "Release the Kraken!"
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
          plotOutput(
            "graph", 
            height = 250
          )
        ),
        box(
          title = "Settings",
          status = "primary",
          solidHeader = TRUE,
          width = 4
        )
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
          title = "Upvotes",
          status = "primary",
          sliderInput(
            "ups", 
            label = h4("Select a range of upvotes"), 
            min = -50, 
            max = 50, 
            value = c(-50, 50)
          )
        )
      ),
      
      actionButton(
        "launchButton", 
        label = "Release the Kraken!"
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
            height = 250
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
          )
        )
      )
    )
  )
}