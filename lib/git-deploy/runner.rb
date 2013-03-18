require 'middleware'
require 'git-deploy/middleware/confirm'
require 'git-deploy/middleware/git_push'
require 'git-deploy/middleware/heroku_maintenance'
require 'git-deploy/middleware/heroku_workers'
require 'git-deploy/middleware/hipchat'
require 'git-deploy/middleware/migrate'

# FIXME remove this once https://github.com/mitchellh/middleware/pull/3 merges
::Middleware::Runner.instance_eval do
  remove_const :EMPTY_MIDDLEWARE
  const_set    :EMPTY_MIDDLEWARE, lambda { |env| env }
end

module Git
  module Deploy
    class Runner < ::Middleware::Builder

      STACK = [
        Git::Deploy::Middleware::Confirm,
        Git::Deploy::Middleware::Hipchat,
        Git::Deploy::Middleware::HerokuMaintenance,
        Git::Deploy::Middleware::HerokuWorkers,
        Git::Deploy::Middleware::Migrate,
        Git::Deploy::Middleware::GitPush
      ]

      ##
      # Sets up the middleware stack for deploy runs. Every middleware gets
      # access to the thor runner's options hash.
      def initialize( options )
        super(){ STACK.each { |middleware| use middleware, options } }
      end

      ##
      # Make the middleware stack public so the CLI can see it.
      public :stack
    end
  end
end
