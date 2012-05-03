class Theme < ActiveRecord::Base

  #valitations
  validates_presence_of     :name
  validates_length_of       :name,    :within => 4..20
  validates_uniqueness_of   :name
  validates_format_of       :name, :with => /\A\w+\z/

  #relationship
  belongs_to :user

  has_attached_file :logo,
  :whiny => false,
  :whiny_thumbnails => false,
  :styles => {
  :size300 => "300x300>",
  :size200 => "200x200>",
  :size100 => "100x100>",
  :size75 => "75x75>",
  :size50 => "50x50>",
  :size30 => "30x30>",
  :size20 => "20x20>" }, 
  :storage => :s3,
  :bucket => 'blognog1',
  :s3_credentials => { 
      :access_key_id => "AKIAJPBL7M7Q6JJOT24A", 
      :secret_access_key => "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"
  },
  :path =>   "logos/:id/:style/:filename"


end
