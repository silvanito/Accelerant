class AddSizeToModuleResponseImages < ActiveRecord::Migration
  def self.up
    add_column :module_response_images, :width, :string
    add_column :module_response_images, :height, :string
  end

  def self.down
    remove_column :module_response_images, :height
    remove_column :module_response_images, :width
  end
end
