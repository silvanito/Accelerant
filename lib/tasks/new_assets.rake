require 'active_record'
require 'active_record/fixtures'
require 'ftools'
namespace :new_assets do
  task :get_assets => :environment do
    current_path = Rails.root + '/public/system/'
    current_new_path_i = Rails.root + '/public/system/new_assets/'
    Dir.mkdir(current_new_path_i)
    Dir.foreach(current_path) do |dir|
    if dir != '.' and dir != '..'
      current_new_path = current_new_path_i + "/#{dir}"
      Dir.mkdir(current_new_path) #creando el nombre de los datos 
      if File::directory?(current_path + dir)
        Dir.foreach(current_path + dir) do |ids_dir|
          if ids_dir != '.' and ids_dir != '..'
            
            current_path_ids = current_path + dir + '/' + ids_dir + '/original'
             if File::directory?(current_path_ids)
               new_path_ids = current_new_path + "/#{ids_dir}"
               Dir.mkdir new_path_ids
               Dir.foreach(current_path_ids) do |file|
                 if file != '.' and file != '..'
                   File.copy(current_path_ids +"/#{file}", new_path_ids + "/#{file}")
                 end
               end
             end
            end
          end
        end
      end
    end
  end
end