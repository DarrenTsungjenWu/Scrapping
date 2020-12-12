library(tidyverse)
library(rvest)
library(stringr)

setwd("d:/download")

url <- "http://www.miaopai.com/u/paike_8o7ugjvf5c"
pages <- read_html(url)

# CAN NOT WORK
# links <- pages %>% html_nodes("div.video-player") %>%
          # html_nodes("video") %>% html_attr("src")

# THIS WORKS
links <- pages %>% html_nodes("div.MIAOPAI_player") %>% html_attr("data-scid")

links <- paste0("http://gslb.miaopai.com/stream/", links, ".mp4")
ct = length(links)
names<-c()
names=paste0(rep("��ʳ��Ƶ",ct),1:ct,".mp4")
for(i in 1:ct){
         download.file(links[i],names[i],mode="wb")
}


