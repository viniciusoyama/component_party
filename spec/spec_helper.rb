# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'

require 'pry-byebug' # binding.pry to debug!
require 'awesome_print'

# Coverage
require 'simplecov'
SimpleCov.start do
  add_filter '/spec/'
end

# Our gem
require 'action_component' # and any other gems you need

# Load support files
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each do |file|
  # skip the dummy app
  next if file.include?('support/rails_app')

  require file
end


def load_fixture(fixture_name)
  File.read(fixture_path(fixture_name))
end

def fixture_path(fixture_name)
  File.expand_path("../fixtures/#{fixture_name}", __FILE__)
end

RSpec.configure do |config|
  config.order = 'random'
end
