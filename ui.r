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
        h2("Display here some home page")
      ),
      
      # Conf tab content
      tabItem(
        tabName = "conf",
        fluidRow(
          box(
            title = "Pattern",
            selectInput(
              'patternSelect',
              label = h4("Select pattern"),
              choices = list(
                "Comment analysis" = 1, 
                "Users analysis" = 2,
                "Subreddit analysis" = 3, 
                "Subreddit relations" = 4,
                "Frequency of words" = 5 
              ),
              selected = 1
            )
          ),
          box(
            title = "Description",
            textOutput("patternDescription")
          )
        ),
        
        fluidRow(
          box(
            title = "Time period",
            dateRangeInput(
              "dates",
              label = h4("Select time period"),
              start = "2008-01-15"
            )
          ),
          box(
            title = "Gold status",
            radioButtons(
              "isGilded",
              label = h4("Gilded"),
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
            title = "Subreddits",
            selectizeInput(
              'subredditsInput',
              label = h4("Select subreddits"),
              choices = c(), 
              multiple = TRUE,
              options = list(
                create = TRUE, 
                maxItems = 10000, 
                placeholder = '/r/...'
              )
            )
          ),
          box(
            title = "Keywords",
            selectizeInput(
              'keywordsInput',
              label = h4("Type keywords"),
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
            title = "Downvotes",
            sliderInput(
              "downs", 
              label = h4("Select a range of downvotes"), 
              min = 0, 
              max = 100, 
              value = c(0, 100)
            )
          ),
          box(
            title = "Upvotes",
            sliderInput(
              "ups", 
              label = h4("Select a range of upvotes"), 
              min = 0, 
              max = 100, 
              value = c(0, 100)
            )
          )
        )
      ),
      
      # Plot tab content
      tabItem(
        tabName = "plot",
        fluidRow(
          box(
            title = "Plot",
            width = 12,
            status = "primary", 
            solidHeader = TRUE,
            plotOutput(
              "graph", 
              height = 250
            )
          )
        ),
        
        fluidRow(
          box(
            title = "Controls",
            status = "primary", 
            solidHeader = TRUE,
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