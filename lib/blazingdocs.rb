require 'blazingdocs/version'
require 'blazingdocs/configuration'
require 'blazingdocs/blazing_client'

module BlazingDocs
  module_function

  def configure
    yield(config)
  end

  def config
    @config ||= Configuration.new
  end

  def create_client(api_key)
    BlazingClient.new(api_key, config)
  end
end
