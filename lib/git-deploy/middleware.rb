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
      def initialize( app )
        @app = app
      end
      attr_reader :app

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
      # Flags may be filtered out for cleaner output.
      def `( cmd )
        filters = %r{\s--auth-token\s[a-f0-9]{30}}

        shell.say_status *cmd.gsub( filters, '' ).split( ' ', 2 )
        super
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
