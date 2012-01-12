require 'active_record'
require 'active_record/fixtures'

desc 'add heatmap type to heatmaps'
task :module_types => :environment do 
  types = ["Single Image", "Tell a story", "Perception map", "Image ranking", "sorting", "Mysorting", "CollageBuilding"]
  types.each do |type|
    case type
      when "Single Image"
        ModuleType.create(:name => type, :divisions => 1, :has_label => false)
      when "Tell a story"
        ModuleType.create(:name => type, :divisions => 5, :has_label => false)
      when "Perception map"
        ModuleType.create(:name => type, :divisions => 4, :has_label => true)
      when "Image ranking"
        ModuleType.create(:name => type, :divisions => 20, :has_label => false)
      when "sorting"
        ModuleType.create(:name => type, :divisions => 4, :has_label => false)
      when "Mysorting"
        ModuleType.create(:name => type, :divisions => 4, :has_label => true)
    end
  end
end
