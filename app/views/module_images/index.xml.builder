xml.instruct! :xml, :version => "1.1", :encoding => "US-ASCII"
xml.module_images do
  xml.divisions @flex_module.divisions
  xml.labels do
    xml.top_label @flex_module.top_label
    xml.right_label @flex_module.right_label
    xml.bottom_label @flex_module.bottom_label
    xml.left_label @flex_module.left_label
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
