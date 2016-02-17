## processing.r ##
## Process received data for plotting ##

library(tm)
library(SnowballC)

convertTime <- function(data) {
  # convert created_utc from POSIX to month, year
  data$time <- as.POSIXct("1970-01-01", origin="1970-01-01")
  for (row in 1:nrow(data)) {
    # Should make ref to field
    posixTime <- data$created_utc[row]
    normalTime <- as.POSIXct(posixTime, origin="1970-01-01")
    data$time[row] <- normalTime
    data$time[row] <- strptime(data$time[row],"%Y-%m-%d")
  }
  return(data)
}

createAmountFrame <- function(data, column) {
  frame <- as.data.frame(table(data[, column]))
  colnames(frame) <- c(column, "freq")
  return(frame)
}

createCorpus <- function(data, column) {
  corpus <- Corpus(VectorSource(data[, column]))
  corpus <- tm_map(corpus, PlainTextDocument)
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, removeWords, stopwords('english'))
  corpus <- tm_map(corpus, stemDocument)
  return(corpus)
}
