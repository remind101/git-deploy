require 'git-deploy/version'
require 'git'

module Git
  module Deploy
    autoload :CLI,        'git-deploy/cli'
    autoload :Middleware, 'git-deploy/middleware'
    autoload :Runner,     'git-deploy/runner'

    class << self

      ##
      # The git client instance for this repository.
      def git
        @git ||= Git.open Dir.pwd
      end
    end
  end

  # ==================
  # = Git extensions =
  # ==================

  class Base

    def current_remote
      config[ "deploy.#{current_branch}.remote" ]
    end
  end

  class Remote

    ##
    # Whether or not this remote exists on the heroku platform.
    def heroku?
      /^git@heroku\.com:/ =~ url
    end

    def exists?
      name && url
    end

    def to_s; name; end
  end
end
