require 'date'
require 'blazingdocs/models/base_model'

module BlazingDocs
  class FileModel < BaseModel
    attr_accessor :id
    attr_accessor :name
    attr_accessor :content_type
    attr_accessor :download_url
    attr_accessor :length

    attr_reader :created_at
    attr_reader :last_modified_at
    attr_reader :last_accessed_at

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
  end
end
