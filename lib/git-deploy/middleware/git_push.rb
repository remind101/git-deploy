class Git::Deploy::Middleware::GitPush
  include Git::Deploy::Middleware

  ##
  # Deploys [branch] to [remote]. Pretty much the most important thing.
  def call( env )
    remote, branch = env

    # TODO force push
    `git push #{remote} #{branch} --dry-run --quiet`

    app.call [ remote, branch ]
  end
end
