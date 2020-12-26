#' Scrape Reddit Data
#'
#' @param date_time_str a unique date time string
#'
#' @return scraped data from the NYCapartments subreddit
#' @export
scrape_reddit_data <- function(date_time_str) {
  use_python('/anaconda3/envs/ml_model/lib/python3.7')
  use_condaenv(condaenv = 'ml_model', conda = 'auto', required = TRUE)
  py_run_file('dev/scraper_reddit.py')

  file.copy('reddit_postings.csv', glue('data/{date_time_str}_reddit_postings.csv'))
  file.remove('reddit_postings.csv')
}

#' Process Reddit data
#'
#' @param reddit_data scrapped Reddit data
#'
#' @return processed reddit data
#' @export
prc_reddit_data <- function(reddit_data) {
  start_date <- today() - months(6)

  reddit_data_processed <- reddit_data %>%
    select(-X1) %>%
    mutate(title = tolower(title),
           body = if_else(is.na(body), 'NOT AVAILABLE', body),
           body = tolower(body)) %>%
    filter(created > start_date,
           str_detect(title, 'listing')) %>%
    mutate(studio = str_detect(title, 'studio') | str_detect(body, 'studio'))

  reddit_data_processed
}

#'  Get Reddit Data
#'
#' @return scraped and processed Reddit data
#' @export
get_reddit_data <- function() {

  date_time_str <- Sys.time() %>%
    as.character() %>%
    str_replace_all('-|:', '') %>%
    str_replace(' ', '_')

  system('pwd')
  scrape_reddit_data(date_time_str)

  reddit_data <- readr::read_csv(
    file.path(glue('data/{date_time_str}_reddit_postings.csv'))
  )

  reddit_data_processed <- prc_reddit_data(reddit_data)
  reddit_data_processed
}
