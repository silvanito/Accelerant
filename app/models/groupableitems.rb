class Groupableitems < ActiveRecord::Base

  has_attached_file :image,
  :storage => :s3,
  :bucket => 'blognog',
  :s3_credentials => {
    :access_key_id =>'AKIAJYKCWTZMXFO2YBNA',
    :secret_access_key => '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'
  },
  :whiny => false,
  :whiny_thumbnails => false,
  :styles => {
  :size600 => "600x600>",
  :size500 => "500x500>",
  :size400 => "400x400>",
  :size300 => "300x300>",
  :size200 => "200x200>",
  :size100 => "100x100>",
  :size80 => "80x80>",
  :size50 => "50x50>",
  :size30 => "30x30>",
  :size20 => "20x20>"
  }
  
end
