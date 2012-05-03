class ReportComment < ActiveRecord::Base

  belongs_to :comment
  belongs_to :replies, :foreign_key => :subcomment_id
  belongs_to :user, :foreign_key => :owner

  has_attached_file :photo,
  :whiny => false, 
  :whiny_thumbnails => false, 
  :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "50x50>", :tiny => "20x20>" }
  :storage => :s3,
  :bucket => 'blognog1',
  :s3_credentials => { 
      :access_key_id => "AKIAJPBL7M7Q6JJOT24A", 
      :secret_access_key => "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"
  },
  :path =>   "photos/:id/:style/:filename"
end
