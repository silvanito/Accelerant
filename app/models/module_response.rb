class ModuleResponse < ActiveRecord::Base
  belongs_to :module
  belongs_to :module_image
  belongs_to :comment
end
