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

commentsQuery <- sprintf("SELECT DATE(timestamp), COUNT(*) FROM %s GROUP BY DATE(timestamp)", tableName)

usersQuery <- sprintf("SELECT DATE(timestamp), COUNT(DISTINCT author) FROM %s GROUP BY DATE(timestamp)", tableName)

