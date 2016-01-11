## UI ##
library(shinydashboard)

ui <- dashboardPage(
  skin = "red",
  dashboardHeader(
    title = "Reddit data visualisation", 
    titleWidth = 400
  ),
  dashboardSidebar(
    width = 400,
    column(
      width = 12,
           
      selectInput(
        'select', 
        label = h3("Pattern"), 
        choices = list(
          "Comment analysis" = 1, 
          "Users analysis" = 2,
          "Subreddit analysis" = 3, 
          "Subreddit relations" = 4,
          "Frequency of words" = 5, 
          selected = "Comment analysis"
        )
      ),
        
      dateRangeInput("dates", 
        label = h3("Date Range")
      ),
      
      # sidebarSearchForm(textId = "searchSubreddits", buttonId = "subreddit", label = "Subreddits..."),
      # allow creation of new items in the drop-down list
      
      selectizeInput(
        'subreddits', 
        h3("Select subreddit"), 
        choices = c(
          'sports', 
          'politics', 
          'reddit.com', 
          'science', 
          'programming'
        ), 
        multiple = TRUE,
        options = list(
          create = TRUE, 
          maxItems = 10000, 
          placeholder = '/r/...'
        )
      ),
        
      selectizeInput(
        'keywords', 
        h3("Select keywords"), 
        choices ="",
        multiple = TRUE,
        options = list(
          create = TRUE, 
          maxItems = 10000, 
          placeholder = 'Keyword'
        )
      ),
        
      radioButtons(
        "radio", 
        label = h3("Gold"),
        choices = list(
          "All" = 1, 
          "Yes" = 2, 
          "No" = 3
        ), 
        selected = 1
      ),
        
      h3("Upvotes"),
      
      numericInput(
        "upvotes_max", 
        label = h4("max"), 
        value = NULL
      ),
      numericInput(
        "upvotes_min", 
        label = h4("min"), 
        value = NULL
      ),
        
      h3("Downvotes"),
      
      numericInput(
        "downvotes_max", 
        label = h4("max"), 
        value = NULL
      ),
      
      numericInput(
        "downvotes_min", 
        label = h4("min"), 
        value = NULL
      ),
        
      actionButton(
        "go", 
        label = "GO!", 
        width = "50%"
      )
    )
  ),
  
  dashboardBody(
    fluidRow(
      box(
        width = 6,
        selectInput(
          "select", 
          label = h3("Pattern"),
          choices = list(
            "Comment analysis" = 1, 
            "Users analysis" = 2,
            "Subreddit analysis" = 3, 
            "Subreddit relations" = 4,
            "Frequency of words" = 5, 
            selected = 1
          )
        ),
        
        dateRangeInput(
          "dates", 
          label = h3("Date Range")
        )
      ),
        
      box(
        width = 6,
        textInput(
          "text", 
          label = h3("Keywords")
        ),
          
        radioButtons(
          "radio", 
          label = h3("Gold"),
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
      box(
        title = "Upvotes",
        numericInput(
          "upvotes_max", 
          label = h3("max"), 
          value = NULL
        ),
        numericInput(
          "upvotes_min", 
          label = h3("min"), 
          value = NULL
        )
      ),
      
      box(
        title = "Downvotes",
        numericInput(
          "downvotes_max", 
          label = h3("max"), 
          value = NULL
        ),
        numericInput(
          "downvotes_min", 
          label = h3("min"), 
          value = NULL
        )
      )
    ),
    
    fluidRow(
      box(
        helpText(
          "Some helpful text", 
          label = h3("Description")
        )
      )
    )
  )
)