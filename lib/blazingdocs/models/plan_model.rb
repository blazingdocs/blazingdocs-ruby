require 'blazingdocs/models/base_model'

module BlazingDocs
  class PlanModel < BaseModel
    attr_accessor :id
    attr_accessor :name
    attr_accessor :price
    attr_accessor :price_per_unit
    attr_accessor :quota
  end
end
