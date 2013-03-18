require 'thor'
require 'shellwords'

class Array

  def extract_options!
    last.is_a?( Hash ) ? pop : { }
  end
end

class String

  def shellflag
    self
  end
end

class Symbol

  def shellflag
    '--' + to_s.gsub( '_', '-' )
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
