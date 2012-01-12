require 'active_record'
require 'active_record/fixtures'

desc 'add heatmap type to discussion with heatmaps'
task :heatmap_types => :environment do 
  types = ["Image", "Text"]
  types.each do |type|
    HeatmapType.create(:heatmap_type => type)
  end
end
