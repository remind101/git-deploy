require 'thor'
require 'active_support/core_ext/string/inflections'

# TODO concern?
# TODO delegate shell methods?

module Git
  module Deploy
    module Middleware

      ##
      # A boilerplate initialize method.
      def initialize( app )
        @app = app
      end
      attr_reader :app

      ##
      # Shells out the given command, providing nice output.
      def sh( cmd )
        # STDOUT.sync = true

        shell.say "[#{middleware_name}] "
        shell.say cmd, :cyan

        IO.popen( cmd ).each { |line| shell.say line }
      end

      ##
      # Borrow a shell instance from thor.
      def shell
        @shell ||= Thor::Base.shell.new
      end

      ##
      # The display name for this middleware.
      def middleware_name
        self.class.to_s.demodulize.parameterize '-'
      end
    end
  end
end
