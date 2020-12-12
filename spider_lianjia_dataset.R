library(stringr)
library(xml2)
library(rvest)
url0 <- 'https://cd.fang.lianjia.com/loupan/'
name=area=price=type=address=status=NULL
for(i in 1:10)
{
  url <- paste(url0,"pg",i,sep = '')
  web <- read_html(url)
  name <- c(name,web %>% html_nodes('div.resblock-name') %>% 
              html_nodes('a.name') %>% html_text())
  address <- c(address,web %>% html_nodes('div.resblock-location') %>% html_text())
  are = web %>% html_nodes('div.resblock-area') %>%  html_text()
  area= c(area,ifelse(are=='0','0',unlist(str_extract(are,'[0-9]+~[0-9]+|[0-9]+'))))
  price= c(price, web %>% html_nodes('div.main-price') %>% html_nodes('span.number')%>% html_text())
  type <-c(type, web %>% html_nodes('div.resblock-name') %>% 
              html_nodes('span.resblock-type') %>% html_text())

  status <-c(status, web %>% html_nodes('div.resblock-name') %>% 
              html_nodes('span.sale-status') %>% html_text())

}
data=data.frame(name,address,area,price=as.numeric(price),type,status)
print(data)