Gem::Specification.new do |s|
  s.name        = 'actioncomponent'
  s.version     = '0.0.0'
  s.date        = '2019-03-21'
  s.summary     = "Drop you views: Web Components like architecture for Ruby on Rails"
  s.description = "Drop you views: Web Components like architecture for Ruby on Rails"
  s.authors     = ["Vinícius Oyama"]
  s.email       = 'contact@viniciusoyama.com'
  s.files       = ["lib/action_component.rb"]
  s.homepage    =
    'http://rubygems.org/gems/actioncomponent'
  s.license       = 'MIT'


  s.add_development_dependency 'bundler', '~> 1.11'
  s.add_development_dependency 'byebug'
  s.add_development_dependency 'rubocop', '0.49'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rspec', '~> 3.6'
end
