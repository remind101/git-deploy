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

  gem.add_dependency 'thor', '0.17.0'
end
