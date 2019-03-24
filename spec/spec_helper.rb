# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'

require 'pry-byebug' # binding.pry to debug!
require 'awesome_print'

# Our gem
require 'actioncomponent' # and any other gems you need

# Load support files
Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each do |file|
  # skip the dummy app
  next if file.include?('support/rails_app')

  require file
end

RSpec.configure do |config|
  config.order = 'random'
end
