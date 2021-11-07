require 'blazingdocs/models/base_model'
require 'blazingdocs/models/file_model'
require 'blazingdocs/models/operation_type_model'

module BlazingDocs
  class OperationModel < BaseModel
    attr_accessor :id
    attr_accessor :page_count
    attr_accessor :elapsed_milliseconds
    attr_accessor :remote_ip_address

    attr_reader :files
    attr_reader :type

    def files=(file_hashes)
      @files = file_hashes.map { |hash| FileModel.new(hash) }
    end

    def type=(type_hash)
      @type = OperationTypeModel.new(type_hash)
    end
  end
end
