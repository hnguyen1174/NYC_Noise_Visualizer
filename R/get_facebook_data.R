#' Scrape Facebook Data
#'
#' This function scraped housing and/or apartment listing
#' from **public** Facebook groups.
#'
#' @param date_time_str a unique date time string
#'
#' @return scraped data from the NYCapartments subreddit
#' @export
scrape_facebook_data <- function(date_time_str) {

  use_python('/anaconda3/envs/ml_model/lib/python3.7')
  use_condaenv(condaenv = 'ml_model', conda = 'auto', required = TRUE)
  py_run_file('dev/scraper_facebook.py')

  file.copy('facebook_postings.csv', glue('data/{date_time_str}_facebook_postings.csv'))
  file.remove('facebook_postings.csv')
}

#' Process Facebook data
#'
#' @param fb_data scrapped Facebook data
#'
#' @return processed Facebook data
#' @export
prc_facebook_data <- function(fb_data) {

  start_date <- today() - months(6)

  fb_data_processed <- fb_data %>%
    select(post_id, text, post_text, shared_text,
           time, likes, comments, shares, post_url, user_id) %>%
    mutate(text = if_else(is.na(text), 'NOT AVAILABLE', text),
           post_text = if_else(is.na(post_text), 'NOT AVAILABLE', post_text),
           shared_text = if_else(is.na(shared_text), 'NOT AVAILABLE', shared_text)) %>%
    mutate_at(vars(text, post_text, shared_text), tolower) %>%
    mutate_at(vars(text, post_text, shared_text), str_squish) %>%
    mutate_at(vars(text, post_text, shared_text), function(x) str_replace_all(x, '\n', ' ')) %>%
    filter(time > start_date) %>%
    mutate(studio = str_detect(text, 'studio') | str_detect(post_text, 'studio') | str_detect(shared_text, 'studio'))

  fb_data_processed
}

#' Get Facebook Data
#'
#' This function gets listings from public Facebook groups.
#'
#' @return scraped and processed Facebook data
#' @export
get_facebook_data <- function() {

  data_folder <- file.path(here::here(), 'data')
  data_files <- list.files(data_folder)
  detect_fb_data_files <- (str_detect(data_files, 'facebook') &
                             str_detect(data_files,
                                        str_replace_all(as.character(today()), '-', ''))) %>%
    data_files[.] %>%
    sort()

  detect_fb_data <- detect_fb_data_files %>% length() > 0

  if (!detect_fb_data) {
    date_time_str <- Sys.time() %>%
      as.character() %>%
      str_replace_all('-|:', '') %>%
      str_replace(' ', '_')

    scrape_facebook_data(date_time_str)
  }

  facebook_data <- readr::read_csv(
    file.path(glue('data/{detect_fb_data_files[1]}'))
  )

  facebook_data_processed <- prc_facebook_data(facebook_data)
  facebook_data_processed
}
