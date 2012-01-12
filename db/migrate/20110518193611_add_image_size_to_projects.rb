class AddImageSizeToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :image_size, :string
  end

  def self.down
    remove_column :projects, :image_size
  end
end
