require 'blazingdocs/models/base_model'

module BlazingDocs
  class UsageModel < BaseModel
    attr_accessor :quota
    attr_accessor :page_count
    attr_accessor :usage
  end
end
