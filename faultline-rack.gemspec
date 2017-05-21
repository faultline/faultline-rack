# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'faultline/rack/version'

Gem::Specification.new do |spec|
  spec.name          = 'faultline-rack'
  spec.version       = Faultline::Rack::VERSION
  spec.authors       = ['k1LoW']
  spec.email         = ['k1lowxb@gmail.com']

  spec.summary       = 'faultline exception and error notifier for Rack application'
  spec.description   = 'faultline exception and error notifier for Rack application'
  spec.homepage      = 'https://github.com/faultline/faultline-rack'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'faultline', '~> 0.1.3'
  spec.add_runtime_dependency 'airbrake', '~> 6.1.0'
  spec.add_runtime_dependency 'rack', '>= 1', '< 3.0.0'
  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec-wait', '~> 0'
  spec.add_development_dependency 'webmock', '~> 2'
  spec.add_development_dependency 'rack-test', '~> 0'
  spec.add_development_dependency 'warden', '~> 1.2.6'
  spec.add_development_dependency 'rubocop', '~> 0.48.0'
  spec.add_development_dependency 'octorelease'
  spec.add_development_dependency 'pry'
end
