class Category < ActiveRecord::Base
  #
  # Attributes
  #
  attr_accessible :name, :product_class_name

  # Validations
  #
  validates_presence_of :name, :message => "Category field can't be blank"
  validates_uniqueness_of :name

  #
  # Associations
  #
  has_many :discussions
  belongs_to :project
end
