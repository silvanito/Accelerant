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
  before_create :check_video

  #has_many :attachings, :dependent => :destroy
  #has_many :attachments

  has_attached_file :photo,
  :whiny => false, 
  :whiny_thumbnails => false, 
  :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "50x50>", :tiny => "20x20>" },
  :storage => :s3,
  :bucket => 'blognog1',
  :s3_credentials => { 
      :access_key_id => "AKIAJPBL7M7Q6JJOT24A", 
      :secret_access_key => "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"
  },
  :path =>   "photos/:id/:style/:filename"

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
    
    def check_video
      
      if  self.comment.match("http://www.youtube.com/watch?")
      add_youtube_video
      elsif self.comment.match("http://vzaar.com/videos/")
        add_vzaar_video
      end
    end
    
    def add_youtube_video
      video_code = self.comment.gsub("/",'').scan(/v=(\S*)&/)
      if video_code.empty?
        video_code = self.comment.gsub("/",'').scan(/v=(\S*)/)
      end
      self.comment.gsub!(/http:\/\/[^\s]*/, '') 
      self.comment << "<iframe width='560' height='315' src='http://www.youtube.com/embed/#{video_code[0][0]}?rel=0 frameborder='0' allowfullscreen></iframe>"  
    end
    
    def add_vzaar_video
      video_code = self.comment.scan(/\/videos\/(\d*)/)[0][0]
      self.comment.gsub!(/http:\/\/[^\s]*/, '')
      self.comment.gsub!("<A href=\"", '')
      #TODO I know that is realy bad :s
      self.comment << "<div class='vzaar_media_player'><object data='http://view.vzaar.com/#{video_code}/flashplayer' height='252' id='video' type='application/x-shockwave-flash' width='448'><param name='allowFullScreen' value='true' /> <param name='allowScriptAccess' value='always' /><param name='wmode' value='transparent' /><param name='movie' value='http://view.vzaar.com/#{video_code}/flashplayer' /><param name='flashvars' value='border=none' /><video controls height='252' id='vzvid' onclick='this.play();' poster='http://view.vzaar.com/#{video_code}/image' preload='none' src='http://view.vzaar.com/#{video_code}/video' width='448'></video></object></div>"
    end
end