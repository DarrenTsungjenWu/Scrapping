#JSON packages
library(bitops)
library(RCurl)
library(jsonlite)
 
#Selenium包
library(stringr) # String Processing
library(dplyr)# 调用%>%管道
library(RSelenium) #爬取动态网页
library(xml2)
library(rvest)
library(rjson) 
 
##Selenium
remote = remoteDriver("localhost", 4444L, browserName="firefox")
remote$open()
 
#Visit the Page Sources
url = "http://data.eastmoney.com/cjsj/fdi.html"
remote$navigate(url)
 
#Create a NULL list 
data_list = list(NULL)
for(i in 2:7) #6個變量
{
     data_list[i]=NULL
}
 
#設置模板(網址在不同頁的型態)
mode = "http://data.eastmoney.com/cjsj/foreigndirectinvestment.aspx?p="
counter = 2
 
#Crawl the rows of data 
for (z in 1:7) #7頁
{    
    #使每一頁的Page Sources都可以被獲取
    tpage = remote$getPageSource()
    PageSource = tpage[[1]]
    web = read_html(PageSource)
 
    #在Page Sources的基礎下，找尋並提取所有的row
    tbrows = web %>% html_nodes("#tb>tbody") %>% html_nodes("tr")
 
    for(i in 2:length(tbrows)) #2:length，而非1，因為不包含第一row中的項目名稱
    {
        tds = tbrows[i] %>% html_nodes("td")
        for(j in 1:6) #6個變量(column)，故1:6
        {
            data_list[[j]] = c(data_list[[j]], gsub("[ \n]", "", tds[j] %>% html_text()))
            #Preserve what we get into our NULL list, and
            #Use gsub to replace all the blank and /n with "", which is nothing
        } 
    }
 
    if (z == 7) 
    {    
        break
    }
    url2 = paste0(mode, counter)
    remote$navigate(url2) #Direct R to navigate what is actually inside url2
    counter = counter+1
}
 
#See the results
print(data_list)
 
#Create a dataframe where the names are matched with the data we just crawled
FDI = data.frame(
    Month = data_list[[1]],
    Monthly.Volume_USD = data_list[[2]],
    Year_on_year_Growth = data_list[[3]],
    Month_on_Month_Growth = data_list[[4]],
    Accumulation_in_Month = data_list[[5]],
    Year_on_year_Growth_Accumulation = data_list[[6]],
    stringsAsFactors = FALSE
)
 
#Write the data frame into the file
write.csv(FDI, "D:\\FDI_Data_China.csv")
