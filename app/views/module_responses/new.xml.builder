xml.instruct! :xml, :version => "1.1", :encoding => "US-ASCII"
xml.response do
  @module_images.each do |module_image|
    xml.module_image do
      xml.file_name module_image.media_file_name
      xml.image_id module_image.id
      xml.module_id module_image.flex_module.id
      xml.image_path module_image.media.url
    end
  end
end
