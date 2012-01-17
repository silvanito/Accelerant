require 'active_record'
require 'active_record/fixtures'
require 'iconv' 
namespace :fix_encoding do
  task :comments => :environment do
    Comment.all.each do |c|
      unless c.discussion.nil? 
        if c.id > 2106
          c.comment = Iconv.conv("ASCII//IGNORE", "UTF-8", c.comment) + ' '
          c.save
          puts c.id
        end
      end
    end
    puts 'Comments ... done '
  end
end