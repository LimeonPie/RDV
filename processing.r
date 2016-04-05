## processing.r ##
## Process received data for plotting ##

library(tm)
library(SnowballC)

customStopwords <- c(
  "dont", "doesnt", "ive", "ill", "iam", "arent",
  "shouldnt", "havent", "didnt", "hasnt", "hadnt",
  "like", "think", "really", "deleted", "youre",
  "isnt", "theyre", "wouldnt", "hes", "shes"
)

convertTime <- function(data) {
  # convert created_utc from POSIX to month, year
  # if dataframe is empty, the function returns data as it is
  if(nrow(data)!= 0){
    data$time <- as.POSIXct("1970-01-01", origin="1970-01-01")
    for (row in 1:nrow(data)) {
      # Should make ref to field
      posixTime <- data$created_utc[row]
      normalTime <- as.POSIXct(posixTime, origin="1970-01-01")
      data$time[row] <- normalTime
      data$time[row] <- strptime(data$time[row],"%Y-%m-%d")
    }
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
  corpus <- tm_map(corpus, removePunctuation)
  corpus <- tm_map(corpus, PlainTextDocument)
  corpus <- tm_map(corpus, removeWords, stopwords('english'))
  corpus <- tm_map(corpus, stemDocument)
  return(corpus)
}

createCorpusWithProgress <- function(data, column) {
  withProgress(
    message = 'Processing text...',
    value = 1, {
      corpus <- Corpus(VectorSource(data[, column]))
      setProgress(message = "Converting to plain text...")
      corpus <- tm_map(corpus, content_transformer(tolower))
      setProgress(message = "Removing punctuation...")
      corpus <- tm_map(corpus, removePunctuation)
      setProgress(message = "Removing numbers...")
      corpus <- tm_map(corpus, removeNumbers)
      setProgress(message = "Removing stopwords...")
      corpus <- tm_map(corpus, removeWords, c(stopwords("en"), stopwords("SMART"), customStopwords))
      setProgress(message = "Final preparation...")
      # Stemming
      #dictCorpus <- corpus
      #corpus <- tm_map(corpus, stemDocument)
      #corpus <- tm_map(corpus, stemCompletion, dictionary = dictCorpus)
      #dtm <- TermDocumentMatrix(corpus, control = list(minWordLength = 1))
    })
  return(corpus)
}
