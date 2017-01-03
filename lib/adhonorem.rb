require 'rails'

require 'adhonorem/engine'
require 'adhonorem/models/configuration'

module AdHonorem # :nodoc:
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= AdHonorem::Configuration.new
  end

  def self.reset
    @configuration = AdHonorem::Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end

require 'rails/generators'
require 'adhonorem/generators/adhonorem_generator'

require 'adhonorem/exceptions'

require 'active_record'
require 'static_record'
require 'adhonorem/railtie'
ActiveSupport.run_load_hooks(:static_record, StaticRecord::Base)
