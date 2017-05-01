require 'bundler/setup'
require 'webmock'
require 'webmock/rspec'
require 'rspec/wait'
require 'rack'
require 'rack/test'
require 'rake'
require 'pry'
require 'faultline/rack'

Faultline.configure do |c|
  c.project = 'faultline-rack'
  c.api_key = 'xxxxXXXXXxXxXXxxXXXXXXXxxxxXXXXXX'
  c.endpoint = 'https://xxxxxxxxx.execute-api.ap-northeast-1.amazonaws.com/v0'
  c.app_version = '1.2.3'
  c.logger = Logger.new('/dev/null')
  c.workers = 5
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  config.order = 'random'
  config.color = true
  config.disable_monkey_patching!
  config.wait_timeout = 3

  config.include Rack::Test::Methods
end

require 'warden'
require 'apps/rack/dummy_app'

Thread.abort_on_exception = true

FaultlineTestError = Class.new(StandardError)
