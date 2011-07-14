class ModuleResponse < ActiveRecord::Base
  #
  #associations
  #
  belongs_to :flex_module
  belongs_to :user
  has_one :module_response_image, :dependent => :destroy
  has_one :comment, :dependent => :destroy
  #
  # callbacks
  #
  before_destroy :destroy_module_response_image

  protected
    def destroy_module_response_image
      self.module_response_image.destroy unless self.module_response_image.nil?
    end

    def destroy_comment
      self.comment.destroy unless self.comment.nil?
    end
end
