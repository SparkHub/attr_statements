source 'https://rubygems.org'

# Specify your gem's dependencies in attr_statements.gemspec
gemspec

group :development, :test do
  gem 'reek', RUBY_VERSION >= '2.1.0' ? '>= 4' : '< 4', require: false
  gem 'rubocop', RUBY_VERSION >= '2.0.0' ? '>= 0.48.1' : '< 0.48.1', require: false
end

group :test do
  gem 'codeclimate-test-reporter', require: false if RUBY_VERSION >= '2.0'
  gem 'simplecov', require: false
end
