class Discussion < ActiveRecord::Base
  belongs_to :project
  belongs_to :user
  has_many :heatmaps
  
  #named_scope :is_last, :conditions => {:is_published => true}


  has_attached_file :media,
  :whiny => false,
  :whiny_thumbnails => false,
  :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50>", :tiny => "20x20>" }


  def self.create_xml(user, discussion, user_filters, users_assigned, answers)
    if user.participant 
       xml_data = []
       xml_data << {:user_name => user.name, :user_id => user.id, :admin => user_criteria(user), :image_path => discussion.media.url, :discussion_id => discussion.id, :discussion_users => nil, :answers => nil, :w => "585", :h => "465"}
       xml_data
    else
      if !user_filters.empty?
        user_heatmaps = []
        user_filters.each do |user_filter|
          user_heatmaps << discussion.heatmaps.find(:all, :conditions => {:user_id => user_filter} )
        end
        heatmaps = user_heatmaps.flatten
      elsif user_filters == "nothing"
        heatmaps = nil
      else
        heatmaps = discussion.heatmaps
      end
      xml_data = []
      xml_data << {:user_name => user.name, :user_id => user.id, :admin => user_criteria(user), :image_path => discussion.media.url, :discussion_id => discussion.id, :discussion_users => users_assigned.count, :answers => answers.count, :w => "440", :h => "310"} 
      heatmaps.each do |heatmap|
        xml_data <<  heatmap.heatmap_coords
      end
      xml_data = xml_data.flatten
    end
  end

  def self.user_criteria(user)
    if user.admin || user.moderator || user.client
      true
    else 
      false
    end
  end

end
