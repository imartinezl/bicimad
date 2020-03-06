library(dplyr)

# Station Data ---------------------------------------------------------------

stations <- readxl::read_xlsx('data/2018_Julio_Bases_Bicimad_EMT.xlsx') %>% 
  dplyr::mutate(label = paste0("<b>Station:  </b>",name,
                               "<br/><b>Address:</b> ",address,
                               "<br/><b># Bases:</b> ",total_bases))

ggplot2::ggplot(stations, ggplot2::aes(x=longitude, y=latitude))+
  ggplot2::geom_point(shape=0)+
  ggplot2::coord_equal()

leaflet::leaflet(width = 400, height = 400 ) %>% 
  leaflet::addProviderTiles(provider = leaflet::providers$CartoDB, group = "Tiles") %>% 
  leaflet::addCircleMarkers(data = stations, lng = ~longitude, lat = ~latitude, label = ~lapply(label, htmltools::HTML),
                            radius = 5, stroke = F) %>% 
  leaflet::setView(lng = -3.7, lat = 40.42, zoom=14)


# Bike tracks -------------------------------------------------------------

file_name <- 'data/201704_Usage_Bicimad.json'
data <- jsonlite::read_json(file_name, )

a <- readLines(file_name, n = 1000)
b <- lapply(a, jsonlite::fromJSON)

sapply(b, function(t){
  t$unplug_hourTime
})
t <- b[[9]]
t$unplug_hourTime %>% lubridate::ydm_hms(tz = "UTC")
lubridate::time(t$unplug_hourTime) + lubridate::hour(10)
t$track$features %>% 
  dplyr::rowwise() %>% 
  dplyr::mutate(long = geometry$coordinates[1] %>% round(digits = 4),
                lat = geometry$coordinates[2] %>% round(digits = 4),
                speed = properties$speed,
                ) %>% 
  dplyr::ungroup()

data.frame(id_plug_base = t$idplug_base, id_unplug_base = t$idunplug_base,
           id_plug_station = t$idplug_station, id_unplug_station = t$idunplug_station,
           user_type = t$user_type, user_age = t$ageRange, user_daycode = t$user_day_code,
           travel_time = t$travel_time, unplug_hour = t$unplug_hourTime
           )
track <- b[[9]]$track$features
track %>% 
  dplyr::mutate(a=properties$speed)

lapply(t$track$features$geometry$coordinates, function(r){
  r %>% stringr::str_split(' ') %>% unlist() 
}) %>% 
  unlist() %>% 
  as.numeric() %>% 
  matrix(ncol=2, byrow = T) 
