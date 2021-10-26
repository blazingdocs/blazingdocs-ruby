require 'open-uri'
require 'blazingdocs/models/file_model'
require 'blazingdocs/models/operation_type_model'

module BlazingDocs
  class OperationModel
    attr_accessor :id
    attr_accessor :page_count
    attr_accessor :elapsed_milliseconds
    attr_accessor :remote_ip_address

    attr_reader :files
    attr_reader :type

    def initialize(hash = {})
      hash.each do |option, value|
        self.send("#{option}=", value)
      end
    end

    def files=(file_hashes)
      @files = file_hashes.map { |hash| FileModel.new(hash) }
    end

    def type=(type_hash)
      @type = OperationTypeModel.new(type_hash)
    end

    def save_to_file(path)
      path = File.join(path, @files[0].name) if File.directory?(path)
      OpenURI::open_uri(@files[0].download_url) do |read_file|
        IO.copy_stream(read_file, path, @files[0].length)
      end

      path
    end
  end
end
