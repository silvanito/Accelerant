class Replies < ActiveRecord::Base
  belongs_to :comments
  belongs_to :user
  belongs_to :discussion
  has_many :report_comments

  
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
end
