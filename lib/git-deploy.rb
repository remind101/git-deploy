require 'git-deploy/version'
require 'i18n'
require 'git'
require 'yell'
require 'middleware'

##
# TODO can we put this somewhere else?
I18n.load_path.concat \
  Dir[ File.expand_path( '../../config/locales/*.yml', __FILE__ ) ]

module Git
  module Deploy
    autoload :CLI, 'git-deploy/cli'

    ##
    # Namespace for deploy middleware. Define which plugins you want
    # to use in `.gitdeploy`.
    module Middleware
    end

    class << self

      ##
      # Runs the deploy plugins around a push to the specified remote.
      def deploy( remote, refspec )
        runner.call [ git.remote( remote ), git.object( refspec ) ]
      end

      ##
      # The middleware stack for the deploy process.
      def runner
        @runner ||= ::Middleware::Builder.new do
          require 'git-deploy/middleware/hipchat_status'

          use Git::Deploy::Middleware::HipChatStatus
        end
      end

      ##
      # The git client for this repository.
      def git
        @git ||= Git.open Dir.pwd, :log => Yell.new do |l|
          l.level = ENV[ 'LOG_LEVEL' ] ||= 'info'
          l.adapter STDOUT, :level => [ :debug, :info, :warn ]
          l.adapter STDERR, :level => [ :error, :fatal ]
        end
      end

    end
  end
end
