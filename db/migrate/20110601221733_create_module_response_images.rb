class CreateModuleResponseImages < ActiveRecord::Migration
  def self.up
    create_table :module_response_images do |t|
      t.binary :image, :limit => 20.megabyte
      t.integer :module_response_id
      t.timestamps
    end
  end

  def self.down
    drop_table :module_response_images
  end
end
