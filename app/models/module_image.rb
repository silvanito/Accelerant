class ModuleImage < ActiveRecord::Base
  #
  #association
  #
  belongs_to :flex_module
  has_many :module_image_coords
  #
  #paperclip
  #
  has_attached_file :media,
  :whiny => false,
  :whiny_thumbnails => false,
  :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50>", :tiny => "20x20>" }
  #
  #filter
  #
  before_save :max_images
  #
  #validations
  #
  validates_attachment_presence :media, :message => "Photo must be set."

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
    average_coords[:x] = size > 0 ? x_avr / size : nil
    average_coords[:y] = size > 0 ? y_avr / size : nil
    return average_coords
  end

  def coord_maximum(field)
    self.module_image_coords.maximum(field.to_sym)
  end

  def coord_minimum(field)
    self.module_image_coords.minimum(field.to_sym)
  end

  def max_images
    flex_module = FlexModule.find(self.flex_module_id)
    if flex_module.module_images.size < 20
      true 
    else
      errors.add(:Limit_reached, "You reached the flex module limit of photos")
      false
    end
  end
end
