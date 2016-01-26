## processing.r ##
## Process received data for plotting ##

convertTime <- function(data) {
  # convert created_utc from POSIX to month, year
  data$time <- as.POSIXct("1970-01-01", origin="1970-01-01")
  for (row in 1:nrow(data)) {
    posixTime <- data$created_utc[row]
    normalTime <- as.POSIXct(posixTime, origin="1970-01-01")
    data$time[row] <- normalTime
    data$time[row] <- strptime(data$time[row],"%Y-%m-%d")
  }
  return(data)
}
