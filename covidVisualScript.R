# install.packages("tidyverse")
# install.packages("ggplot2")
# install.packages("hrbrthemes")

library(ggplot2)
library(hrbrthemes)

fileUrl <- "https://raw.githubusercontent.com/Maanuj-Vora/Many-Api/master/data/csv/coronavirus.csv"
covidData <- read.table(fileUrl, header=TRUE, sep="|")
head(covidData)

iso_codes <- covidData$iso_code
iso_codes <- unique(iso_codes)
iso_codes <- as.vector(iso_codes)
iso_codes <- sort(iso_codes)
iso_codes <- iso_codes[iso_codes!=""]

dir.create("docs", showWarnings = FALSE)
setwd("docs")

for(iso in iso_codes){
  if(!dir.exists(iso)){
    dir.create(iso, showWarnings = FALSE)
  }
  setwd(iso)

  currentIso <- covidData[covidData[, "iso_code"] == iso,]

  currentIso$date <- as.Date(currentIso$date, format = "%Y-%m-%d")
  
  totalCases <- ggplot(data = currentIso, aes(x = date, y = total_cases)) +
      geom_line() + theme_ipsum() +
      labs(title = sprintf("Total Cases of COVID-19 in %s", currentIso$location),
           x = "Month", y = "Total Cases")
#  print(totalCases)

  newCases <- ggplot(data = currentIso, aes(x = date, y = new_cases)) +
      geom_bar(stat = "identity", fill = "purple") + theme_ipsum() +
      labs(title = sprintf("New Cases of COVID-19 in %s", currentIso$location),
           x = "Month", y = "New Cases")
#  print(newCases)
  
  totalDeaths <- ggplot(data = currentIso, aes(x = date, y = total_deaths)) +
      geom_line() + theme_ipsum() +
      labs(title = sprintf("Total Deaths due to COVID-19 in %s", currentIso$location),
           x = "Month", y = "Total Deaths")
#  print(totalDeaths)
  
  newDeaths <- ggplot(data = currentIso, aes(x = date, y = new_deaths)) +
      geom_bar(stat = "identity", fill = "purple") + theme_ipsum() +
      labs(title = sprintf("New Deaths due to of COVID-19 in %s", currentIso$location),
           x = "Month", y = "New Deaths")
#  print(newDeaths)

  outputFile = sprintf("%s.png", "totalCases")
  png(outputFile)
  print(totalCases)
  dev.off()
  
  outputFile = sprintf("%s.png", "newCases")
  png(outputFile)  
  print(newCases)
  dev.off()
  
  outputFile = sprintf("%s.png", "totalDeaths")
  png(outputFile)  
  print(totalDeaths)
  dev.off()
  
  outputFile = sprintf("%s.png", "newDeaths")
  png(outputFile) 
  print(newDeaths)
  dev.off()
  
  print(iso)
  
  setwd("..")
}