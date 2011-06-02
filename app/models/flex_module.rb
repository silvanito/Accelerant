class FlexModule < ActiveRecord::Base
  #
  #associations
  #
  has_many :module_images
  has_many :module_responses
  belongs_to :module_type
  belongs_to :discussion
end
