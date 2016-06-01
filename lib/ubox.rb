require "ubox/version"
require 'ubox/configuration'

module Ubox
  extend self
  #config
  attr_writer :config

  def config
    @config ||= Configuration.new
  end

  def configure
    yield(config)
  end
end
