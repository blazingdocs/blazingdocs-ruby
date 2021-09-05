require 'blazingdocs/version'
require 'blazingdocs/configuration'
require 'blazingdocs/blazingdocs_client'

module Blazingdocs
  module_function

  def configure
    yield(config)
  end

  def config
    @config ||= Configuration.new
  end

  def create_client(api_key)
    BlazingdocsClient.new(api_key)
  end
end
