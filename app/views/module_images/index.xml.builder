xml.instruct! :xml, :version => "1.1", :encoding => "US-ASCII"
xml.module_images do
  @module_images.each do |module_image|
    xml.module_image do
      xml.filename module_image.id
      xml.filename module_image.media_file_name
      xml.moduleId module_image.flex_module.id
      xml.imagePath module_image.media.url
    end
  end
end
