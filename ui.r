## UI ##
library(shinydashboard)

ui <- dashboardPage(
  skin = "red",

  dashboardHeader(
    title = span(img(src="acpreddit-logo.png", height = 42, width = 42, align = "middle"), "Reddit data visualisation"),
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
        h2("Hello World"),
        p("The purpose of the project is to provide interesting and useful information about Reddit by visualising the given dataset. We do that by creating user-friendly web interface for making queries, and to present them in the form of multiple charts. So the main focus of the project is giving user the tools to make her/his own search to the database and present that information. Furthermore, we will pre-generate some charts that either have considerable run-time or have particularly interesting information to show.")
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
