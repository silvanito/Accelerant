class Project < ActiveRecord::Base

  #relationship
  has_many :comments
  has_many :discussions
  has_many :user_assignments
  has_many :categories
  belongs_to :client

  #scopes
  named_scope :exists, :conditions => [' 1 = 1 ']
  

  #
  # Validations
  #
  validates_inclusion_of :image_size, :in => %w(small medium large),
    :message => "is not a valid size"

  has_attached_file :photo,
  :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50>", :tiny => "20x20>" },
  :whiny => false,
  :whiny_thumbnails => false

end
