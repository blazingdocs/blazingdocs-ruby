require 'net/https'
require 'uri'
require 'cgi'
require 'json'
require 'blazingdocs/utils/hash_utils'
require 'blazingdocs/models/account'
require 'blazingdocs/models/usage'

module Blazingdocs
  class BlazingdocsClient
    API_KEY_HEADER = 'X-API-Key'

    DEFAULT_HEADERS = {
      'Accept' => 'application/json'
    }

    def initialize(api_key)
      raise TypeError, 'api_key expects a string' unless api_key.kind_of?(String)

      @configuration = Configuration.new
      @configuration.api_key = api_key
    end

    def get_account
      hash = get('/account')
      Account.new(to_snake_keys(hash))
    end

    def get_usage
      hash = get('/usage')
      Usage.new(to_snake_keys(hash))
    end

    private

    include Blazingdocs::Utils

    attr_accessor :configuration

    def get(path, params = {}, options = {})
      handle_response do
        headers = DEFAULT_HEADERS.merge({ API_KEY_HEADER => @configuration.api_key })
        request = Net::HTTP::Get.new(request_uri(path, params), headers)

        http(options).request(request)
      end
    end

    def handle_response
      response = yield
      JSON.parse(response.body)
    end

    def http(options = {})
      http = Net::HTTP.new(base_uri.host, base_uri.port)
      http.open_timeout = @configuration.connect_timeout
      http.use_ssl = base_uri.scheme == 'https'
      # http.set_debug_output $stderr
      http
    end

    def request_uri(path, params = {})
      query = URI.encode_www_form(params)
      base_uri.path + path + '?' + query
    end

    def base_uri
      @configuration.base_uri
    end
  end
end
