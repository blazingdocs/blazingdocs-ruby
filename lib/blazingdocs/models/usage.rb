module Blazingdocs
  class Usage
    attr_accessor :quota
    attr_accessor :page_count
    attr_accessor :usage

    def initialize(hash = {})
      hash.each do |option, value|
        self.send("#{option}=", value)
      end
    end
  end
end
