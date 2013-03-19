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
          use Git::Deploy::Middleware::Confirm, options
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
