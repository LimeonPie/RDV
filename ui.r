## UI ##
library(shinydashboard)

ui <- dashboardPage(skin = "red",
  dashboardHeader(title = "Reddit data visualisation", titleWidth = 400),
  
  
  dashboardSidebar(width = 400,
      column(width = 12,
        selectInput("select", label = h3("Pattern"), 
          choices = list("Comment analysis" = 1, "Users analysis" = 2,
          "Subreddit analysis" = 3, "Subreddit relations" = 4,
          "Frequency of words" = 5, selected = "Comment analysis")),
        
        dateRangeInput("dates", label = h3("Date Range")),
        
        # sidebarSearchForm(textId = "searchSubreddits", buttonId = "subreddit", label = "Subreddits..."),
        # allow creation of new items in the drop-down list
        selectizeInput(
          'subreddits', h3("Select subreddit"), choices = c('AskReddit', 'funny', 'nfl', 'todayilearned', 'news', 'pics', 'gifs', 'videos', 'AdviceAnimals', 'worldnews', 'politics', 'movies', 'WTF', 'nba', 'IAmA', 'soccer', 'relationships', 'leagueoflegends', 'gaming', 'BlackPeopleTwi
', 'GlobalOffensive', 'StarWars', 'aww', 'pcmasterrace', 'Showerthoughts', 'me_irl', 'DotA2', '4chan', 'hockey', 'hiphopheads', 'SandersForPresident', 'gonewild', 'CFB', 'mildlyinteresting', 'nottheonion', 'stevenuniverse', 'G
          rees', 'anime', 'hearthstone', 'TumblrInAction', 'MMA', 'TrollXChromosomes', 'tifu', 'oculus', 'CringeAnarchy', 'technology', 'AskWomen', 'KotakuInAction', 'interestingasfuck', 'CollegeBasketball', 'DestinyTheGame', 'explainli
          s', 'Jokes', 'europe', 'science', 'Tinder', 'fo4', 'circlejerk', 'AskMen', 'PS4', 'conspiracy', 'Undertale', 'RealGirls', 'reactiongifs', 'Fallout', 'creepy', 'InternetIsBeautiful', 'photoshopbattles', 'atheism', 'MakingaMurde
          ', 'bestof', 'woahdude', 'television', 'ImGoingToHellForThis', 'Android', 'smashbros', 'TwoXChromosomes', 'polandball', 'Unexpected', 'personalfinance', 'food', 'Music', 'legaladvice', 'Fitness', 'sadcringe', 'asoiaf', 'LifePr
          stralia', 'baseball', 'starcraft', 'unitedkingdom', 'justneckbeardthings', 'books', 'wow', 'Celebs', 'tf2', 'fatlogic', 'instant_regret', 'canada', 'tumblr', 'gentlemanboners', 'RoastMe', 'space', 'OldSchoolCool', 'history', '
          e', 'india', 'oddlysatisfying', 'NSFW_GIF', 'xboxone', 'streetwear', 'childfree', 'talesfromtechsupport', 'OutOfTheLoop', '2007scape', 'Cricket', 'undelete'), multiple = TRUE,
          options = list(create = TRUE, maxItems = 10000, placeholder = '/r/...')),
        
        selectizeInput(
          'keywords', h3("Select keywords"), choices ="",multiple = TRUE,
          options = list(create = TRUE, maxItems = 10000, placeholder = 'Keyword')),
        
        radioButtons("radio", label = h3("Gold"),
          choices = list("All" = 1, "Yes" = 2, "No" = 3), selected = 1),
        
        h3("Upvotes"),
        numericInput("upvotes_max", label = h4("max"), value = NULL),
        numericInput("upvotes_min", label = h4("min"), value = NULL),
        
        h3("Downvotes"),
        numericInput("downvotes_max", label = h4("max"), value = NULL),
        numericInput("downvotes_min", label = h4("min"), value = NULL),
        
        actionButton("go", label = "GO!", width = "50%"))
             
  ),
  
  dashboardBody(
    fluidRow(
      box(width = 6,
        selectInput("select", label = h3("Pattern"),
          choices = list("Comment analysis" = 1, "Users analysis" = 2,
            "Subreddit analysis" = 3, "Subreddit relations" = 4,
            "Frequency of words" = 5, selected = 1)),
        
        dateRangeInput("dates", label = h3("Date Range"))),
        
      box(width = 6,
          textInput("text", label = h3("Keywords")),
          radioButtons("radio", label = h3("Gold"),
            choices = list("All" = 1, "Yes" = 2, "No" = 3),
            selected = 1))
      ),
  
    fluidRow(
      box(title = "Upvotes",
             numericInput("upvotes_max", label = h3("max"), value = NULL),
             numericInput("upvotes_min", label = h3("min"), value = NULL)),
      
      box(title = "Downvotes",
             numericInput("downvotes_max", label = h3("max"), value = NULL),
             numericInput("downvotes_min", label = h3("min"), value = NULL))),
    
    fluidRow(
      box(
        helpText("Tähän jotain tekstiä", label = h3("Description"))))
  )
)