require 'middleware'

# FIXME remove this once https://github.com/mitchellh/middleware/pull/3 merges
::Middleware::Runner.instance_eval do
  remove_const :EMPTY_MIDDLEWARE
  const_set    :EMPTY_MIDDLEWARE, lambda { |env| env }
end

module Git
  module Deploy
    class Runner < ::Middleware::Builder

      ##
      # Sets up the middleware stack for deploy runs. Every middleware gets
      # access to the thor runner's options hash, as well as its own options
      # hash and block.
      def initialize( options )
        super() do
          require 'git-deploy/middleware/confirm'
          require 'git-deploy/middleware/git_push'
          require 'git-deploy/middleware/heroku_branch'
          require 'git-deploy/middleware/heroku_maintenance'
          require 'git-deploy/middleware/heroku_workers'
          require 'git-deploy/middleware/hipchat'
          require 'git-deploy/middleware/migrate'
          require 'git-deploy/middleware/sanity'

          use Git::Deploy::Middleware::Sanity,            options
          use Git::Deploy::Middleware::Confirm,           options
          use Git::Deploy::Middleware::Hipchat,           options
          use Git::Deploy::Middleware::HerokuBranch,      options
          use Git::Deploy::Middleware::HerokuMaintenance, options
          use Git::Deploy::Middleware::HerokuWorkers,     options
          use Git::Deploy::Middleware::Migrate,           options
          use Git::Deploy::Middleware::GitPush,           options
        end
      end

      ##
      # Turn any rescued interrupt exceptions into `Thor::Error`s
      def call( *args )
        super
      rescue Interrupt => e
        raise Thor::Error, e.message
      end

      ##
      # Make the middleware stack public so the CLI can see it.
      public :stack
    end
  end
end
