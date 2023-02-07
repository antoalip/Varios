library(sf)
library(purrr)
library(tidyverse)
library(ggplot2)
library(ggrepel)
library(dplyr)


m = st_read("D:/BackUp ANTONELLA/Agro/Anto/2022/mapas/LIMITES_DPTOS_MNES.shp")
ggplot() + geom_sf(data = m)

#explorar base de datos
m

#crear centroide para etiqueta de datos
m_c <- m %>% mutate(centroid = map(geometry, st_centroid), coords = map(centroid, st_coordinates), coords_x = map_dbl(coords, 1), coords_y = map_dbl(coords,2))

#Mapa con etiquetas de departamentos
ggplot(data = m_c) + 
  geom_sf(fill="lightblue", color="black")+ #Se le agrega un relleno celeste y bordes negros
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBRE), size = 2.25) #Se inserta el nombre de cada departamento

#Entrada de datos
library(readxl)
mdatos <- read_excel("C:/Users/Antonella/Desktop/Frontera Economica/mapas/Mnes datos.xlsx")
mdatos

mis_datos <- m_c %>% #Juntamos ambas bases de datos
  left_join(mdatos)
mis_datos

#ordenar los datos matcheados, o sino mapea mal
mis_datos2 = mis_datos[order(mis_datos$Poblacion, decreasing = TRUE), ]
mis_datos2

# Mapa final

ggplot(mis_datos2) +
  geom_sf(aes(fill = mis_datos2$Poblacion), color= "white")+
  labs(title = "Poblacion Misiones Censo 2022",
       caption = "Fuente: Elaboración propia en base a datos de INDEC",
       x="Longitud",
       y="Latitud")+
  scale_fill_distiller(palette = "Spectral", guide_legend(title = "población censo 2022"))+
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBRE), size = 2, colour="black")


#otra opcion
ggplot(mis_datos2) +
  geom_sf(aes(fill = mis_datos2$Poblacion), color= "white")+
  labs(title = "Poblacion Misiones Censo 2022",
       caption = "Fuente: Elaboración propia en base a datos de INDEC",
       x="Longitud",
       y="Latitud")+
  scale_fill_distiller(palette = "Spectral", guide_legend(title = "población censo 2022"))+
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBRE), size = 2, colour="black")+
  scale_fill
  theme_void() #elimina latitud y longitud
