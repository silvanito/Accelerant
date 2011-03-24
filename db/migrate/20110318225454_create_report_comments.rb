class CreateReportComments < ActiveRecord::Migration
  def self.up
    create_table :report_comments do |t|
      t.column :title,      :string, :limit => 255
      t.column :url,        :string, :limit => 255
      t.column :content,    :text
      t.column :upload,     :string, :limit => 255
      t.column :comment_id, :integer
      t.column :owner, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :report_comments
  end
end
