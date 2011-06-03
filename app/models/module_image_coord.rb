class ModuleImageCoord < ActiveRecord::Base
  #
  #associations
  #
  belongs_to :module_image
  belongs_to :module_response_image
  has_one :comment
end
