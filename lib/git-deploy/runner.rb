require 'middleware'
require 'git-deploy/middleware/confirm'
require 'git-deploy/middleware/git_push'
require 'git-deploy/middleware/heroku_maintenance'
require 'git-deploy/middleware/heroku_workers'
require 'git-deploy/middleware/hipchat'
require 'git-deploy/middleware/migrate'

module Git
  module Deploy
    class Runner < ::Middleware::Builder

      binding.pry

      STACK = [
        Git::Deploy::Middleware::Confirm,
        # Git::Deploy::Middleware::Hipchat,
        Git::Deploy::Middleware::HerokuMaintenance,
        Git::Deploy::Middleware::HerokuWorkers,
        Git::Deploy::Middleware::Migrate,
        Git::Deploy::Middleware::GitPush
      ]

      ##
      # Sets up the middleware stack for deploy runs.
      def initialize( options )
        @options = options

        super(){ STACK.each { |middleware| use middleware, options } }
      end
      attr_reader :options

      ##
      # Make the middleware stack public so the CLI can see it.
      public :stack
    end
  end
end
