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
      def initialize( opts )
        @opts = opts

        super do
          use Git::Deploy::Middleware::Sanity
          use Git::Deploy::Middleware::Confirm
          use Git::Deploy::Middleware::Hipchat,
            :auth_token => ENV[ 'HIPCHAT_AUTH_TOKEN' ],
            :room_id    => 'ROBOTS ONLY',
            :from       => 'Deploy',
            :notify     => 1

          use Git::Deploy::Middleware::HerokuBranch
          use Git::Deploy::Middleware::HerokuMaintenance
          use Git::Deploy::Middleware::HerokuWorkers
          use Git::Deploy::Middleware::Migrate
          use Git::Deploy::Middleware::GitPush
        end
      end

      ##
      # Turn Slop's multiple arguments to #call into an array. Also,
      # rescue errors and report them to the user appropriately.
      def call( *args )
        super args.flatten
      rescue Interrupt => e
        puts e.message.red
        exit 1
      rescue ArgumentError => e
        puts e.message
        puts args.first # prints the usage instructions
        exit 1
      rescue SocketError => e
        puts "You need to be online to deploy, bro.".red
        exit 1
      end

      class ProgressBar
        require 'git-deploy/utils/shell'

        def initialize( app, middleware )
          @app, @middleware = app, middleware
        end

        def call( env )
          puts "=> #{@middleware}".yellow
          env = @app.call env
          puts "<= #{@middleware}".green
          env
        rescue Interrupt
          puts "<= #{@middleware}".red
          raise
        end
      end

      ##
      # Override #use to provide a callback to the class
      # in case it needs to configure any options.
      def use( middleware, *args, &block )
        super ProgressBar, middleware
        super

        middleware.used( @opts ) if middleware.respond_to?( :used )
      end
    end
  end
end
