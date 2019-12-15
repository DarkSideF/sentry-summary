lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'version'

Gem::Specification.new do |spec|
  spec.name                   = 'sentry-summary'
  spec.version                = '1.1.0'
  spec.date                   = '2019-12-15'
  spec.summary                = 'Shows a summary of the sentry issues'
  spec.description            = 'Shows a summary of the sentry issues, aggregating by request'
  spec.authors                = ['Juan Guerrero', 'Sergei Pleshanov']
  spec.email                  = ['juan@chicisimo.com', 'darksidef56@gmail.com']
  spec.files                  = Dir['lib/**/*.rb'] + Dir['spec/**/*.rb']
  spec.homepage               = 'http://github.com/DarkSideF/sentry-summary'
  spec.extra_rdoc_files       = ['README.md']
  spec.required_ruby_version  = '>= 2.5.0'
  spec.licenses               = ['MIT']

  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'dotenv'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop'

  spec.add_runtime_dependency 'chronic'
  spec.add_runtime_dependency 'json'
  spec.add_runtime_dependency 'nestful'
  spec.add_runtime_dependency 'hashie'
  spec.add_runtime_dependency 'similar_text'
end
