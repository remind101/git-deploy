require 'forwardable'
require 'git'

module Git

  ##
  # Extensions to the Git::Base class from `git`.
  class Base

    ##
    # Whether or not there is a remote associated with
    # the current branch.
    def current_remote?
      current_remote
    end

    ##
    # The remote associated with the current branch.
    def current_remote
      config[ "deploy.#{current_branch}.remote" ]
    end
  end

  ##
  # Extensions to the Git::Remote class from `git`.
  class Remote

    ##
    # Whether or not this remote exists on the heroku platform.
    def heroku?
      /^git@heroku\.com:/ =~ url
    end

    ##
    # Does git know about this remote?
    def exists?
      name && url
    end

    ##
    # Override to-string behavior.
    def to_s; name; end
  end

  ##
  # The Git::Deploy module-level API.
  module Deploy
    extend Forwardable

    ##
    # The git client instance for this repository.
    def git
      @git ||= Git.open Dir.pwd
    end
    module_function :git

    ##
    # Define methods delegated to the git client.
    # These methods are also module functions and will be available
    # as instance methods on classes that `include Git::Deploy`.
    [
      :current_branch,
      :current_remote,
      :current_remote?
    ].each do |method|
      def_delegator :git, method
      module_function     method
    end

  end
end
