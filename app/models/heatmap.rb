class Heatmap < ActiveRecord::Base
  require 'tmpdir'
  belongs_to :user
  belongs_to :discussion
  belongs_to :comment
  has_many :heatmap_coords

  def self.create_heatmap(image, coords, user_id, discussion_id)
    discussion = Discussion.find(discussion_id)
    user = User.find(user_id)
    heatmap = Heatmap.new(:image_result => image, :user_id => user.id)
    if heatmap.save
       discussion.heatmaps << heatmap
       image_coords = []
       coords = coords.split(",")
       while coords.length >= 3
          coord = coords.slice!(0..2)
          heatmap_coords = HeatmapCoord.new(:coord_x => coord[0], :coord_y => coord[1], :coord_radio => coord[2])
          heatmap.heatmap_coords << heatmap_coords  if heatmap_coords.save

       end
       true
    end
  end

  def create_tmp_image
    binaryData = Base64.decode64(self.image_result)
    #f = Tempfile.new("#{self.discussion_id}_heatmap_image#{self.id}_id")
    root_path = "#{RAILS_ROOT}/public"
    path =  "/tmp/#{self.discussion_id}_heatmap_image#{self.id}.jpg"
    unless File.exists?(root_path + path)
      file = File.open(root_path + path, "wb") { |f| f.write(binaryData) }
    end
    #f.write(binaryData)
    #path =  file
    return path
#    File.open("#{RAILS_ROOT}/public/tmp/#{discussion.id}_heatmap_image#{heatmap.id}.jpg", "wb") { |f| f.write(binaryData) }
#    render :text => "success"
  end

  def delete_tmp_image
    binaryData = Base64.decode64(self.image_result)
    root_path = "#{RAILS_ROOT}/public"
    path =  "/tmp/#{self.discussion_id}_heatmap_image#{self.id}.jpg"
    if File.exists?(root_path + path)
      File.delete(root_path + path)
    end
  end
end
