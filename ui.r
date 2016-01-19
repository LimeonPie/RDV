## UI ##
library(shinydashboard)

ui <- dashboardPage(
  skin = "red",
  
  dashboardHeader(
    title = "Reddit data visualisation", 
    titleWidth = 300
  ),
  
  dashboardSidebar(
    width = 300,
    sidebarMenu(
      menuItem(
        "Home", 
        tabName = "default", 
        icon = icon("home", lib = "glyphicon")
      ),
      menuItem(
        "Configure", 
        tabName = "conf", 
        icon = icon("pencil", lib = "glyphicon")
      ),
      menuItem(
        "Plot", 
        tabName = "plot", 
        icon = icon("stats", lib = "glyphicon")
      )
    ),
    
    column(
      width = 1,
      actionButton(
        "launchButton", 
        label = "Release the Kraken!"
      )
    )
  ),
  
  dashboardBody(
    tabItems(
      
      # Default tab content
      tabItem(
        tabName = "default",
        h2("Display here some basic page")
      ),
      
      # Conf tab content
      tabItem(
        tabName = "conf",
        fluidRow(
          box(
            title = "Pattern select",
            selectInput(
              'patternSelect',
              label = h3("Pattern"),
              choices = list(
                "Comment analysis" = 1, 
                "Users analysis" = 2,
                "Subreddit analysis" = 3, 
                "Subreddit relations" = 4,
                "Frequency of words" = 5 
              ),
              selected = 1
            )
          )
        ),
        
        fluidRow(  
          box(
            title = "Date select",
            dateRangeInput(
              "dates",
              label = h3("Pattern")
            )
          )
        ),
          
        fluidRow(
          box(
            title = "Subreddits select",
            selectizeInput(
              'subredditsSelect',
              label = h3("Pattern"),
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
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Keywords input",
            selectizeInput(
              'keywordsInput',
              label = h3("Pattern"),
              choices ="",
              multiple = TRUE,
              options = list(
                create = TRUE, 
                maxItems = 10000, 
                placeholder = 'Keyword'
              )
            )
          )
        ),
        
        fluidRow(  
          box(
            title = "Gold status",
            radioButtons(
              "isGilded",
              label = h3("Pattern"),
              choices = list(
                "All" = 1, 
                "Yes" = 2, 
                "No" = 3
              ), 
              selected = 1
            )
          )
        )
      ),
      
      # Plot tab content
      tabItem(
        tabName = "plot",
        fluidRow(
          box(
            plotOutput(
              "graph", 
              height = 250
            )
          ),
          
          box(
            title = "Controls",
            sliderInput(
              "slider", 
              "Number of observations:", 1, 100, 50
            )
          )
        )
      )
    )
  )
)