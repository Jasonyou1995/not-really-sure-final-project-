# INFO 201, Autumn 2016, Secton AB
# Team name: Not Really Sure
# Comtributors: Jason You (please add your name in here, if you contributed)
#
# When integrated with Shiny app, user can choose any University in
# the university_name list to see details around each university

source("scripts/installPackage.R")
source("scripts/factorToCharOrNum.R")
installPackage(c("leaflet", "dplyr"))


localMap <- function(my_university = "University of Washington Seattle") {
  # The bar coordinates around each University (radius = 5000 meters)
  bar_coord <- get(load("data/newData/barData/bar_coordinates.Rda"))
  
  # Get the bar counts data for each University
  selected_university <- read.csv("data/newData/barData/timesData_bar_count.csv",
                       stringsAsFactors = FALSE)
  # trimming unnecessary columns and duplicate University names
  selected_university <- selected_university %>%
    distinct(university_name, .keep_all = TRUE) %>% 
    filter(university_name == my_university) %>% 
    select(lon, lat, bar_count) %>% 
    mutate(type = "University")
  bar_count <- selected_university$bar_count  # for later usage
  selected_university <- selected_university %>% select(-bar_count)  # unselect bar_count column
  
  # lng and lat of the bars around this University
  selected_bars <- bar_coord[[my_university]] %>% mutate(type = "Bar")
  
  # content shown in the popup
  content <- paste(sep = "<br/>",
                   paste0("<b style=\"color:DarkSalmon;\">", 
                          my_university, "</b>"),
                   paste0("Number of bars within 5000 meters: ",
                          "<b style=\"color:DeepPink;\">", bar_count, "</b>"))
  
  # store the data used for ploting map
  plot_data <- rbind(selected_university, selected_bars)
  
  # Create a palette that maps factor levels to colors
  pal <- colorFactor(c("Tomato", "DeepSkyBlue"), 
                     domain = c("University", "Bar"))
  
  local_map <- leaflet(plot_data) %>% addTiles() %>%
    addCircleMarkers(
      radius = ~ifelse(type == "Bar", 6, 66),
      color = ~pal(type),
      stroke = FALSE,
      fillOpacity = 0.66,
      popup = ~ifelse(type == "University", content, "This is a bar..."))
  
  return(local_map)
}