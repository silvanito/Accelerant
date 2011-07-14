class ModuleResponseImage < ActiveRecord::Base
  #
  #includes
  #
  include TempFile::TemporalImages
  #
  #relatioships
  #
  belongs_to :module_response
  has_many :module_image_coords, :dependent => :destroy
  #
  #callbacks
  #
  before_destroy :destroy_module_image_coords
  before_save  :create_temporal_image
  #
  #paperclip
  #
  has_attached_file :media,
  :whiny => false,
  :whiny_thumbnails => false,
  :styles => { :large => "550x510>", :medium => "500x410>", :small => "350x300>", :tiny => "200x200>" }

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
    path
#    File.open("#{RAILS_ROOT}/public/tmp/#{discussion.id}_heatmap_image#{heatmap.id}.jpg", "wb") { |f| f.write(binaryData) }
#    render :text => "success"
  end

  def delete_tmp_image
    unless self.image.nil?
      binaryData = Base64.decode64(self.image)
      root_path = "#{RAILS_ROOT}/public/tmp/"
      name = self.media.original_filename
      if File.exists?(root_path + name)
        File.delete(root_path + name)
      end
      self.image = nil
      self.save
    end
  end

  def assign_coords(coords)
    coords = coords.split(",")
    total_coords = coords.length/4
    while coords.length >= 4
      coord = coords.slice!(0..3)
      image_coord = ModuleImageCoord.new(:module_image_id => coord[0], :xCoord => coord[1], :yCoord => coord[2], :position_rank => coord[3])
      self.module_image_coords << image_coord if image_coord.save
    end
    if self.module_image_coords.size == total_coords
      true
    else
      false
    end
  end


  private
    def destroy_module_image_coords
      self.module_image_coords.destroy_all
    end

    def create_temporal_image
      if self.media.url.blank?
        binaryData = Base64.decode64(self.image)
        temporal_file = TemporalFile.new 
        temp_file_path = temporal_file.create_file(binaryData)
        self.media = RemoteFile.new(temp_file_path)
      end
    end
end
