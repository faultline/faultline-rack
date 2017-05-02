require 'faultline'
require 'rack'
require 'airbrake'
require 'faultline/rack/version'
require 'faultline/rack/middleware'

Airbrake::Rails::Railtie.initializers.clear

module Faultline
  module Rack
  end
end
