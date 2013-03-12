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

  gem.add_dependency 'thor',          '0.17.0'
  gem.add_dependency 'yell',          '1.3.0'
  gem.add_dependency 'dotenv',        '0.5.0'
  gem.add_dependency 'activesupport', '3.2.11'

  # Plugin dependencies
  # TODO make these soft dependencies?
  gem.add_dependency 'hipchat', '0.7.0'

  gem.add_development_dependency 'pry'
end
