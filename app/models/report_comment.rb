class ReportComment < ActiveRecord::Base

  belongs_to :comment
  belongs_to :replies, :foreign_key => :subcomment_id
  belongs_to :user, :foreign_key => :owner

  has_attached_file :photo,
  :storage => :s3,
  :bucket => 'blognog',
  :s3_credentials => {
    :access_key_id =>'AKIAJYKCWTZMXFO2YBNA',
    :secret_access_key => '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'
  },
  :whiny => false, 
  :whiny_thumbnails => false, 
  :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "50x50>", :tiny => "20x20>" }
end
