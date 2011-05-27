class ModuleResponse < ActiveRecord::Base
  #
  #associations
  #
  has_many :module_response_coords
  belongs_to :module
  belongs_to :module_image
  belongs_to :comment

  def self.assign_coords(coords, module_response)
    total_coords = coords.length/3
    while coords.length >= 3
      coord = coords.slice!(0..3)
      image_coords = ModuleResponseCoord.new(:x_coord => coord[0], :y_coord => coord[1], :module_image_id => coord[2])
      module_response.module_response_coods << image_coords  if image_coords.save
    end
    if module_response.module_response_coords.size == total_coords
      true
    else
      false
    end
  end

end
