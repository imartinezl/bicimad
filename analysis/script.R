library(dplyr)

path <- "201906_Usage_Bicimad.json"
# d <- jsonlite::fromJSON(path, stream=T)
# d <- jsonlite::stream_in(file(path, open="r", encoding="utf-8", raw=T), verbose=T, pagesize=10)

#length(readLines(file(path)))
d <- list()
cont <- 1

i <- 1
con <- file(path, "r")
while(T){
  line <- readLines(con, n=1)
  #print(i)
  #i <- i+1
  if(length(line) == 0){
    break
  }else{
    line_json <- jsonparse::from_json(line)
    #line_json <- jsonlite::fromJSON(line)
    if("track" %in% names(line_json)){
      d[[cont]] <- line_json
      cont <- cont + 1
      print(cont)
      # print(line)
      # if(cont > 400000){
      #   break
      # }
    }
  }
}


# data <- dplyr::bind_rows(d)
data <- pbapply::pblapply(d, function(x){
  date <- x$unplug_hourTime$`$date`
  lapply(x$track$features, function(y){
    lng <- y$geometry$coordinates[1]
    lat <- y$geometry$coordinates[2]
    sec <- y$properties$secondsfromstart
    data.frame(sec,lng,lat)
  }) %>% 
    dplyr::bind_rows() %>% 
    dplyr::mutate(date = date)
}, cl = 8) %>% 
  dplyr::bind_rows(.id = "id")




# - -----------------------------------------------------------------------

d <- list()
cont <- 1
con <- file(path, "r")
while(T){
  line <- readLines(con, n=1)
  if(length(line) == 0){
    break
  }else{
    line_json <- jsonparse::from_json(line)
    #line_json <- jsonlite::fromJSON(line)
    if("track" %in% names(line_json)){
      date <- line_json$unplug_hourTime$`$date`
      df <- lapply(line_json$track$features, function(y){
        lng <- y$geometry$coordinates[1]
        lat <- y$geometry$coordinates[2]
        sec <- y$properties$secondsfromstart
        data.frame(sec,lng,lat)
      }) %>% 
        dplyr::bind_rows() %>% 
        dplyr::mutate(date = date)
      d[[cont]] <- df
      print(cont)
      cont <- cont + 1
      # if(cont > 4000){
      #   break
      # }
    }
  }
}

d %>% saveRDS('backup.rds')

data <- d %>% 
  dplyr::bind_rows(.id = "id") %>% 
  dplyr::filter(
    dplyr::between(lng,-3.806076, -3.574333),
    dplyr::between(lat, 40.342096, 40.502314)
  ) %>% 
  dplyr::group_by(id) %>% 
  dplyr::filter(all(sec < 3600)) %>% 
  dplyr::ungroup()

cord.dec <- sp::SpatialPoints(cbind(data$lng, -data$lat), proj4string = sp::CRS("+proj=longlat"))
cord.UTM <- sp::spTransform(cord.dec, sp::CRS("+init=epsg:2062"))

data$id %>% unique() %>% length()
data %>% 
  dplyr::bind_cols(data.frame(sp::coordinates(cord.UTM))) %>% 
  dplyr::filter(id %in% seq(1,10000)) %>%
  ggplot2::ggplot()+
  ggplot2::geom_path(ggplot2::aes(x=coords.x1, y=-coords.x2, group=id), alpha=0.01)+
  ggplot2::coord_equal()


data$id %>% unique() %>% length()

data %>% 
  dplyr::bind_cols(data.frame(sp::coordinates(cord.UTM))) %>% 
  dplyr::mutate(x = scales::rescale(coords.x1),
                y = scales::rescale(coords.x2),
                id = as.numeric(id)
  ) %>% 
  dplyr::filter(id %in% seq(1,60000)) %>%
  dplyr::mutate(ts_date = as.POSIXct(date, format="%Y-%m-%dT%H:%M:%S")) %>% 
  dplyr::group_by(id) %>% 
  dplyr::mutate(ts_num = as.numeric(ts_date) + sec + round(runif(1,0,3600))) %>%
  dplyr::ungroup() %>% 
  dplyr::mutate(date = as.POSIXct(ts_num, origin="1970-01-01")) %>% 
  dplyr::arrange(ts_num) %>% 
  dplyr::select(id,x,y,date,ts_num) %>% 
  write.csv(file="bikes_path.csv", row.names = F)

freq <- 5*60
data %>% 
  dplyr::group_by(id) %>% 
  dplyr::mutate(i = 1:n()) %>% 
  dplyr::ungroup() %>% 
  dplyr::filter(id %in% seq(1,60000), i == 1) %>% 
  dplyr::mutate(ts_date = as.POSIXct(date, format="%Y-%m-%dT%H:%M:%S"),
                ts_num = as.numeric(ts_date) + round(runif(n(),0,3600)),
                ts_num = floor(ts_num/freq)*freq
  ) %>% 
  dplyr::group_by(ts_num) %>% 
  dplyr::summarise(count = length(unique(id))) %>% 
  dplyr::ungroup() %>% 
  dplyr::arrange(ts_num) %>% 
  dplyr::mutate(ts_date = as.POSIXct(ts_num, origin="1970-01-01")) %>% 
  write.csv(file="trips_count.csv", row.names = F)
  ggplot2::ggplot()+
  ggplot2::geom_line(ggplot2::aes(x=new_date, y=count))



