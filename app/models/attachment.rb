class Attachment < ActiveRecord::Base

  belongs_to :comment

  has_attached_file :data,
  :whiny => false,
  :whiny_thumbnails => false,
  :styles => { :medium => "300x300>", :thumb => "100x100>", :small => "50x50>", :tiny => "20x20>" }


  #validates_attachment_presence :data
  #validates_attachment_content_type :data,
  #:content_type => ['image/jpeg', 'image/pjpeg',
   #                                'image/jpg', 'image/png']


  def attachment_attributes=(attachment_attributes)
  attachment_attributes.each do |attributes|
    attachment.build(attributes)
  end
end

end
