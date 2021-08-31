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

  def get_account
    client.get('/account')
  end

  def get_usage
    client.get('/usage')
  end

  def client
    Thread.current[:blazingdocs_client] ||= BlazingdocsClient.new
  end
end
