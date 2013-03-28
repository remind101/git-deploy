require 'git-deploy/version'

module Git
  module Deploy
    autoload :Builder,           'git-deploy/builder'
    autoload :Runner,            'git-deploy/runner'

    autoload :Confirm,           'git-deploy/confirm'
    autoload :Countdown,         'git-deploy/countdown'
    autoload :GitConfig,         'git-deploy/git_config'
    autoload :GitPush,           'git-deploy/git_push'
    autoload :HerokuBranch,      'git-deploy/heroku_branch'
    autoload :HerokuMaintenance, 'git-deploy/heroku_maintenance'
    autoload :HerokuWorkers,     'git-deploy/heroku_workers'
    autoload :Hipchat,           'git-deploy/hipchat'
    autoload :Migrate,           'git-deploy/migrate'
    autoload :Sanity,            'git-deploy/sanity'
  end

  require 'pathname'

  ##
  # The root directory for this git repository.
  def root
    Pathname.new `git rev-parse --show-toplevel`.chomp
  end
  module_function :root
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
