require 'blazingdocs/models/plan_model'

module BlazingDocs
  class AccountModel
    attr_accessor :id
    attr_accessor :api_key
    attr_accessor :obsolete_api_key
    attr_accessor :name
    attr_accessor :is_disabled

    attr_reader :plan
    attr_reader :created_at
    attr_reader :last_synced_at
    attr_reader :updated_at


    def initialize(hash = {})
      hash.each do |option, value|
        self.send("#{option}=", value)
      end
    end

    def plan=(plan_hash)
      @plan = PlanModel.new(plan_hash)
    end

    def created_at=(created_at_str)
      @created_at = DateTime.iso8601(created_at_str)
    end

    def last_synced_at=(last_synced_at_str)
      @last_synced_at = if !last_synced_at_str.nil?
                          DateTime.iso8601(last_synced_at_str)
                        else
                          nil
                        end
    end

    def updated_at=(updated_at_str)
      @updated_at = if !updated_at_str.nil?
                      DateTime.iso8601(updated_at_str)
                    else
                      nil
                    end
    end
  end
end
