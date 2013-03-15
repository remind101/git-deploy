require 'thor'

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
      def sh( cmd, args )
        # STDOUT.sync = true

        shell.say_status cmd, args

        `#{cmd} #{args}`
      end

      ##
      # A shortcut to the shared git client instance.
      def git
        Git::Deploy.git
      end

      ##
      # Borrow a shell instance from thor.
      def shell
        @shell ||= Thor::Base.shell.new
      end
    end
  end
end
