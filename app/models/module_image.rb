class ModuleImage < ActiveRecord::Base
  #
  #association
  #
  belongs_to :flex_module
  has_many :module_image_coords
  has_attached_file :media,
  :whiny => false,
  :whiny_thumbnails => false,
  :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50>", :tiny => "20x20>" }


end
