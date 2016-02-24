## UI ##
library(shinydashboard)
library(googleCharts)

# xlim <- list(
#   min = min(data$time) - 500,
#   max = max(data$time) + 500
# )
# ylim <- list(
#   min = min(data$time),
#   max = max(data$time) + 3
# )

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
        ),
        conditionalPanel(
          condition = "input.patternSelect == '4'",
        fluidRow(
          box(
            title = "Percentage for subreddit relations",
            sliderInput(
              "percentage",
              label = h4("Select percentage"),
              min = 0, 
              max = 100, 
              value = 10)
          )
        )
        )
      ),

      # Plot tab content
      tabItem(
        tabName = "plot",
        fluidRow(
            box(
              googleBubbleChart("chart",
                width="100%", height = "475px",
                # Set the default options for this chart; they can be
                # overridden in server.R on a per-update basis. See
                # https://developers.google.com/chart/interactive/docs/gallery/bubblechart
                # for option documentation.
                options = list(
                  fontName = "Source Sans Pro",
                  fontSize = 13,
                  # Set axis labels and ranges
                  hAxis = list(
                    title = "Health expenditure, per capita ($USD)",
                    viewWindow = xlim
                  ),
                  vAxis = list(
                    title = "Life expectancy (years)",
                    viewWindow = ylim
                  ),
                  # The default padding is a little too spaced out
                  chartArea = list(
                    top = 50, left = 75,
                    height = "75%", width = "75%"
                  ),
                  # Allow pan/zoom
                  explorer = list(),
                  # Set bubble visual props
                  bubble = list(
                    opacity = 0.4, stroke = "none",
                    # Hide bubble label
                    textStyle = list(
                      color = "none"
                    )
                  ),
                  # Set fonts
                  titleTextStyle = list(
                    fontSize = 16
                  ),
                  tooltip = list(
                    textStyle = list(
                      fontSize = 12
                    )
                  )
                )
              )
            ),
            box(
              title = "Plot",
              width = 8,
              status = "primary",
              solidHeader = TRUE,
              # node charts for the subreddit relations pattern require simpleNetworkOutput instead of plotOutput
              uiOutput("plotUI")
            ),  
          box(
            title = "Plot",
            width = 8,
            status = "primary",
            solidHeader = TRUE,
            # node charts for the subreddit relations pattern require simpleNetworkOutput instead of plotOutput
            uiOutput("plotUI")
          ),
          box(
            title = "Settings",
            status = "primary",
            solidHeader = TRUE,
            width = 4,
            uiOutput("settingsUI")
            )
          ),
        fluidRow(
          box(
            textOutput("timer")
          )
        ),
        
        fluidRow(
          box(
            title = "Additional information",
            width = 12,
            status = "primary",
            solidHeader = TRUE,
            radioButtons('infoSelect', label=NULL,
                         choices = list("Empty" = 1, "Show query" = 2, "Show query results" = 3), 
                         selected = 1, inline=TRUE),
            
            conditionalPanel(
              condition = "input.infoSelect == '2'",
                textOutput("query_info")
            ),
            
            conditionalPanel(
              condition = "input.infoSelect == '3'",
              dataTableOutput("query_results")
            )
            
            )
          )
        )
      
    )
  )
)
