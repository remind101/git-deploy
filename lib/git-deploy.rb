require 'git-deploy/version'
require 'thor'
require 'git'

# I18n.load_path.concat \
#   Dir[ File.expand_path( '../../config/locales/*.yml', __FILE__ ) ]

module Git
  module Deploy
    autoload :CLI,        'git-deploy/cli'
    autoload :Middleware, 'git-deploy/middleware'
    autoload :Runner,     'git-deploy/runner'

    ##
    # Raise this error to have thor print the message, and exit.
    class Interrupt < Thor::Error
      def initialize; super 'User cancelled the deploy.'; end
    end

    class << self

      ##
      # The git client for this repository.
      def git
        @git ||= Git.open Dir.pwd
      end

    end
  end
end
