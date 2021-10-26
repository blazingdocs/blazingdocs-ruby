module BlazingDocs
  class PlanModel
    attr_accessor :id
    attr_accessor :name
    attr_accessor :price
    attr_accessor :price_per_unit
    attr_accessor :quota

    def initialize(hash = {})
      hash.each do |option, value|
        self.send("#{option}=", value)
      end
    end
  end
end
