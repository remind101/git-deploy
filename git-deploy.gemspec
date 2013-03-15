# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'git-deploy/version'

Gem::Specification.new do |gem|
  gem.name          = 'git-deploy'
  gem.version       = Git::Deploy::VERSION
  gem.authors       = ['Jeremy Ruppel']
  gem.email         = ['jeremy.ruppel@gmail.com']
  gem.description   = 'Git-powered deploy tasks'
  gem.summary       = 'Git-powered deploy tasks'
  gem.homepage      = ''

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ['lib']

  gem.add_dependency 'thor',          '~> 0.17.0'
  gem.add_dependency 'dotenv',        '~> 0.5.0'
  gem.add_dependency 'middleware',    '~> 0.1.0'
  gem.add_dependency 'git',           '~> 1.2.5'
  gem.add_dependency 'activesupport', '~> 3.2.12'
  gem.add_dependency 'cocaine',       '~> 0.5.1'

  # Plugin dependencies
  # TODO make these soft dependencies?
  gem.add_dependency 'hipchat',       '~> 0.7.0'
  gem.add_dependency 'heroku',        '~> 2.35.0'

  gem.add_development_dependency 'pry',         '0.9.12'
  gem.add_development_dependency 'rspec',       '2.13.0'
  gem.add_development_dependency 'guard-rspec', '2.5.0'
  gem.add_development_dependency 'rb-fsevent',  '~> 0.9'
end
