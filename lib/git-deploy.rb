require 'git-deploy/version'

module Git

  ##
  # Executes the given git command.
  def self.[]( *args )
    `git #{ args.join ' ' }`.chomp
  end

  module Deploy
    autoload :CLI,           'git-deploy/cli'
    autoload :Env,           'git-deploy/env'
    autoload :LogSubscriber, 'git-deploy/log_subscriber'
    autoload :Plugin,        'git-deploy/plugin'
    autoload :Runner,        'git-deploy/runner'

    ##
    # Namespace for deploy plugins. Define which plugins you want
    # to use in `.gitdeploy`.
    module Plugins
    end

    class << self

      ##
      # Returns an array of all git remotes for this repository.
      def remotes
        Git[ 'remote' ].lines.map( &:chomp )
      end

      ##
      # Returns an array of the available plugin files.
      def plugins
        require 'pathname'

        Pathname.new( __FILE__ ).join( '../git-deploy/plugins' ).children
      end

      ##
      # Runs the deploy plugins around a push to the specified remote.
      def deploy( remote, refspec )
        Runner.new( remote, refspec ).run!
      end

    end
  end
end
