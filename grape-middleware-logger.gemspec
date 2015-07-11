# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape/middleware/logger/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape-middleware-logger'
  spec.version       = Grape::Middleware::Logger::VERSION
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Ryan Buckley', 'David Roy']
  spec.email         = ['arebuckley@gmail.com', 'david.roy@cabbit.co.uk']
  spec.summary       = %q{A logger for the Grape framework}
  spec.description   = %q{Logging middleware for the Grape framework, similar to what Rails offers}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'grape'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '>= 3.0'
end
