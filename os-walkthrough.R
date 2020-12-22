wood <- read_sf('path/to/folder/data/NM_Woodland.shp') %>% st_transform(4326)
roads <- read_sf('path/to/folder/NM/data/NM_Road.shp') %>% st_transform(4326)
water <- read_sf('path/to/folder/NM/data/NM_SurfaceWater_Area.shp') %>% st_transform(4326)
rivers <- read_sf('path/to/folder/NM/data/NM_SurfaceWater_Line.shp') %>% st_transform(4326)

shp <- read_sf('path/to/folder/Countries_2019') %>% st_transform(4326)
scotland <- shp[shp$ctry19nm == 'Scotland',]

coords <- matrix(c(-6.49,-5.6,56.245,56.668), byrow = TRUE, nrow = 2, ncol = 2, dimnames = list(c('x','y'),c('min','max')))


ggplot() + geom_rect(data = scotland, mapping=aes(xmin=coords[1], xmax=coords[1,2], ymin=coords[2], ymax=coords[2,2]), fill= '#cce6ff') +
  geom_sf(data = scotland, fill = '#fdffd0') + 
  geom_sf(data = wood, fill = '#4F9638', color = NA) + 
  geom_sf(data = water, fill = '#cce6ff', color = NA) + 
  geom_sf(data = rivers, fill = '#cce6ff', color = NA) + 
  geom_sf(data = roads, fill = '#B4BFB0',color = '#B4BFB0')  +
  coord_sf(xlim = c(coords[1], coords[1,2]), 
           ylim = c(coords[2], coords[2,2]),
           expand = FALSE) + theme_minimal()