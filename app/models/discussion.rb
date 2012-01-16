class Discussion < ActiveRecord::Base
  #
  # Constants
  #
  COMMENT_TYPES = [ 'public', 'private', 'private_then_public' ]

  #
  #includes
  #
  include TempFile::TemporalImages

  #relationship
  belongs_to :project
  belongs_to :user
  belongs_to :heatmap_type
  belongs_to :category
  has_many :heatmaps
  has_many :comment_assignmentss
  has_many :flex_modules,  :dependent => :destroy


  
  #named_scope :is_last, :conditions => {:is_published => true}

  #
  # validations
  #
  validates_inclusion_of :comment_type, :in => COMMENT_TYPES
  validates_presence_of :character_minimum

  #
  # callbacks
  #
  before_validation :ensure_character_minimum
  before_destroy :destroy_flex_modules


  has_attached_file :media,
  :storage => :s3,
  :bucket => 'blognog',
  :s3_credentials => {
    :access_key_id =>'AKIAJYKCWTZMXFO2YBNA',
    :secret_access_key => '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'
  },
  :whiny => false,
  :whiny_thumbnails => false,
  :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50>", :tiny => "20x20>" }


  def self.create_xml(user, discussion, user_filters, users_assigned, answers)
    if user.participant 
       xml_data = []
       xml_data << {:user_name => user.name, :user_id => user.id, :admin => user_criteria(user), :image_path => discussion.media.url, :discussion_id => discussion.id, :discussion_users => nil, :answers => nil, :w => discussion.width, :h => discussion.height}
       xml_data
    else
      if !user_filters.empty?
        user_heatmaps = []
        user_filters.each do |user_filter|
          user_heatmaps << discussion.heatmaps.find(:last, :conditions => {:user_id => user_filter} ) unless user_filter == "nothing"
        end
        heatmaps = user_heatmaps.flatten
      else
        heatmaps = discussion.heatmaps
      end
      xml_data = []
      xml_data << {:user_name => user.name, :user_id => user.id, :admin => user_criteria(user), :image_path => discussion.media.url, :discussion_id => discussion.id, :discussion_users => users_assigned.size, :answers => answers.size, :w => discussion.width, :h => discussion.height} 
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

  def admin_tmp_image(image)
    type = self.has_heatmap ? "heatmap" : "modules"
    data = self.heatmaps.first || self.flex_modules.first
    
    data = data.nil? ? "zero_answers" : data.id
#    binaryData = Base64.decode64(image)
#    root_path = "#{RAILS_ROOT}/public"
    name = "#{type}_admin_report_#{data}_image.jpg"
    #path =  "/tmp/heatmap_admin_#{user_id}_image_#{discussion_id}.jpg"
#    unless File.exists?(root_path + path)
#      File.open(root_path + path, "wb") { |f| f.write(binaryData) }
#    end
#    return path
    temporal_file = TemporalFile.new 
    temp_file_path = temporal_file.create_file(image, name)
    temporal_file.path_name(temp_file_path)
  end

  def delete_admin_tmp_image
    root_path = "#{RAILS_ROOT}/public/tmp/"
    type = self.has_heatmap ? "heatmap" : "modules"
    data = self.heatmaps.first || self.flex_modules.first
    data = data.nil? ? "zero_answers" : data.id
#    path =  "/tmp/heatmap_admin_#{user_id}_image_#{self.id}.jpg"
#    if File.exists?(root_path + path)
#      File.delete(root_path + path)
#    end
    
    name = root_path + "#{type}_admin_report_#{data}_image.jpg"
    temporal_file = TemporalFile.new 
    temporal_file.delete_file(name)
  end

  def module_types_available
    module_types = ModuleType.all
    modules_assigned = []
    self.flex_modules.each do |flex_module|
      modules_assigned << flex_module.module_type
    end
    modules_available = module_types - modules_assigned

  end
  protected
    def ensure_character_minimum
      if character_minimum.nil?
        self.character_minimum = 0
      end
    end

    def destroy_flex_modules
      self.flex_modules.destroy_all
    end
end
