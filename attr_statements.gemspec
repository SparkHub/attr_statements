# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attr_statements/version'

Gem::Specification.new do |spec|
  spec.name          = 'attr_statements'
  spec.version       = AttrStatements::VERSION
  spec.authors       = ['Maxime Chaisse-Leal']
  spec.email         = ['maxime.chaisseleal@gmail.com']

  spec.summary       = 'Generate attributes with strong types and validations.'
  spec.description   = 'Generate attributes with strong types and validations.'
  spec.homepage      = 'https://github.com/SparkHub/attr_statements'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  if RUBY_VERSION >= '2.2.2'
    spec.add_dependency 'activesupport', '>= 5'
  else
    spec.add_dependency 'activesupport', '< 5'
  end
  spec.add_dependency 'activemodel', '>= 4'

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake',    '~> 12.0'
  spec.add_development_dependency 'rspec',   '~> 3.0'
end
