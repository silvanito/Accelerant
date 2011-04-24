class AddEmailSupportToProjects < ActiveRecord::Migration
  def self.up
    add_column :projects, :email_support, :string
  end

  def self.down
    remove_column :projects, :email_support
  end
end
