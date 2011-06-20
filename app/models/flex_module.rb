class FlexModule < ActiveRecord::Base
  #
  # constants
  #
  STATES = [ 'draft', 'published']
  #
  # filters
  #
  before_save :default_values
  #
  #associations
  #
  has_many :module_images
  has_many :module_responses
  belongs_to :module_type
  belongs_to :discussion
  #
  # scopes
  #
  # Define a named scope for each state in STATES
  STATES.each { |s| named_scope s, :conditions => { :status => s } }
  named_scope :not_deleted, :conditions => {:deleted => nil}
  def default_values
    self.status = 'draft' unless self.status
  end

  def drafted?
   self.status == 'draft' ? true : false
  end

  def published?
     self.status == 'published' ? true : false
  end
end
