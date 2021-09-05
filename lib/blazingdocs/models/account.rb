module Blazingdocs
  class Account
    attr_accessor :id
    attr_accessor :plan
    attr_accessor :api_key
    attr_accessor :obsolete_api_key
    attr_accessor :name
    attr_accessor :created_at
    attr_accessor :last_synced_at
    attr_accessor :updated_at
    attr_accessor :is_disabled

    def initialize(hash = {})
      hash.each do |option, value|
        self.send("#{option}=", value)
      end
    end
  end
end
