#' Prepare API Key
#'
#' This function prepares an API key used in mapping.
#'
#' @param package default to `NycNoiseViz`.
#'
#' @return api key
prep_api_key <- function(package = 'NycNoiseViz') {
  api_key_part <- system.file('inst/mapping_parts/api_keys.rds', package = package)
  register_google(api_key)
  readRDS(api_key_part)
  message('*****Load and Register API Key!****')
}

#' Save new API Key
#'
#' @inheritParams prep_api_key
#'
#' @return NULL
save_api_key <- function(package = 'NycNoiseViz') {
  api_key <- readline(prompt = 'Please enter a new API Key: ')
  api_key_path <- system.file('inst/mapping_parts/api_keys.rds', package = package)

  if (file.exists(api_key_path)) {
    check <- NA
    while(is.na(check)) {
      check <- readline(prompt = 'There is already an API Key in this package, do you want to overwrite [Y/N]: ')
      check <- case_when(
        tolower(check) %in% c('y', 'yes') ~ TRUE,
        tolower(check) %in% c('n', 'no') ~ FALSE
      )
    }
    if (check & (api_key != '')) {
      saveRDS(api_key, api_key_path)
    }
  } else {
    if (api_key != '') {
      saveRDS(api_key, api_key_path)
    } else {
      stop('Please enter a non-empty string')
    }
  }

  register_google(api_key)
  message('*****Done!****')
}
