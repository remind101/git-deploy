require 'thor'
require 'shellwords'

class Array

  ##
  # Removes and returns the last item in the array if it is a hash.
  def extract_options!
    last.is_a?( Hash ) ? pop : { }
  end
end

class String

  ##
  # String shellflags are used straight up.
  def shellflag
    self
  end
end

class Symbol

  ##
  # Symbol shellflags are hyphenated and prefixed with '--'.
  # For example, :dry_run will become '--dry-run'.
  def shellflag
    '--' + to_s.gsub( '_', '-' )
  end
end

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
      # Shells out the given command, escaping and joining arguments and flags.
      def sh( *cmd )
        flags = cmd.extract_options!

        flags.each do |k, v|
          case v
          when TrueClass
            cmd.push k.shellflag
          when FalseClass
            next
          when String
            cmd.push k.shellflag, v.shellescape
          end
        end

        `#{cmd.shelljoin}`
      end

      ##
      # Override backtick method to print executing commands to the shell.
      def `( cmd )
        shell.say_status *cmd.delete( '\\' ).split( ' ', 2 )
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
