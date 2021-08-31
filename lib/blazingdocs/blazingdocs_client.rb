require 'net/https'
require 'uri'
require 'cgi'
require 'json'

module Blazingdocs
  class BlazingdocsClient
    API_KEY_HEADER = 'X-API-Key'

    DEFAULT_HEADERS = {
      'Accept' => 'application/json'
    }

    def get(path, params = {}, options = {})
      handle_response do
        headers = DEFAULT_HEADERS.merge({ API_KEY_HEADER => config.api_key })
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
      http.open_timeout = config.connect_timeout
      http.use_ssl = base_uri.scheme == 'https'
      # http.set_debug_output $stderr
      http
    end

    def request_uri(path, params = {})
      query = URI.encode_www_form(params)
      base_uri.path + path + '?' + query
    end

    def base_uri
      config.base_uri
    end

    def config
      Blazingdocs.config
    end
  end
end
