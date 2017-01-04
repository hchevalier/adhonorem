$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'adhonorem/version'

Gem::Specification.new do |s|
  s.name        = 'adhonorem'
  s.version     = AdHonorem::VERSION
  s.authors     = ['Hugo Chevalier']
  s.email       = ['drakhaine@gmail.com']
  s.homepage    = 'https://github.com/hchevalier/adhonorem'
  s.date        = '2017-01-04'
  s.summary     = 'A gamification gem'
  s.description = <<-EOF
    A complete gamification gem designed for Ruby on Rails.
    AdHonorem assumes that you want to manage the gamification of your
    Rails application code-side, using Ruby files to represent your badges
    rather than depending on entries stored in a database.
  EOF
  s.license     = 'MIT'

  s.files       = Dir[
                  '{app,config,db,lib}/**/*',
                  'MIT-LICENSE',
                  'Rakefile',
                  'README.rdoc'
                ]
  s.test_files  = Dir['spec/**/*.rb']

  s.add_dependency 'rails', '~> 4.2.0'
  s.add_dependency 'static-record', '~> 1.0.0'
  # Database
  s.add_development_dependency 'sqlite3', '~> 1.3'
  # Tests
  s.add_development_dependency 'rake', '~> 12.0.0'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'rspec-rails', '~> 3.5'
  # Test coverage
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 1.0.0'
  # Coding style
  s.add_development_dependency 'rubocop', '~> 0.46.0'
end
