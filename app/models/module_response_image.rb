class ModuleResponseImage < ActiveRecord::Base
  belongs_to :module_response
  has_many :module_image_coords

  def create_tmp_image
    binaryData = Base64.decode64(self.image)
    #f = Tempfile.new("#{self.discussion_id}_heatmap_image#{self.id}_id")
    root_path = "#{RAILS_ROOT}/public"
    path =  "/tmp/#{self.module_response.id}_module_image#{self.id}.jpg"
    unless File.exists?(root_path + path)
      File.open(root_path + path, "wb") { |f| f.write(binaryData) }
    end
    #f.write(binaryData)
    #path =  file
    return path
#    File.open("#{RAILS_ROOT}/public/tmp/#{discussion.id}_heatmap_image#{heatmap.id}.jpg", "wb") { |f| f.write(binaryData) }
#    render :text => "success"
  end

  def delete_tmp_image
    binaryData = Base64.decode64(self.image)
    root_path = "#{RAILS_ROOT}/public"
    path =  "/tmp/#{self.module_response.id}_module_image#{self.id}.jpg"
    if File.exists?(root_path + path)
      File.delete(root_path + path)
    end
  end

  def assign_coords(coords)
    coords = coords.split(",")
    total_coords = coords.length/3
    while coords.length >= 3
      coord = coords.slice!(0..2)
      image_coord = ModuleImageCoord.new(:module_image_id => coord[0], :xCoord => coord[1], :yCoord => coord[2])
      self.module_image_coords << image_coord if image_coord.save
    end
    if self.module_image_coords.size == total_coords
      true
    else
      false
    end
  end
end
