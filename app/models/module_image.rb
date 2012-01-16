class ModuleImage < ActiveRecord::Base
  #
  # constants
  #
  POSITIONS = ["first_place", "second_place", "third_place", "fourth_place", "fifth_place", "sixth_place", "seventh_place", "eight_place", "ninth_place", "tenth_place", "eleventh_place", "twelfth", "thirteenth_place", "fourteenth_place", "fifteenth_place", "sixteenth_place", "seventeenth_place", "eighteenth_place", "nineteenth_place", "twentieth_place"]
  #
  #association
  #
  belongs_to :flex_module
  has_many :module_image_coords, :dependent => :destroy
  #
  #paperclip
  #
  has_attached_file :media,
  :storage => :s3,
  :bucket => 'blognog',
  :s3_credentials => {
    :access_key_id =>'AKIAJYKCWTZMXFO2YBNA',
    :secret_access_key => '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'
  },
  :whiny => false,
  :whiny_thumbnails => false,
  :styles => { :large => "300x300>", :medium => "100x100>", :small => "50x50>", :tiny => "20x20>" }
  #
  #callbacks
  #
  before_save :max_images
  before_destroy :destroy_module_image_coords
  #
  #validations
  #
  validates_attachment_presence :media, :message => "Photo must be set."
  #
  #Scopes
  #
  #POSITIONS.each_with_index { |position, index| named_scope position, :joins => :module_image_coords, :conditions => { :module_image_coords =>  {:position_rank => index+1} } }

  POSITIONS.each_with_index do |position, index| 
    define_method "#{position}" do
      self.module_image_coords.find(:all, :conditions => {:position_rank => index+1}).size
    end
  end

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
  
  def self.order_by_first_position(images)
    images_ordered = images.sort_by {|quantity| quantity.first_place}
    images_ordered.reverse!
  end

   def percent_by_first_place
      percent_by_response = self.flex_module.module_responses.nil? ? 100 / self.flex_module.module_responses.size : 0
      self.first_place * percent_by_response
   end

  protected
    def destroy_module_image_coords
      self.module_image_coords.destroy_all
    end
end
