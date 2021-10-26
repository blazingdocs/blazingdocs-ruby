require 'open-uri'

module BlazingDocs
  class FileModel
    attr_accessor :id
    attr_accessor :name
    attr_accessor :content_type
    attr_accessor :download_url
    attr_accessor :length

    attr_reader :created_at
    attr_reader :last_modified_at
    attr_reader :last_accessed_at

    def initialize(hash = {})
      hash.each do |option, value|
        self.send("#{option}=", value)
      end
    end

    def created_at=(created_at_str)
      @created_at = DateTime.iso8601(created_at_str)
    end

    def last_modified_at=(last_modified_at_str)
      @last_modified_at = if !last_modified_at_str.nil?
                            DateTime.iso8601(last_modified_at_str)
                          else
                            nil
                          end
    end

    def last_accessed_at=(last_accessed_at_str)
      @last_accessed_at = if !last_accessed_at_str.nil?
                            DateTime.iso8601(last_accessed_at_str)
                          else
                            nil
                          end
    end

    def save_to_file(path)
      path = File.join(path, @name) if File.directory?(path)
      OpenURI::open_uri(@download_url) do |read_file|
        IO.copy_stream(read_file, path, @length)
      end

      path
    end
  end
end
