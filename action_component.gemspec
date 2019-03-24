Gem::Specification.new do |s|
  s.name        = 'action_component'
  s.version     = '0.0.0'
  s.date        = '2019-03-21'
  s.summary     = "Stop using views: frontend components architecture for Ruby on Rails"
  s.description = "Stop using views: frontend components architecture for Ruby on Rails"
  s.authors     = ["Vinícius Oyama"]
  s.email       = 'contact@viniciusoyama.com'
  s.files       = ["lib/action_component.rb"]
  s.homepage    =
    'http://rubygems.org/gems/actioncomponent'
  s.license       = 'MIT'
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency 'rails', '>= 4.0.0'


  # Quality Control
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'simplecov'

  # Debugging
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'pry-byebug'

  # for testing a gem with a rails app (controller specs)
  # https://codingdaily.wordpress.com/2011/01/14/test-a-gem-with-the-rails-3-stack/
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'rails', '> 4.0'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'

end
