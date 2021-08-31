require 'uri'

module Blazingdocs
  class Configuration
    attr_accessor :api_key
    attr_accessor :base_uri
    attr_accessor :connect_timeout
    attr_accessor :upload_timeout
    attr_accessor :download_timeout

    def initialize
      @base_uri = URI('https://api.blazingdocs.com')
      @connect_timeout = 5
      @read_timeout = 60
      @upload_timeout = 1800
      @download_timeout = 1800
    end
  end
end
