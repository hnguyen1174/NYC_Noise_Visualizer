#' Load 311 Noise Complaint Data
#'
#' @param online load data from the online data API
#'
#' @return 311 noise complaint data
#' @export
get_311_noise_data <- function(online = FALSE, package = 'NycNoiseViz') {
  
  if (online) {
    data_path <- 'https://data.cityofnewyork.us/resource/p5f6-bkga.csv'
    data  <- readr::read_csv(data_path)
  } else {
    data_path <- system.file('inst/data/311_Noise_Complaints.csv', package = package)
    data <- vroom(data_path)
  }
  
  processed_data <- prc_311_noise_data(data)
  processed_data
}

#' Process Noise Data
#'
#' @param noise_data loaded noise data
#'
#' @return processed noise data
#' @export
prc_311_noise_data <- function(noise_data) {
  
  cols <- c('Unique Key', 
            'Created Date', 'Closed Date',
            'Agency', 'Agency Name',
            'Complaint Type', 'Descriptor',
            'Location Type', 'Incident Zip',
            'Incident Address', 'Incident Address', 'Street Name',
            'Intersection Street 1', 'Intersection Street 2', 'Address Type',
            'City', 'Status', 'Resolution Description', 'Borough',
            'Latitude', 'Longitude', 'Location')
  
  noise_data <- noise_data %>% 
    select(all_of(cols)) %>% 
    dplyr::rename(ID = `Unique Key`,
                  COMPLAINT_DTE = `Created Date`,
                  CLOSED_DTE = `Closed Date`,
                  AGENCY = Agency,
                  AGENCY_NAME = `Agency Name`,
                  COMPLAINT_TYPE = `Complaint Type`,
                  DESC = Descriptor,
                  LOCATION_TYPE = `Location Type`,
                  ZIP = `Incident Zip`,
                  ADDRESS = `Incident Address`,
                  STREET = `Street Name`,
                  INTER_STREET_1 = `Intersection Street 1`,
                  INTER_STREET_2 = `Intersection Street 2`,
                  ADDRESS_TYPE = `Address Type`,
                  CITY = City,
                  STATUS = Status,
                  RESOLUTION = `Resolution Description`,
                  BOROUGH = Borough,
                  LAT = Latitude,
                  LONG = Longitude,
                  COORD = Location)
  
}







