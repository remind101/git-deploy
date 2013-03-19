require 'thor'
require 'forwardable'

module Git
  module Deploy
    module Middleware
      extend Forwardable

      ##
      # A boilerplate initialize method.
      def initialize( app, options={}, &block )
        @app, @options, @block = app, options, block
      end
      attr_reader :app, :options, :block

      ##
      # Override backtick method to print executing commands to the shell.
      def `( cmd )
        say_status *cmd.split( ' ', 2 )
        super
      end

      ##
      # Borrow a shell instance from thor.
      def shell
        @shell ||= Thor::Base.shell.new
      end
      def_delegators :shell, :say, :say_status, :yes?

      ##
      # The current git user's email.
      def user
        git.config[ 'user.email' ]
      end

      ##
      #
      def git
        Git::Deploy::CLI::GIT
      end

      class << self

        ##
        #
        def included( base )
          base.send :extend, ClassMethods
        end
      end

      module ClassMethods

        ##
        # Adds an option flag to the `push` command. The value of this
        # option can be accessed through the `options` hash.
        def option( name, args={} )
          Git::Deploy::CLI.method_option name, args.merge( :for => :push )
        end
      end
    end
  end
end
