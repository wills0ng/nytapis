library("lintr")

# load relevant libraries
library("httr")
library("jsonlite")
library("dplyr")

# Be sure and check the README.md for complete instructions!

# Use `source()` to load your API key variable from the `apikey.R` file
# you made.
# Make sure you've set your working directory!
source("apikey.R")

# Create a variable `movie_name` that is the name of a movie of your choice.
movie_name <- "John Wick: Chapter 3"

# Construct an HTTP request to search for reviews for the given movie.
# The base URI is `https://api.nytimes.com/svc/movies/v2/`
# The resource is `reviews/search.json`
# See the interactive console for parameter details:
#   https://developer.nytimes.com/movie_reviews_v2.json
#
# You should use YOUR api key (as the `api-key` parameter)
# and your `movie_name` variable as the search query!
base_uri <- "https://api.nytimes.com/"
resource <- "svc/movies/v2/reviews/search.json"
query_params <- list("query" = movie_name,
                     "api-key" = nty_apikey)

# Send the HTTP Request to download the data
# Extract the content and convert it from JSON
response <- GET(base_uri, path = resource, query = query_params)
response_text <- content(response, "text")
response_data <- fromJSON(response_text)

# What kind of data structure did this produce? A data frame? A list?
is.data.frame(response_data)  # it is not a data frame
typeof(response_data)  # It produced a list

# Manually inspect the returned data and identify the content of interest
# (which are the movie reviews).
# Use functions such as `names()`, `str()`, etc.
names(response_data)
response_data$results
is.data.frame(response_data$results)

# Flatten the movie reviews content into a data structure called `reviews`
response_df <- flatten(response_data$results)

# From the most recent review, store the headline, short summary, and link to
# the full article, each in their own variables
latest_review <- response_df %>%
  filter(publication_date == max(publication_date))
headline <- latest_review %>% pull(headline)
short_summary <- latest_review %>% pull(summary_short)
article_link <- latest_review %>% pull(link.url)

# Create a list of the three pieces of information from above.
# Print out the list.
movie_review_info <- list(
  headline = headline,
  short_summary = short_summary,
  article_link = article_link
)
