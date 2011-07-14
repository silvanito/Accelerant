class AddImagePaperclipToModuleResponseImage < ActiveRecord::Migration
  def self.up
    add_column :module_response_images, :media_file_name,    :string
    add_column :module_response_images, :media_content_type, :string
    add_column :module_response_images, :media_file_size,    :integer
    add_column :module_response_images, :media_updated_at,   :datetime
  end

  def self.down
    remove_column :module_response_images, :media_file_name
    remove_column :module_response_images, :media_content_type
    remove_column :module_response_images, :media_file_size
    remove_column :module_response_images, :media_updated_at
  end
end
