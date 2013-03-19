class Git::Deploy::Middleware::GitPush
  include Git::Deploy::Middleware

  option :force, :type => :boolean, :default => true,
    :desc => "I know what I'm doing"

  ##
  # Deploys [branch] to [remote]. Pretty much the most important thing.
  def call( env )
    remote, branch = env

    if options.force?
      `git push #{remote} #{branch} --force`
    else
      `git push #{remote} #{branch}`
    end

    app.call [ remote, branch ]
  end
end
