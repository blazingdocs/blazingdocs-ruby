# frozen_string_literal: true

require 'net/https'
require 'uri'
require 'cgi'
require 'json'
require 'net/http/post/multipart'
require 'blazingdocs/utils/hash_utils'
require 'blazingdocs/models/account_model'
require 'blazingdocs/models/usage_model'
require 'blazingdocs/models/template_model'
require 'blazingdocs/models/operation_model'
require 'blazingdocs/parameters/merge_parameters'
require 'blazingdocs/errors/blazing_error'

module BlazingDocs
  class BlazingClient
    API_KEY_HEADER ||= 'X-API-Key'

    DEFAULT_HEADERS ||= {
      'Accept' => 'application/json'
    }.freeze

    def initialize(api_key, config)
      raise TypeError, 'API Key expected to be a string' unless api_key.kind_of?(String)

      @configuration = config.nil? ? Configuration.new : config.clone
      @configuration.api_key = api_key
    end

    def get_account
      hash = get('/account')
      AccountModel.new(to_snake_keys(hash))
    end

    def get_templates(path = nil)
      hashes = get("/templates/#{path or ''}")
      hashes.map { |hash| TemplateModel.new(to_snake_keys(hash)) }
    end

    def get_usage
      hash = get('/usage')
      UsageModel.new(to_snake_keys(hash))
    end

    def merge(data, file_name, merge_parameters, template)
      form_data = {}

      raise ArgumentError, 'Data is not provided' if data.nil?
      raise ArgumentError, 'Data expected to be a string' unless data.kind_of?(String)

      form_data['Data'] = data

      raise ArgumentError, 'Output filename is not provided' if file_name.nil?

      form_data['OutputName'] = file_name

      raise ArgumentError, 'Merge parameters are not provided' if merge_parameters.nil?

      if merge_parameters.is_a?(Hash)
        form_data['MergeParameters'] = to_camel_keys(merge_parameters).to_json
      elsif merge_parameters.is_a?(BlazingDocs::MergeParameters)
        form_data['MergeParameters'] = to_camel_keys(to_hash(merge_parameters)).to_json
      else
        raise ArgumentError, 'Merge parameters expected to be a Hash or MergeParameters'
      end

      raise ArgumentError, 'Template is not provided' if template.nil?

      options = default_options
      if template.is_a?(File)
        form_data['Template'] = UploadIO.new(template, 'application/octet-stream', File.basename(template))
        options = upload_options
      elsif template.is_a?(String)
        form_data['Template'] = template
      end

      hash = multipart_post('/operation/merge', form_data, options)
      OperationModel.new(to_snake_keys(hash))
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
      options = default_options if options.empty?

      http = Net::HTTP.new(base_uri.host, base_uri.port)
      http.open_timeout = options.fetch(:open_timeout)
      http.read_timeout = options.fetch(:read_timeout)
      http.use_ssl = base_uri.scheme == 'https'
      http
    end

    def request_uri(path, params = {})
      query = URI.encode_www_form(params)
      "#{base_uri.path}#{path}?#{query}"
    end

    def base_uri
      @configuration.base_uri
    end

    def default_options
      options = { read_timeout: @configuration.read_timeout }
      options[:open_timeout] = @configuration.connect_timeout if RUBY_VERSION > '2.2.0'
      options
    end

    def upload_options
      options = default_options
      options[:read_timeout] = @configuration.upload_timeout
      options
    end
  end
end
