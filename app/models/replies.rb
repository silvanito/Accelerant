class Replies < ActiveRecord::Base
  belongs_to :comments
  belongs_to :user
  belongs_to :discussion
  has_many :report_comments

  
  has_attached_file :media,
  :whiny => false,
  :whiny_thumbnails => false, 
  :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50>", :tiny => "20x20>" }
  :storage => :s3,
  :bucket => 'blognog1',
  :s3_credentials => { 
      :access_key_id => "AKIAJPBL7M7Q6JJOT24A", 
      :secret_access_key => "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"
  },
  :path =>   "medias/:id/:style/:filename"
end
