class Adduseridtodiscussion < ActiveRecord::Migration
  def self.up
    add_column :discussions, :user_id, :integer
  end

  def self.down
    remove_column :discussions, :user_id
  end
end
