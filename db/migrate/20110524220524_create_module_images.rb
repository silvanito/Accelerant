class CreateModuleImages < ActiveRecord::Migration
  def self.up
    create_table :module_images do |t|
      t.integer :module_id
      t.string  :media_file_name
      t.string  :media_content_type
      t.integer  :media_file_size
      t.datetime :media_updated_at
      t.timestamps
    end
  end

  def self.down
    drop_table :module_images
  end
end
