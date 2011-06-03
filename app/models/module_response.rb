class ModuleResponse < ActiveRecord::Base
  #
  #associations
  #
  belongs_to :flex_module
  belongs_to :user
  has_one :module_response_image
  has_one :comment

end
