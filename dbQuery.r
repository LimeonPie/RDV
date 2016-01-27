## dbQuery.r ##
## Operations with data ##

tableName <- "rawdata"
scheme <- list(
  comment = "body",
  gold = "gilded",
  score = "score",
  upVotes = "ups",
  downVotes = "downs",
  author = "author",
  subreddit = "subreddit",
  createTime = "created_utc"
)

commentAnalysis <- function(gilded = NULL, minScore = NULL, 
                            maxScore = NULL, minUps = NULL, 
                            maxUps = NULL, minDowns = NULL, 
                            maxDowns = NULL, timeFrom = NULL,
                            timeBefore = NULL, keywords = NULL) {
  base <- c("SELECT id, author, subreddit, created_utc FROM ", tableName, " WHERE ")
  # Gold status condition
  if (!is.null(gilded) & gilded == 3) {
    base <- c(base, getValueEqual(scheme$gold, 0), " AND ")
  }
  else if (!is.null(gilded) & gilded == 2) {
    base <- c(base, getValueEqual(scheme$gold, 1), " AND ")
  }
  
  # Minimal score condition
  if (!is.null(minScore)) {
    base <- c(base, getValueMore(scheme$score, minScore), " AND ")
  }
  
  # Maximum score condition
  if (!is.null(maxScore)) {
    base <- c(base, getValueLess(scheme$score, maxScore), " AND ")
  }
  
  # Minimal upvotes condition
  if (!is.null(minUps)) {
    base <- c(base, getValueMore(scheme$upVotes, minUps), " AND ")
  }
  
  # Maximum upvotes condition
  if (!is.null(maxUps)) {
    base <- c(base, getValueLess(scheme$upVotes, maxUps), " AND ")
  }
  
  # Minimal downvotes condition
  if (!is.null(minUps)) {
    base <- c(base, getValueMore(scheme$downVotes, minDowns), " AND ")
  }
  
  # Maximum downvotes condition
  if (!is.null(maxUps)) {
    base <- c(base, getValueLess(scheme$downVotes, maxDowns), " AND ")
  }
  
  # Starting time condition
  if (!is.null(timeFrom)) {
    base <- c(base, getValueMore(scheme$createTime, timeFrom), " AND ")
  }
  
  # Ending time condition
  if (!is.null(timeBefore)) {
    base <- c(base, getValueLess(scheme$createTime, timeBefore), " AND ")
  }
  
  # Keywords condition
  if (!is.null(keywords)) {
    base <- c(base, searchValue(scheme$comment, keywords), ";")
  }
  
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

getValueMore <- function(value, minValue) {
  base <- c(value, ">=", minValue)
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

getValueEqual <- function(value, equalValue) {
  base <- c(value, "=", equalValue)
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

getValueLess <- function(value, maxValue) {
  base <- c(value, "<=", maxValue)
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

searchValue <- function(value, keywords) {
  # Search among keywords:
  # 1 option: WHERE body REGEXP 'key1|key2|key3'
  # 2 option WHERE body LIKE '%key1%' OR body LIKE '%key2%'...
  # TODO: Find what better
  keys <- paste(keywords, collapse = "|")
  base <- c(value, " REGEXP '", keys, "'")
  query <- paste(base, sep = "", collapse = "")
  return(query)
}
