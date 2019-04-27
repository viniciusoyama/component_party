source 'https://rubygems.org'

gem 'yard', '~> 0.9.9', require: false

rails_version = ENV['RAILS_VERSION'] || '6.0.0.rc1'

rails = case rails_version
        when 'master'
          { github: 'rails/rails' }
        when 'default'
          '~> 4.2.0'
        else
          "~> #{rails_version}"
        end

gem 'rails', rails
# Specify your gem's dependencies in rabbitmq-spec.gemspec
gemspec
