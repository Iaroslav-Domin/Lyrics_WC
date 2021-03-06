# make sure that all the packages are up to date
library(XML)
library(stringr)
library(wordcloud)
library(RColorBrewer)
library(data.table)
library(tm)
library(utils)
library(png)
library(abind)
library(magrittr)

source("code/getListOfSongs.R")
source("code/getSongLyrics.R")
source("code/getWordList.R")
source("code/getLyricsFromList.R")
source("code/getWordCount.R")
source("code/printWC.R")
###########################################################

id <- "queen"
###############################################################
## examples: queen, beatles, bee-gees, red-hot-chili-peppers ##
## rolling-stones, nirvana, bob-marley, michael-jackson      ##
###############################################################

listOfSongs <- getListOfSongs(id)
lyrics <- getLyricsFromList(listOfSongs,pause = 0.2)

## some lyrics may be unavailable due licensing restrictions
available <- lyrics != "\nWe are not in a position to display these lyrics due to licensing restrictions. Sorry for the inconvenience."
listOfSongs <- listOfSongs[available,]
lyrics <- lyrics[available]

# table with words and their frequencies, sorted by freq descending
wordCount <- getWordCount(lyrics,listOfSongs$popularity)
# write to a file
write.table(wordCount,paste0('findings/WordLists/',id,'.csv'),
            sep = ',',row.names = F)

## title
title <- paste0('http://www.metrolyrics.com/', id, '-overview.html') %>%
    readLines() %>%
    htmlParse() %>%
    xpathSApply('//h1', xmlValue)

## print
pal <- c("#5a5255", "#559e83", "#ae5a41", "#c3cb71", "#1b85b8")
file <- paste0("findings/Wordclouds/",id,".png")
printWC(wordCount, file, title)





