$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'rails_attr_enum/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'rails_attr_enum'
  s.version     = RailsAttrEnum::VERSION
  s.authors     = ['Jeremy Fairbank']
  s.email       = ['elpapapollo@gmail.com']
  s.homepage    = 'https://github.com/jfairbank/rails_attr_enum'
  s.summary     = 'Create enum values for a Rails model\'s attribute'
  s.description = 'Create enums for Rails model attributes like enums in C languages'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '>= 3.2.0'

  s.add_development_dependency 'sqlite3'
end
