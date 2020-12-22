

#go to this web page and download the shapefile
#https://geoportal.statistics.gov.uk/datasets/westminster-parliamentary-constituencies-december-2016-generalised-clipped-boundaries-in-great-britain

## 1. read_sf() ##
library(sf)
library(tidyverse)

#put the directory path as the argument in read_sf()
constituencies <- read_sf('path/to/constituencies/shapefile/folder')

## 2. st_transform() ##
constituencies_wgs <- st_transform(constituencies, 4326)

## 3. st_point(), st_multilinestring(), st_cast() ##
pt1 <- st_point(c(-0.76, 51.28))
pt2 <- st_point(c(-0.76, 51.3))
pt3 <- st_point(c(-0.74, 51.3))
pt4 <- st_point(c(-0.74, 51.28))
ggplot() + geom_sf(data = pt1) + geom_sf(data = pt2) + geom_sf(data = pt3) + geom_sf(data = pt4)


mls <- st_multilinestring(list(rbind(pt1,pt2,pt3,pt4,pt1)))
ggplot() + geom_sf(data = mls)

polygon <- st_cast(mls, to = 'POLYGON')
ggplot() + geom_sf(data = polygon, fill = 'yellow')

polygon <- sf::st_sfc(polygon, crs = 4326)
ggplot() + geom_sf(data = constituencies_wgs[1,]) + geom_sf(data = polygon, fill = 'yellow')

## 4. st_intersects() ##
constituencies_wgs$intersects <- as.character(st_intersects(constituencies_wgs, polygon))

## 5. st_union() ##
union <- st_union(constituencies_wgs[1,],constituencies_wgs[315,])
ggplot() + geom_sf(data = union)

combination <- rbind(constituencies_wgs[1,], constituencies_wgs[315,])
combination <- st_combine(combination)
ggplot() + geom_sf(data = combination)

### PART 2 ###

## 1. st_buffer() ##
constituencies <- read_sf('your_working_directory/constituencies')
constituencies_wgs <- st_transform(constituencies, 4326)
iow <- constituencies_wgs[constituencies_wgs$pcon16nm == 'Isle of Wight',]
iow_buffer <- st_buffer(iow, dist = 0.003)
ggplot() + geom_sf(data = iow_buffer, fill = '#D1EDF2') + geom_sf(data = iow, fill = '#FAF5EF') + theme_void()

## 2. st_difference() ##
iow_buffer_isolated <- st_difference(iow_buffer, iow)
ggplot() + geom_sf(data = iow_buffer_isolated, fill = '#D1EDF2') + theme_void()

## 3. st_centroid() ##
iow_centroid <- st_centroid(iow)
ggplot() + geom_sf(data = iow, fill = '#FAF5EF') + geom_sf(data = iow_centroid, size = 4) + theme_void()

## 4. st_distance() ##
library(lwgeom)
portsmouth <- constituencies_wgs[constituencies_wgs$pcon16nm == 'Portsmouth South',]
portsmouth_centroid <- st_centroid(portsmouth)
st_distance(portsmouth_centroid, iow_centroid)

## 5. st_area() ##
st_area(iow)

