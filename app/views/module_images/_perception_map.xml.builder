xml.module_images do
  xml.divisions @flex_module.divisions
  xml.participants @participants
  xml.labels do
    (1..@flex_module.divisions).each do |i|
      xml.tag!(method_name(i), @flex_module.method(method_name(i)).call)
    end
  end
  @module_images.each do |module_image|
    xml.module_image do
      xml.image_path module_image.media.url
      xml.x_average  module_image.coords_average[:x]
      xml.y_average  module_image.coords_average[:y]
      xml.x_max      module_image.coord_maximum(:xCoord)
      xml.x_min      module_image.coord_minimum(:xCoord)
      xml.y_max      module_image.coord_maximum(:yCoord)
      xml.y_min      module_image.coord_minimum(:yCoord)
    end
  end
end
