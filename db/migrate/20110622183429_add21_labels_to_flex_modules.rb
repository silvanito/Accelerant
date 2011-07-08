class Add21LabelsToFlexModules < ActiveRecord::Migration
  def self.up
    add_column :flex_modules, :five_label, :string
    add_column :flex_modules, :six_label, :string
    add_column :flex_modules, :seven_label, :string
    add_column :flex_modules, :eight_label, :string
    add_column :flex_modules, :nine_label, :string
    add_column :flex_modules, :ten_label, :string
    add_column :flex_modules, :eleven_label, :string
    add_column :flex_modules, :twelve_label, :string
    add_column :flex_modules, :thirteen_label, :string
    add_column :flex_modules, :fourteen_label, :string
    add_column :flex_modules, :fifteen_label, :string
    add_column :flex_modules, :sixteen_label, :string
    add_column :flex_modules, :seventeen_label, :string
    add_column :flex_modules, :eighteen_label, :string
    add_column :flex_modules, :nineteen_label, :string
    add_column :flex_modules, :twenty_label, :string
    add_column :flex_modules, :twenty_one_label, :string

  end

  def self.down
    remove_column :flex_modules, :five_label
    remove_column :flex_modules, :six_label
    remove_column :flex_modules, :seven_label
    remove_column :flex_modules, :eight_label
    remove_column :flex_modules, :nine_label
    remove_column :flex_modules, :ten_label
    remove_column :flex_modules, :eleven_label
    remove_column :flex_modules, :twelve_label
    remove_column :flex_modules, :thirteen_label
    remove_column :flex_modules, :fourteen_label
    remove_column :flex_modules, :fifteen_label
    remove_column :flex_modules, :sixteen_label
    remove_column :flex_modules, :seventeen_label
    remove_column :flex_modules, :eighteen_label
    remove_column :flex_modules, :nineteen_label
    remove_column :flex_modules, :twenty_label
    remove_column :flex_modules, :twenty_one_label
  end
end
