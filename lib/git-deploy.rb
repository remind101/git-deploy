require 'git-deploy/version'
require 'thor'
require 'git'
require 'middleware'

# I18n.load_path.concat \
#   Dir[ File.expand_path( '../../config/locales/*.yml', __FILE__ ) ]

module Git
  module Deploy
    autoload :CLI,        'git-deploy/cli'
    autoload :Middleware, 'git-deploy/middleware'

    ##
    # Raise this error to have thor print the message, and exit.
    class Interrupt < Thor::Error
      def initialize; super 'User cancelled the deploy.'; end
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
          require 'git-deploy/middleware/git_push'

          use Git::Deploy::Middleware::HipChatStatus
          use Git::Deploy::Middleware::GitPush
        end
      end

      ##
      # The git client for this repository.
      def git
        @git ||= Git.open Dir.pwd
      end

    end
  end
end
