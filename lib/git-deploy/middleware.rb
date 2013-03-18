require 'thor'

class Git::Remote

  ##
  # Whether or not this remote exists on the heroku platform.
  def heroku?
    /^git@heroku\.com:/ =~ url
  end
end

module Git
  module Deploy
    module Middleware

      ##
      # A boilerplate initialize method.
      def initialize( app, options={} )
        @app, @options = app, options
      end
      attr_reader :app, :options

      ##
      # Override backtick method to print executing commands to the shell.
      def `( cmd )
        shell.say_status *cmd.split( ' ', 2 )
        super
      end

      ##
      # Borrow a shell instance from thor.
      def shell
        @shell ||= Thor::Base.shell.new
      end
    end
  end
end
