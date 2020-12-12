library(xml2)
library(rvest)
library(downloader)
library(stringr)
library(dplyr)

setwd("d:/download")
url <- "https://pic1.zhimg.com/80/fce82758487622fb7de34b6a95199cf5_hd.jpg"
download(url,"d:/download/picture.jpg",mode="wb")


pages <- read_html('https://www.zhihu.com/question/37839997')
links <- pages %>% html_nodes("img") %>% html_attr("src")
protocol = "https"
links <- grep(protocol,links,value=TRUE)

for(i in 1:length(links)){
	download(links[i],paste("d:/download/picture",i,".jpg",sep=""),mode="wb")
}

