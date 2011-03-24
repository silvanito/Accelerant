class ReportComment < ActiveRecord::Base

  belongs_to :comment
  belongs_to :user

  has_attached_file :photo,
  :whiny => false, 
  :whiny_thumbnails => false, 
  :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "50x50>", :tiny => "20x20>" }
end
