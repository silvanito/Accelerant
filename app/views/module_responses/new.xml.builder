xml.instruct! :xml, :version => "1.1", :encoding => "US-ASCII"
xml.response do
  xml.instructions @flex_module.instructions
  xml.divisions @flex_module.divisions
  xml.labels do
    xml.top_label @flex_module.top_label
    xml.right_label @flex_module.right_label
    xml.bottom_label @flex_module.bottom_label
    xml.left_label @flex_module.left_label
  end
  @module_images.each do |module_image|
    xml.module_image do
      xml.file_name module_image.media_file_name
      xml.image_id module_image.id
      xml.module_id module_image.flex_module.id
      xml.image_path module_image.media.url
    end
  end
end
