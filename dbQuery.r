## dbQuery.r ##
## Operations with data ##
library(stringr)
# small test 1k rows and full db
tableName <- "rawdata"
# bigger test 10k rows
#tableName <- "rawdata1"

# The "downs" field in the dataset is empty and the downvotes are presented by negative integers in "ups" field.
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

commentAnalysis <- function(gilded = NULL, upsMin = NULL, 
                            upsMax = NULL, timeFrom = NULL,
                            timeBefore = NULL, keywords = NULL,
                            authors = NULL, subreddits = NULL) {
  base <- c("SELECT id, author, subreddit, created_utc FROM ", tableName, " WHERE ")
  
  # Starting time condition
  if (!is.null(timeFrom)) {
    base <- c(base, getValueMore(scheme$createTime, timeFrom), " AND ")
  }
  
  # Ending time condition
  if (!is.null(timeBefore)) {
    base <- c(base, getValueLess(scheme$createTime, timeBefore), " AND ")
  }
  
  # Subreddits condition
  if (!is.null(subreddits)) {
    base <- c(base, getValueIn(scheme$subreddit, subreddits), " AND ")
  }
  
  # Gold status condition
  if (!is.null(gilded) & gilded == 3) {
    base <- c(base, getValueEqual(scheme$gold, 0), " AND ")
  }
  else if (!is.null(gilded) & gilded == 2) {
    base <- c(base, getValueEqual(scheme$gold, 1), " AND ")
  }
  
  # Minimal upvotes condition
  if (!is.null(upsMin)) {
    base <- c(base, getValueMore(scheme$upVotes, upsMin), " AND ")
  }

  # Maximum upvotes condition
  if (!is.null(upsMax)) {
    base <- c(base, getValueLess(scheme$upVotes, upsMax), " AND ")
  }
  
  # Authors condition (in author field)
  if (!is.null(authors)) {
    base <- c(base, searchValue(scheme$author, authors), " AND ")
  }
  
  # Removing [deleted] authors
  base <- c(base, getValueNotEqual(scheme$author, "'[deleted]'"), " AND ")
  
  # Keywords condition (in comment field)
  if (!is.null(keywords)) {
    base <- c(base, searchValue(scheme$comment, keywords), " AND ")
  }

  # Removing the last element in query " AND " or " WHERE "
  # And putting the end to it
  base <- base[-length(base)]
  base <- c(base, ";")
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

subredditsRelations <- function(gilded = NULL, upsMin = NULL,
                                upsMax = NULL, timeFrom = NULL,
                                timeBefore = NULL, subreddits = NULL, 
                                percentage = NULL, minSub = NULL) {
  
  #generates the condition clause
  base <- ""

  # Gold status condition
  if (!is.null(gilded) & gilded == 3) {
    base <- c(base, getValueEqual(scheme$gold, 0), " AND ")
  }
  else if (!is.null(gilded) & gilded == 2) {
    base <- c(base, getValueEqual(scheme$gold, 1), " AND ")
  }

  # Minimal upvotes condition
  if (!is.null(upsMin)) {
    base <- c(base, getValueMore(scheme$upVotes, upsMin), " AND ")
  }

  # Maximum upvotes condition
  if (!is.null(upsMax)) {
    base <- c(base, getValueLess(scheme$upVotes, upsMax), " AND ")
  }
  
  # Starting time condition
  if (!is.null(timeFrom)) {
    base <- c(base, getValueMore(scheme$createTime, timeFrom), " AND ")
  }
  
  # Ending time condition
  if (!is.null(timeBefore)) {
    base <- c(base, getValueLess(scheme$createTime, timeBefore), " AND ")
  }
  
  # Subreddits condition
  if (!is.null(subreddits)) {
    base <- c(base, getValueIn(scheme$subreddit, subreddits), " AND ")
  }
  
  # Removing [deleted] authors
  #base <- c(base, getValueNotEqual(scheme$author, "'[deleted]'"), " AND ")
  
  print("Here are the conditions: ")
  conditions <- paste(base, sep = "", collapse = "")
  print(conditions)
  
  query <- sprintf("SELECT final.subreddit_a, final.subreddit_b FROM (SELECT a.subreddit AS subreddit_a, a.authors AS authors_in_sub_a, b.subreddit AS subreddit_b, b.authors AS authors_in_sub_b, floor(100 * (count(*)/((a.authors + b.authors)/2))) AS percentage FROM
 (SELECT t1.author AS author, t1.subreddit AS subreddit, t2.authors AS authors
 FROM (SELECT DISTINCT author, subreddit FROM %s WHERE %s author!='[deleted]') AS t1
 JOIN (SELECT * FROM (SELECT subreddit, count(distinct author) AS authors FROM %s WHERE %s author!='[deleted]' GROUP BY subreddit) AS t5 WHERE authors >= %s) AS t2
 ON t1.subreddit=t2.subreddit
 GROUP BY subreddit, author) AS a
 JOIN 
 (SELECT t3.author AS author, t3.subreddit AS subreddit, t4.authors AS authors
 FROM (SELECT DISTINCT author, subreddit FROM %s WHERE %s author!='[deleted]') AS t3
 JOIN (SELECT * FROM (SELECT subreddit, count(distinct author) AS authors FROM %s WHERE %s author!='[deleted]' GROUP BY subreddit) AS t6 WHERE authors >= %s) AS t4
 ON t3.subreddit=t4.subreddit
 GROUP BY subreddit, author) AS b
 ON a.author=b.author
 WHERE a.subreddit!=b.subreddit
 GROUP BY 1,3) AS final
 WHERE final.percentage > %s;", tableName, conditions, tableName, conditions, minSub, tableName, conditions, tableName, conditions, minSub, percentage)
 
  #removes new lines from the query
  query <- gsub("[\r\n]", "", query)
  print(query)
  return(query)
}

frequencyOfWords <- function(gilded = NULL, upsMin = NULL,
                             upsMax = NULL, timeFrom = NULL,
                             timeBefore = NULL, subreddits = NULL) {
  base <- c("SELECT id, body FROM ", tableName, " WHERE ")

  # Starting time condition
  if (!is.null(timeFrom)) {
    base <- c(base, getValueMore(scheme$createTime, timeFrom), " AND ")
  }
  
  # Ending time condition
  if (!is.null(timeBefore)) {
    base <- c(base, getValueLess(scheme$createTime, timeBefore), " AND ")
  }
  
  # Subreddits condition
  if (!is.null(subreddits)) {
    base <- c(base, getValueIn(scheme$subreddit, subreddits), " AND ")
  }
  
  # Gold status condition
  if (!is.null(gilded) & gilded == 3) {
    base <- c(base, getValueEqual(scheme$gold, 0), " AND ")
  }
  else if (!is.null(gilded) & gilded == 2) {
    base <- c(base, getValueEqual(scheme$gold, 1), " AND ")
  }

  # Minimal upvotes condition
  if (!is.null(upsMin)) {
    base <- c(base, getValueMore(scheme$upVotes, upsMin), " AND ")
  }

  # Maximum upvotes condition
  if (!is.null(upsMax)) {
    base <- c(base, getValueLess(scheme$upVotes, upsMax), " AND ")
  }
  
  # Removing [deleted] authors
  base <- c(base, getValueNotEqual(scheme$author, "'[deleted]'"), " AND ")
  
  # Removing the last element in query (" AND ")
  # And putting the end to it
  base <- base[-length(base)]
  base <- c(base, ";")
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

getValueNotEqual <- function(value, notEqualValue) {
  base <- c(value, "<>", notEqualValue)
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

getValueLess <- function(value, maxValue) {
  base <- c(value, "<=", maxValue)
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

getValueIn <- function(value, list) {
  base <- c(value, " IN (", paste("'", list, "'", sep = "", collapse = ", "), ")")
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

searchValue <- function(value, keywords) {
  # Search among keywords:
  # 1 option: WHERE body REGEXP 'key1|key2|key3'
  # 2 option: WHERE body LIKE '%key1%' OR body LIKE '%key2%'...
  # 3 option: SELECT 'abc' SIMILAR TO 'abc';
  # TODO: Find what better
  keys <- paste(keywords, collapse = "|")
  base <- c(value, " SIMILAR TO '(", keys, ")'")
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

findUniqueValues <- function(field) {
  #base <- c("SELECT DISTINCT ", field, " FROM ", tableName, " ORDER BY ", field, ";")
  base <- c("SELECT DISTINCT ", field, " FROM ", tableName, ";")
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

findUniqueValuesWithinTime <- function(field, timeFrom, timeBefore) {
  base <- c("SELECT DISTINCT ", field, " FROM ", tableName, " WHERE ")
  base <- c(base, getValueMore(scheme$createTime, timeFrom), " AND ")
  base <- c(base, getValueLess(scheme$createTime, timeBefore))
  base <- c(base, " ORDER BY ", field, ";")
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

getMinValue <- function(field) {
  base <- c("SELECT ", field, " FROM ", tableName)
  base <- c(base, " WHERE ", field, "=(SELECT MIN(", field, ") FROM ", tableName, ") LIMIT 1;")
  query <- paste(base, sep = "", collapse = "")
  return(query)
}

getMaxValue <- function(field) {
  base <- c("SELECT ", field, " FROM ", tableName)
  base <- c(base, " WHERE ", field, "=(SELECT MAX(", field, ") FROM ", tableName, ") LIMIT 1;")
  query <- paste(base, sep = "", collapse = "")
  return(query)
}