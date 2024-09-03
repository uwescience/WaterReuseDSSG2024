
library(hexSticker)
library(png)         
library(grid)       

map_image <- image_read("image.png")
map_image <- image_transparent(map_image, color = "white", fuzz = 20)
map_image <- image_modulate(map_image, brightness = 120, saturation = 140) 
map_image <- image_fx(map_image, expression = "0.7*a") 
map_image <- image_scale(map_image, "700x700")

sticker(
  subplot = map_image, 
  package = "GeoNdxR",               
  p_size = 18,                        
  s_width = 1.5,                       
  s_height = 1.5,                      
  s_x = 1,                           
  s_y = 0.85,                       
  h_fill = "#2B7A78",                
  h_color = "#17252A",               
  p_color = "white",                
  url = "github.com/uwescience/WaterReuseDSSG2024",       
  u_size = 3,                        
  u_color = "white",                 
  filename = "GeoNdxR_logo.png")
