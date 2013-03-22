require 'middleware'

# FIXME remove this once https://github.com/mitchellh/middleware/pull/3 merges
::Middleware::Runner.instance_eval do
  remove_const :EMPTY_MIDDLEWARE
  const_set    :EMPTY_MIDDLEWARE, lambda { |env| env }
end

module Git
  module Deploy
    class Builder < ::Middleware::Builder

      def self.parse_file( config, opts )
        cfgfile = ::File.read( config )
        cfgfile.sub!(/^__END__\n.*\Z/m, '')
        builder = new(opts)
        builder.instance_eval(cfgfile)
        builder
      end

      ##
      # Sets up the middleware stack for deploy runs. Every middleware gets
      # access to the thor runner's options hash, as well as its own options
      # hash and block.
      def initialize( opts, &block )
        @opts = opts
        super( &block )
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
