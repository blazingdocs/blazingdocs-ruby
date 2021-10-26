module BlazingDocs
  class OperationTypeModel
    attr_accessor :name

    def initialize(hash = {})
      hash.each do |option, value|
        self.send("#{option}=", value)
      end
    end
  end
end
