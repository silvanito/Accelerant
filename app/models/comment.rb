class Comment < ActiveRecord::Base
  #
  #relationships
  #
  has_one :heatmap, :dependent => :destroy
  has_one :report_comment, :dependent => :destroy
  belongs_to :module_response
  belongs_to :user
  belongs_to :discussion
  belongs_to :comment_assignment
  belongs_to :module_image_coord

  # for paperclip (polymorphic)
  #acts_as_polymorphic_paperclip
  #
  #scopes
  #
  named_scope :is_moderator, :joins => :users, :conditions => ['user.moderator = ?', true]
  named_scope :is_admin, :joins => :users, :conditions => ['user.admin = ?', true]
  named_scope :belongs_to_discussion, :conditions => ['discussion_id IS NOT NULL']
  named_scope :unassigned, :conditions => ['discussion_id IS NULL']
  #
  # validations
  #
  validates_presence_of :for_report
  validate :character_minimum
  #
  # callbacks
  #
  before_validation :ensure_for_report
  before_destroy :destroy_heatmap
  before_destroy :destroy_report_comment

  #has_many :attachings, :dependent => :destroy
  #has_many :attachments

  has_attached_file :photo,
  :whiny => false, 
  :whiny_thumbnails => false, 
  :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "50x50>", :tiny => "20x20>" }


  comma do
      project :title
      comment
      user :nam
      created_at
    end
  
  #validates_format_of :content_type,
   #                   :with => /^image/,
    #                  :message => "-- you can only upload pictures"
                      
  def uploaded_picture=(picture_field)
    self.name         = base_part_of(picture_field.original_filename)
    self.content_type = picture_field.content_type.chomp
    self.data         = picture_field.read
  end
  
  def base_part_of(file_name)
    File.basename(file_name).gsub(/[^\w._-]/, '')
  end

  def character_minimum
    discussion = Discussion.find(self.discussion_id)
    errors.add(:comment, "Response is too short.  Must be #{discussion.character_minimum}. Please fix write a comment more long") unless self.comment.length >= discussion.character_minimum
  end

  protected
    def ensure_for_report
      if for_report.nil?
        self.for_report = 0
      end
    end
  private
    def destroy_heatmap
      self.heatmap.destroy unless heatmap.nil?
    end

    def destroy_report_comment
      self.report_comment.destroy unless report_comment.nil?
    end

end
