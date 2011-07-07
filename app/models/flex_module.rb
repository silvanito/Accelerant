class FlexModule < ActiveRecord::Base
  #
  # constants
  #
  STATES = [ 'draft', 'published']
  #
  #associations
  #
  has_many :module_images, :dependent => :destroy
  has_many :module_responses, :dependent => :destroy
  belongs_to :module_type
  belongs_to :discussion
  #
  # scopes
  #
  # Define a named scope for each state in STATES
  STATES.each { |s| named_scope s, :conditions => { :status => s } }
  named_scope :not_deleted, :conditions => {:deleted => nil}
  #
  # callbacks
  #
  before_save :default_values
  before_save :default_divisions
  before_destroy :destroy_module_images
  before_destroy :destroy_module_responses
  def default_values
    self.status = 'draft' unless self.status
  end

  def drafted?
   self.status == 'draft' ? true : false
  end

  def published?
     self.status == 'published' ? true : false
  end

  def default_divisions
    self.divisions = ModuleType.find(self.module_type_id).divisions unless self.divisions
  end
  
  protected
    def destroy_module_images
      self.module_images.destroy_all
    end
    def destroy_module_responses
      self.module_responses.destroy_all
    end
end
