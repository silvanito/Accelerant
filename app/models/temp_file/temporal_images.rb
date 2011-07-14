module TempFile
  module TemporalImages
    class TemporalFile
      def create_file(binaryData, name =  "module_response_#{Time.now.getutc.to_i.to_s}.jpg")
        root_path = "#{RAILS_ROOT}/public/tmp/"
        binary_file(binaryData, root_path+name)
      end

      def binary_file(binaryData, path)
        unless File.exists?(path)
          File.open(path, "wb") { |f| f.write(binaryData) }
        end
        path
      end
    end
    #Thanks to Cory O'Daniel code take of -->http://coryodaniel.com/index.php/2010/03/05/attaching-local-or-remote-files-to-paperclip-and-milton-models-in-rails-mocking-content_type-and-original_filename-in-a-tempfile/
    require 'open-uri'
    require 'digest/sha1'
    class RemoteFile < ::Tempfile

      def initialize(path, tmpdir = Dir::tmpdir)
        @original_filename  = File.basename(path)
        @remote_path   = path
        super Digest::SHA1.hexdigest(path), tmpdir
        fetch
      end
      
      def fetch
        string_io = OpenURI.send(:open, @remote_path)
        self.write string_io.read
        self.rewind
        self
      end
      
      def original_filename
        @original_filename
      end

      def content_type
        mime = `file --mime -br #{@remote_path}`.strip
        mime = mime.gsub(/^.*: */,"")
        mime = mime.gsub(/;.*$/,"")
        mime = mime.gsub(/,.*$/,"")
        mime
      end
    end
  end
end
