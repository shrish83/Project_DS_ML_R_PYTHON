library(xml2)
library(rvest)
library(tibble)
library(purrr)

base_url <- "https://www.the-numbers.com/movie/budgets/all"
base_webpage <- read_html(base_url)
table_base <- rvest::html_table(base_webpage)[[1]] %>% 
  tibble::as_tibble(.name_repair = "unique") # repair the repeated columns

new_urls<- "https://www.the-numbers.com/movie/budgets/all/%s"
table_new <-data.frame()
df <- data.frame()
i<-101
while (i<5502) {
  new_webpage<- read_html(sprintf(new_urls,i))
  table_new <- rvest::html_table(new_webpage)[[1]] %>% 
    tibble::as_tibble(.name_repair = "unique") # repair the repeated columns
  df<- rbind(df,table_new)
  i=i+100
}

#merge the base and df
df_movies <- merge(table_base,df, all = T)

#create a csv file
write.csv(df_movies,"cost_revenue_dirty.csv")
