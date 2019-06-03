
# Station Data ---------------------------------------------------------------

stations <- readxl::read_xlsx('data/2018_Julio_Bases_Bicimad_EMT.xlsx')

ggplot2::ggplot(stations, ggplot2::aes(x=longitude, y=latitude))+
  ggplot2::geom_point(na.rm=T)+
  ggplot2::coord_equal()


# Bike tracks -------------------------------------------------------------

file_name <- 'data/201704_Usage_Bicimad.json'
data <- jsonlite::read_json(file_name, )

a <- readLines(file_name, n = 1000)
b <- lapply(a, jsonlite::fromJSON)


