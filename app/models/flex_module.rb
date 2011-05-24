class FlexModule < ActiveRecord::Base
  #
  #associations
  #
  has_many :module_images
  belongs_to :module_type
  belongs_to :discussion
end
