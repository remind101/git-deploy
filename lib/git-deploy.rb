require 'git-deploy/version'
require 'git-deploy/git'

module Git
  module Deploy
    autoload :Heroku,               'git-deploy/heroku'
    autoload :Remote,               'git-deploy/remote'
    autoload :Runner,               'git-deploy/runner'
    autoload :Shell,                'git-deploy/shell'

    module Middleware
       autoload :Sanity,            'git-deploy/middleware/sanity'
       autoload :Confirm,           'git-deploy/middleware/confirm'
       autoload :Hipchat,           'git-deploy/middleware/hipchat'
       autoload :HerokuBranch,      'git-deploy/middleware/heroku_branch'
       autoload :HerokuMaintenance, 'git-deploy/middleware/heroku_maintenance'
       autoload :HerokuWorkers,     'git-deploy/middleware/heroku_workers'
       autoload :Migrate,           'git-deploy/middleware/migrate'
       autoload :GitPush,           'git-deploy/middleware/git_push'
    end
  end
end

require 'dotenv'
Dotenv.load
