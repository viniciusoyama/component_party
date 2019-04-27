Gem::Specification.new do |s|
  s.name        = 'component_party'
  s.version     = '0.7.0'
  s.date        = '2019-03-28'
  s.summary     = 'Stop using views: frontend components architecture for Ruby on Rails.'
  s.description = 'Frontend components for Ruby on Rails: group your view logic, html and css files in components to be rendered from views or directly from controllers.'
  s.authors     = ['Vinícius Oyama']
  s.email       = 'contact@viniciusoyama.com'
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.homepage    =
    'https://github.com/viniciusoyama/component_party'
  s.license = 'MIT'
  s.test_files = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency 'rails', '>= 4.2.0', '<= 6.0.0.rc1'

  # Quality Control
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov'

  # Debugging
  s.add_development_dependency 'awesome_print'
  s.add_development_dependency 'pry-byebug'

  # for testing a gem with a rails app (controller specs)
  # https://codingdaily.wordpress.com/2011/01/14/test-a-gem-with-the-rails-3-stack/
  s.add_development_dependency 'bundler'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
end
