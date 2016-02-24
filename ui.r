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
            status = "primary",
            selectInput(
              'patternSelect',
              label = h4("Select pattern"),
              choices = list(
                "- Select pattern -" = 0,
                "Amount of comments" = 1, 
                "Subreddit relations" = 2,
                "Frequency of words" = 3
              ),
              selected = 0
            )
          ),
          box(
            title = "Description",
            textOutput("patternDescription")
          )
        ),
        uiOutput("inputComponents")
      ),
      
      # Plot tab content
      tabItem(
        tabName = "plot",
        
        uiOutput("plotUI")
      )
    )
  )
)