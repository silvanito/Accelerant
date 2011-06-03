xml.instruct! :xml, :version => "1.1", :encoding => "US-ASCII"
xml.module_responses do
  @responses.each do |module_response|
    xml.module_response do
      xml.flex_module_id module_response.flex_module_id
      xml.user_id module_response.user_id
      xml.image_coords do
        module_response.module_response_image.module_image_coords.each do |image_coord|
          xml.image_coord do 
            xml.image_path image_coord.module_image.media.url
            xml.x_coord  image_coord.xCoord
            xml.y_coord  image_coord.yCoord
          end
        end
      end
    end
  end
end
