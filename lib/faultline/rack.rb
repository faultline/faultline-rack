require 'faultline'
require 'rack'
require 'airbrake'
require 'faultline/rack/version'
require 'faultline/rack/middleware'

Airbrake::Rails::Railtie.initializers.clear if defined?(Rails)

module Faultline
  module Rack
  end
end
