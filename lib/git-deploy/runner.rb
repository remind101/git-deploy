require 'middleware'
require 'git-deploy/middleware/git_push'
require 'git-deploy/middleware/heroku_maintenance'
require 'git-deploy/middleware/heroku_workers'
require 'git-deploy/middleware/hipchat_status'

module Git
  module Deploy
    class Runner < ::Middleware::Builder

      ##
      # Sets up the middleware stack for deploy runs.
      def initialize
        super do

          # use Git::Deploy::Middleware::HipChatStatus
          # use Git::Deploy::Middleware::HerokuMaintenance
          # use Git::Deploy::Middleware::HerokuWorkers
          use Git::Deploy::Middleware::GitPush
        end
      end

      def deploy( remote, refspec )
        call [ git.remote( remote ), git.object( refspec ) ]
      end

      def git
        Git::Deploy.git
      end
    end
  end
end
