require 'net/https'
require 'uri'
require 'cgi'
require 'json'
require 'net/http/post/multipart'
require 'blazingdocs/utils/hash_utils'
require 'blazingdocs/models/account'
require 'blazingdocs/models/usage'
require 'blazingdocs/models/merge_parameters'
require 'blazingdocs/errors/blazing_error'

module BlazingDocs
  class BlazingClient
    API_KEY_HEADER ||= 'X-API-Key'

    DEFAULT_HEADERS ||= {
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

    def merge(data, file_name, merge_parameters, template)
      form_data = {}

      raise ArgumentError, 'data is not provided' if data.nil?
      raise ArgumentError, 'data expects a string' unless data.kind_of?(String)

      form_data['Data'] = data

      raise ArgumentError, 'file_name is not provided' if file_name.nil?

      form_data['OutputName'] = file_name

      raise ArgumentError, 'merge_parameters is not provided' if merge_parameters.nil?

      if merge_parameters.is_a?(Hash)
        form_data['MergeParameters'] = to_camel_keys(merge_parameters).to_json
      elsif merge_parameters.is_a?(BlazingDocs::MergeParameters)
        form_data['MergeParameters'] = to_camel_keys(to_hash(merge_parameters)).to_json
      else
        raise ArgumentError, 'merge_parameters expects Hash or MergeParameters'
      end

      raise ArgumentError, 'template is not provided' if template.nil?

      if template.is_a?(File)
        form_data['Template'] = UploadIO.new(template, 'application/octet-stream', File.basename(template))
      elsif template.is_a?(String)
        form_data['Template'] = template
      end

      multipart_post('/operation/merge', form_data)
    end

    private

    include BlazingDocs::Utils

    attr_accessor :configuration

    def get(path, params = {}, options = {})
      handle_response do
        headers = DEFAULT_HEADERS.merge({ API_KEY_HEADER => @configuration.api_key })
        request = Net::HTTP::Get.new(request_uri(path, params), headers)

        http(options).request(request)
      end
    end

    def post(path, form_data, options = {})
      handle_response do
        uri = request_uri(path)
        headers = DEFAULT_HEADERS.merge({ API_KEY_HEADER => @configuration.api_key })
        request = Net::HTTP::Post.new(uri, headers)
        request.set_form(form_data)

        http(options).request(request)
      end
    end

    def multipart_post(path, form_data, options = {})
      handle_response do
        headers = DEFAULT_HEADERS.merge({ API_KEY_HEADER => @configuration.api_key })
        request = Net::HTTP::Post::Multipart.new(path, form_data, headers)

        http(options).request(request)
      end
    end

    def handle_response
      response = yield
      status = response.code.to_i

      if status != 200
        raise(
          BlazingError,
          status: status,
          body: response.body,
          headers: response.each_header.to_h,
          )
      end

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
