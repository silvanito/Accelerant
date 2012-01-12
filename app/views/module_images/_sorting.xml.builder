xml.module_images do
  xml.divisions @flex_module.divisions
  xml.participants @participants
  @module_images.each do |module_image|
    xml.module_image do
      xml.image_path module_image.media.url
    end
  end
end
