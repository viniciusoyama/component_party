# frozen_string_literal: true
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

require 'rspec/rails'

require 'support/rails_app/config/environment'
#
# ActiveRecord::Migration.maintain_test_schema!
#
# # set up db
# # be sure to update the schema if required by doing
# # - cd spec/rails_app
# # - rake db:migrate
# ActiveRecord::Schema.verbose = false
# load 'support/rails_app/db/schema.rb' # use db agnostic schema by default

require 'spec_helper'
