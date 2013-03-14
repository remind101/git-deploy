require 'git-deploy/version'
require 'middleware'

##
# TODO can we put this somewhere else?
I18n.load_path.concat \
  Dir[ File.expand_path( '../../config/locales/*.yml', __FILE__ ) ]

module Git
  module Deploy
    autoload :CLI,        'git-deploy/cli'
    autoload :Runner,     'git-deploy/runner'
    autoload :Middleware, 'git-deploy/middleware'

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
        @git ||= Git.open Dir.pwd, :log => Yell.new do |l|
          l.level = ENV[ 'LOG_LEVEL' ] ||= 'info'
          l.adapter STDOUT, :level => [ :debug, :info, :warn ]
          l.adapter STDERR, :level => [ :error, :fatal ]
        end
      end

    end
  end
end
