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

  def coords_average
    coords = self.module_image_coords
    x_avr = 0
    y_avr = 0
    size  = coords.size
    average_coords  = {}
    result = {}
    coords.each do |coord|
      x_avr = x_avr + coord.xCoord
      y_avr = y_avr + coord.yCoord
    end
    average_coords[:x] = x_avr / size
    average_coords[:y] = y_avr / size
    return average_coords
  end

  def coord_maximum(field)
    self.module_image_coords.maximum(field.to_sym)
  end

  def coord_minimum(field)
    self.module_image_coords.minimum(field.to_sym)
  end
end
