require 'middleware'
require 'git-deploy/middleware/git_push'
require 'git-deploy/middleware/heroku_maintenance'
require 'git-deploy/middleware/heroku_workers'
require 'git-deploy/middleware/hipchat'

module Git
  module Deploy
    class Runner < ::Middleware::Builder

      ##
      # Sets up the middleware stack for deploy runs.
      def initialize
        super do

          # use Git::Deploy::Middleware::Hipchat
          # use Git::Deploy::Middleware::HerokuMaintenance
          use Git::Deploy::Middleware::HerokuWorkers
          use Git::Deploy::Middleware::GitPush
        end
      end
    end
  end
end
