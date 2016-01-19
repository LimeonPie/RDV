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

commentAnalysis <- function(gilded, minScore, maxScore, minUps, maxUps, minDowns, maxDowns, keywords) {
  base <- c(
    "SELECT id, author, subreddit FROM ", tableName, " WHERE ",
    getValueEqual(scheme$gold, gilded), " AND ",
    getValueMore(scheme$score, minScore), " AND ",
    getValueLess(scheme$score, maxScore), " AND ",
    getValueMore(scheme$upVotes, minUps), " AND ",
    getValueLess(scheme$upVotes, maxUps), " AND ",
    getValueMore(scheme$downVotes, minDowns), " AND ",
    getValueLess(scheme$downVotes, maxDowns), " AND ",
    searchValue(scheme$comment, keywords), ";"
  )
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
