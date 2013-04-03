require 'middleware'

module Git
  module Deploy
    class Runner < ::Middleware::Builder

      ##
      # Sets up the middleware stack for deploy runs.
      def initialize( opts )
        @opts = opts
        super( { } ) do
          insert 0, Git::Deploy::GitConfig

          instance_eval( config.read ) if config.exist?
        end
      end

      ##
      # The local config file for the middleware stack.
      def config
        Git::Deploy.root.join '.gitdeploy'
      end

      ##
      # Turn Slop's multiple arguments to #call into the env hash. Also,
      # rescue errors and report them to the user appropriately.
      def call( opts, args )
        env = {
          'remote' => args[ 0 ],
          'branch' => args[ 1 ]
        }

        opts.each do |o|
          env[ "options.#{o.key}" ] = o.value
        end

        super env
      rescue Interrupt => e
        puts e.message.red
        exit 1
      rescue ArgumentError => e
        puts e.message
        exit 1
      end

      class ProgressBar
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

        middleware.configure( @opts ) if middleware.respond_to?( :configure )
      end
    end
  end
end
