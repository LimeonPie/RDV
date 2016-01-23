## dbQuery.r ##
## Operations with data ##

tableName <- "rawdata"

createQuery <- function(gilded, minScore, minUps, maxUps, minDowns, maxDowns, keywords) {
  # Search among keywords:
  # 1 option: WHERE body REGEXP 'key1|key2|key3'
  # 2 option WHERE body LIKE '%key1%' OR body LIKE '%key2%'...
  # TODO: Find what better
  keys <- paste(keywords, collapse = "|")
  base <- c("SELECT id, author, subreddit FROM ", tableName, " WHERE ",
            "gilded=", gilded, " AND ",
            "score>", minScore, " AND ",
            "ups>=", minUps, " AND ",
            "ups<=", maxUps, " AND ",
            "downs>=", minDowns, " AND ",
            "downs<=", maxDowns, " AND ",
            "body REGEXP '", keys, "'",
            ";")
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

commentsQuery <- sprintf("SELECT DATE(timestamp) AS date, COUNT(*) AS comments FROM %s GROUP BY DATE(timestamp)", tableName)

usersQuery <- sprintf("SELECT DATE(timestamp) AS date, COUNT(DISTINCT author) AS users FROM %s GROUP BY DATE(timestamp)", tableName)

# Maybe this is correct
subredditSizeQuery <- sprintf("SELECT DISTINCT subreddit, DATE(TIMESTAMP), COUNT(*) FROM %s GROUP BY subreddit, DATE(TIMESTAMP)", tableName)