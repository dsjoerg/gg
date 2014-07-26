module GG
  class Config < Hash
    def initialize(settings = {})
      self.merge!(settings)
    end
    
    # Poor man's Hashie :)
    def method_missing(method, *args)
      return self[method.to_sym] if has_key?(method.to_sym)
      return self.send('[]=', method.to_s.delete('=').to_sym, *args) if method.match(/=$/)
    end
  end

  def self.config
    env = ENV['RACK_ENV'] ? ENV['RACK_ENV'] : (ENV['RAILS_ENV'] ? ENV['RAILS_ENV'] : 'development')

    # warning, as of 20121124 this is superceded by ggtracker/config/initializers/esdb.rb
    @@config ||= Config.new({
      :host => env == 'development' ? '127.0.0.1:9292' : 'alpha.esdb.net'
    })
  end
end

require 'rest_client'
require 'hashie/mash'
require 'active_support/inflector'
require 'yajl'
require 'yajl/json_gem'

require 'esdb'
