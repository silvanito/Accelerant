require 'active_record'
require 'active_record/fixtures'
require "erb"
include ERB::Util
namespace :default do
  desc 'change for report column of all comments '
  task :heatmap_types => :environment do 
    heatmap_types = ["Image", "Text"]
    heatmap_types.each do |heatmap_type|
      HeatmapType.create(:heatmap_type => heatmap_type)
    end
  end
end
