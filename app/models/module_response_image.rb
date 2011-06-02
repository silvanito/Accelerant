class ModuleResponseImage < ActiveRecord::Base
  belongs_to :module_response

  def create_tmp_image
    binaryData = Base64.decode64(self.image)
    #f = Tempfile.new("#{self.discussion_id}_heatmap_image#{self.id}_id")
    root_path = "#{RAILS_ROOT}/public"
    path =  "/tmp/#{self.module_response.id}_module_image#{self.id}.jpg"
    unless File.exists?(root_path + path)
      File.open(root_path + path, "wb") { |f| f.write(binaryData) }
    end
    #f.write(binaryData)
    #path =  file
    return path
#    File.open("#{RAILS_ROOT}/public/tmp/#{discussion.id}_heatmap_image#{heatmap.id}.jpg", "wb") { |f| f.write(binaryData) }
#    render :text => "success"
  end

  def delete_tmp_image
    binaryData = Base64.decode64(self.image)
    root_path = "#{RAILS_ROOT}/public"
    path =  "/tmp/#{self.module_response.id}_module_image#{self.id}.jpg"
    if File.exists?(root_path + path)
      File.delete(root_path + path)
    end
  end
end
