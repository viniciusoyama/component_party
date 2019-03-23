require 'byebug'
require 'simplecov'

SimpleCov.start

require 'bundler/setup'
Bundler.setup

require 'action_component' # and any other gems you need

def load_fixture(fixture_name)
  File.read(fixture_path(fixture_name))
end

def fixture_path(fixture_name)
  File.expand_path("../fixtures/#{fixture_name}", __FILE__)
end

RSpec.configure do |config|
end
