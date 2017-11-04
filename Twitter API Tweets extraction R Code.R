##############################
# R has a dedicated package twitteR
# For additional functions refer twitteR.pdf (twitteR package manual)
# Sample code for getting twitter data -
#

require("twitteR")||install.packages("twitteR")
require("base64enc")||install.packages("base64enc")

library(twitteR)
library(base64enc)

#############################################
# Authentication
#############################################
# options(httr_oauth_cache=T)

api_key <- "V9olxusN5PbnWHIGoRlXXXXXXXXXXXXX"   #Consumer key: *

api_secret <- "ZJD4Ri2vE24iYJr2Y2fUotDwLbvE5IXXXXXXXXXXXXXXXXXXXX"   # Consumer secret: *

access_token <- "2889837547-u9URK5Vuad0dlbB6j8kwIdr4aXXXXXXXXXXXXXXXX"  # Access token: 

access_token_secret <- "8kfmatVED7RgIOsSTTu17SgiNVxdXXXXXXXXXXXXXXXXXXXXXXX" # Access token secret: 

# After this line of command type 1 for selection as Yes 

setup_twitter_oauth(api_key,api_secret,access_token,access_token_secret)

#[1] "Using direct authentication"
#Use a local file to cache OAuth access credentials between R sessions?
#1: Yes
#2: No
#Selection: 1

#############################################
# Extract Tweets
#############################################

hashtags = c('#NarendraModi','#Demonitisation','#USElections','#)

for (hashtag in hashtags){
tweets = searchTwitter(hashtag, n=1000 )     # hash tag for tweets search and number of tweets
tweets = twListToDF(tweets)    # Convert from list to dataframe

tweets.df = tweets[,1]  # assign tweets for cleaning

tweets.df = gsub("(RT|via)((?:\\b\\W*@\\w+)+)", "", tweets.df);head(tweets.df) 

tweets.df = gsub("@\\w+", "", tweets.df);head(tweets.df) # regex for removing @user
tweets.df = gsub("[[:punct:]]", "", tweets.df);head(tweets.df) # regex for removing punctuation mark
tweets.df = gsub("[[:digit:]]", "", tweets.df);head(tweets.df) # regex for removing numbers
tweets.df = gsub("http\\w+", "", tweets.df);head(tweets.df) # regex for removing links
tweets.df = gsub("\n", " ", tweets.df);head(tweets.df)  ## regex for removing new line (\n)
tweets.df = gsub("[ \t]{2,}", " ", tweets.df);head(tweets.df) ## regex for removing two blank space
tweets.df =  gsub("[^[:alnum:]///' ]", " ", tweets.df)     # keep only alpha numeric 
tweets.df =  iconv(tweets.df, "latin1", "ASCII", sub="")   # Keep only ASCII characters
tweets.df = gsub("^\\s+|\\s+$", "", tweets.df);head(tweets.df)  # Remove leading and trailing white space
tweets[,1] = tweets.df # save in Data frame

head(tweets)

write.csv(tweets,paste0(gsub('#','',hashtag),'.csv'))

}