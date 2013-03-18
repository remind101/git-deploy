require 'git-deploy/version'

module Git
  module Deploy
    autoload :CLI,        'git-deploy/cli'
    autoload :Middleware, 'git-deploy/middleware'
    autoload :Runner,     'git-deploy/runner'
  end
end
