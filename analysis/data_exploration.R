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



