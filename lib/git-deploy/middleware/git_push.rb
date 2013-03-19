class Git::Deploy::Middleware::GitPush
  include Git::Deploy::Middleware

  ##
  # Deploys [refspec] to [remote]. Pretty much the most important thing.
  def call( env )
    remote, refspec = env

    # TODO force push
    `git push #{remote.name} #{refspec.name} --dry-run --quiet`

    app.call env
  rescue Interrupt => e
    raise
  end
end

Git::Deploy.configure do |config|
  config.use Git::Deploy::Middleware::GitPush
end
