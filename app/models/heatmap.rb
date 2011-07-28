class Heatmap < ActiveRecord::Base
  require 'tmpdir'
  require 'base64'
  #
  #includes
  #
  include TempFile::TemporalImages
  #
  #relationships
  #
  belongs_to :user
  belongs_to :discussion
  belongs_to :comment
  has_many :heatmap_coords, :dependent => :destroy
  #
  #callbacks
  #
  before_destroy :destroy_heatmap_coords

  def self.create_heatmap(image, coords, user_id, discussion_id, screen_size)
    discussion = Discussion.find(discussion_id)
    screen_size = screen_size.split(',')
    discussion.width = screen_size[0]
    discussion.height = screen_size[1]
    discussion.save
    user = User.find(user_id)
    heatmap = Heatmap.new(:image_result => image, :user_id => user.id)
    if heatmap.save
      coords = coords.split(",")
      coords_saved = Heatmap.heatmap_criteria(heatmap, discussion.heatmap_type.heatmap_type, coords)
      if coords_saved
        discussion.heatmaps << heatmap
        result = {:status => true, :errors => heatmap.errors}
      else
        result = {:status => false, :errors => "the coords was wrong!"}
      end
    else
      result = {:status => false, :errors => heatmap.errors.full_messages}
    end
  end

  def self.heatmap_criteria(heatmap, type, coords)
    case type.to_sym
    when :Image
      total_coords = coords.length/3
      while coords.length >= 3
        coord = coords.slice!(0..2)
        heatmap_coords = HeatmapCoord.new(:coord_x => coord[0], :coord_y => coord[1], :coord_radio => coord[2])
        heatmap.heatmap_coords << heatmap_coords  if heatmap_coords.save
      end
      if heatmap.heatmap_coords.size == total_coords
        true
      else
        false
      end
    when :Text
      total_coords = coords.length/4
      while coords.length >= 4
        coord = coords.slice!(0..3)
        heatmap_coords = HeatmapCoord.new(:startX => coord[0], :startY => coord[1], :endX => coord[2], :lineHeight => coord[3])
        heatmap.heatmap_coords << heatmap_coords  if heatmap_coords.save
      end
      if heatmap.heatmap_coords.size == total_coords
        true
      else
        false
      end
    end
  end

  def create_tmp_image
#    binaryData = Base64.decode64(self.image_result)
#    #f = Tempfile.new("#{self.discussion_id}_heatmap_image#{self.id}_id")
#    root_path = "#{RAILS_ROOT}/public"
     name =  "#{self.discussion_id}_heatmap_image#{self.id}.jpg"
#    unless File.exists?(root_path + path)
#      File.open(root_path + path, "wb") { |f| f.write(binaryData) }
#    end
#    #f.write(binaryData)
#    #path =  file
#    return path
    temporal_file = TemporalFile.new 
    temp_file_path = temporal_file.create_file(self.image_result, name)
    temporal_file.path_name(temp_file_path)
#    path = "/tmp/#{self.discussion_id}_heatmap_image#{self.id}.jpg"
#    File.open("#{RAILS_ROOT}/public/tmp/#{discussion.id}_heatmap_image#{heatmap.id}.jpg", "wb") { |f| f.write(binaryData) }
#    render :text => "success"
  end

  def delete_tmp_image
#    binaryData = Base64.decode64(self.image_result)
    root_path = "#{RAILS_ROOT}/public/tmp/"
#    path =  "/tmp/#{self.discussion_id}_heatmap_image#{self.id}.jpg"
#    if File.exists?(root_path + path)
#      File.delete(root_path + path)
#    end
    name = root_path + "#{self.discussion_id}_heatmap_image#{self.id}.jpg"
    temporal_file = TemporalFile.new 
    temp_file_path = temporal_file.delete_file(name)
  end
  private
    def destroy_heatmap_coords
      self.heatmap_coords.destroy_all
    end
end
