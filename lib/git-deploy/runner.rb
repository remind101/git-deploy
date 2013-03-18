require 'middleware'
require 'git-deploy/middleware/confirm'
require 'git-deploy/middleware/git_push'
require 'git-deploy/middleware/heroku_maintenance'
require 'git-deploy/middleware/heroku_workers'
require 'git-deploy/middleware/hipchat'

module Git
  module Deploy
    class Runner < ::Middleware::Builder

      ##
      # Sets up the middleware stack for deploy runs.
      def initialize( options )
        @options = options

        super() do

          use Git::Deploy::Middleware::Confirm, options
          # use Git::Deploy::Middleware::Hipchat
          # use Git::Deploy::Middleware::HerokuMaintenance
          use Git::Deploy::Middleware::HerokuWorkers
          use Git::Deploy::Middleware::GitPush
        end
      end
      attr_reader :options
    end
  end
end
