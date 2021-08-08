library(rvest)
library(dplyr)
library(stringr)
library(rtweet)


panels <- read_html("https://www.riddles.com/riddle-of-the-day") %>% 
  html_nodes(".panel")  


riddle <- panels %>% 
  html_nodes(".orange_dk_span") %>% 
  html_text2() 

riddle_link <- panels %>% 
  html_nodes(".panel-heading")%>% 
  html_nodes("a") %>% 
  html_attr("href") %>% 
  paste0("https://www.riddles.com", .)

already_riddled <- readLines("riddles.txt")

riddle_dat <- data.frame(riddle,
                         riddle_link) %>% 
  mutate(n = str_count(riddle)) %>% 
  filter(n < 280) %>% 
  filter(!(riddle_link %in% already_riddled))


# Create a token containing your Twitter keys
rtweet::create_token(
  app = "",  # the name of the Twitter app
  consumer_key = Sys.getenv("consumer_key"),
  consumer_secret = Sys.getenv("consumer_secret"),
  access_token = Sys.getenv("riddler_token"),
  access_secret = Sys.getenv("riddler_secret")
)

the_riddle <- riddle_dat %>% 
  slice(1) 

the_riddle %>% 
  pull(riddle) %>% 
  rtweet::post_tweet()


cat(the_riddle$riddle_link, file = "riddles.txt", append = T, sep = "\n")


