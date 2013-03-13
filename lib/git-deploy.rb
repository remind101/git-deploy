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
    autoload :Paths,         'git-deploy/paths'
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
      # For now, remotes are assumed to be heroku apps.
      def remotes
        Git[ 'remote' ].lines.map( &:chomp ).select do |remote|
          Git[ 'config', "remote.#{remote}.url" ] =~ /^git@heroku\.com:/
        end
      end

      ##
      # Returns an array of the available plugin files.
      def plugins
        paths.plugins
      end

      ##
      # The paths associated with this bundle.
      def paths
        @paths ||= Paths.new __FILE__
      end

      ##
      # Runs the deploy plugins around a push to the specified remote.
      def deploy( remote, refspec )
        Runner.new( remote, refspec ).run!
      end

    end

    ##
    # Set up i18n
    require 'i18n'
    I18n.load_path.concat Git::Deploy.paths.locales
  end
end
