class ModuleResponse < ActiveRecord::Base
  #
  #associations
  #
  belongs_to :flex_module
  belongs_to :user
  has_one :module_response_image
  has_one :comment

  def assign_coords(coords)
    coords = coords.split(",")
    total_coords = coords.length/3
    while coords.length >= 3
      coord = coords.slice!(0..2)
      image_coords = ModuleResponseCoord.new(:module_image_id => coord[0], :x_coord => coord[1], :y_coord => coord[2])
      self.module_response_coords << image_coords  if image_coords.save
    end
    if self.module_response_coords.size == total_coords
      true
    else
      false
    end
  end

end
