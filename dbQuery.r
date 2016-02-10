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

# Maybe this is correct
subredditSizeQuery <- sprintf("SELECT DISTINCT subreddit, DATE(TIMESTAMP), COUNT(*) FROM %s GROUP BY subreddit, DATE(TIMESTAMP)", tableName)

subredditRelationsQuery <- sprintf("SELECT final.subreddit_a, final.subreddit_b FROM (
SELECT b.subreddit AS subreddit_a, b.authors AS authors_in_sub_a, a.subreddit AS subreddit_b, FLOOR(100*COUNT(*)/b.authors) AS percent, COUNT(*)
                                   FROM
                                   ((SELECT DISTINCT (author), subreddit FROM rawdata ORDER BY subreddit) AS a)
                                   JOIN 
                                   ((SELECT t1.author AS author, t1.subreddit AS subreddit, t2.authors AS authors
                                   FROM (SELECT DISTINCT author, subreddit FROM rawdata WHERE author!='[deleted]') AS t1 /* deleted authors are not included*/
                                   JOIN (SELECT subreddit, count(distinct author) AS authors FROM rawdata WHERE author!='[deleted]' GROUP BY subreddit) AS t2
                                   WHERE t1.subreddit=t2.subreddit
                                   GROUP BY subreddit, author
                                   ) AS b /*b is a table which includes every distinct author in every subreddits and also the amount of distinct authors in every subreddit*/)
                                   ON a.author=b.author
                                   WHERE a.subreddit!=b.subreddit 
                                   GROUP BY 1,3) AS final
                                   WHERE final.percent > 30;")




##testing node chart plotting
#src <- c("A", "A", "A", "A",
#         "B", "B", "C", "C", "D")
#target <- c("B", "C", "D", "J",
#            "E", "F", "G", "H", "I")
#networkData <- data.frame(src, target)