module BlazingDocs
  class BlazingError < StandardError
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def to_s
      return "the server responded with status #{http_status}" unless json?

      "Status: #{http_status}. Error message: #{error_message}. Errors: #{errors}".strip
    end

    def error_message
      response_json['message']
    end

    def errors
      response_json['errors']
    end

    def http_status
      response[:status]
    end

    def response_json
      @response_json ||= begin
                           JSON.parse(response[:body])
                         rescue JSON::ParserError
                           {}
                         end
    end

    private

    def json?
      response[:headers]['content-type'] =~ /json/
    end
  end
end
