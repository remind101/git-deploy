require 'git-deploy/version'
require 'git'

module Git
  module Deploy
    autoload :CLI,        'git-deploy/cli'
    autoload :Middleware, 'git-deploy/middleware'
    autoload :Runner,     'git-deploy/runner'

    class << self

      ##
      # The git client for this repository.
      # TODO refactor this into CLI only
      def git
        @git ||= Git.open Dir.pwd
      end

    end
  end
end
