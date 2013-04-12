require 'git-deploy/version'

module Git
  module Deploy
    autoload :Builder,           'git-deploy/builder'
    autoload :Runner,            'git-deploy/runner'
    autoload :Shell,             'git-deploy/shell'

    autoload :Confirm,           'git-deploy/confirm'
    autoload :Countdown,         'git-deploy/countdown'
    autoload :GitBranch,         'git-deploy/git_branch'
    autoload :GitConfig,         'git-deploy/git_config'
    autoload :GitPush,           'git-deploy/git_push'
    autoload :GitTag,            'git-deploy/git_tag'
    autoload :GitRemote,         'git-deploy/git_remote'
    autoload :HerokuBranch,      'git-deploy/heroku_branch'
    autoload :HerokuConfig,      'git-deploy/heroku_config'
    autoload :HerokuMaintenance, 'git-deploy/heroku_maintenance'
    autoload :HerokuWorkers,     'git-deploy/heroku_workers'
    autoload :Hipchat,           'git-deploy/hipchat'
    autoload :Migrate,           'git-deploy/migrate'

    require 'pathname'

    ##
    # The root directory for this git repository.
    def root
      Pathname.new `git rev-parse --show-toplevel`.chomp
    end
    module_function :root

    ##
    #
    def on_deployable_branch?
      system 'git config deploy.$(basename $(git symbolic-ref HEAD)).remote'
    end
    module_function :on_deployable_branch?

    class << self
      attr_accessor :verbose
      @verbose = true
    end
  end
end

##
# Core extensions for coloring strings.
# TODO move this somewhere else?
class String
  require 'highline'
  HighLine::COLORS.map(&:downcase).each do |color|
    define_method( color ){ HighLine::Style( color.to_sym ).color self }
  end
end
