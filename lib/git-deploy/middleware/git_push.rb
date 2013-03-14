class Git::Deploy::Middleware::GitPush
  include Git::Deploy::Middleware

  def call( env )
    remote, refspec = env

    # TODO force push
    sh "git push #{remote.name} #{refspec.name} --dry-run"

    app.call [ remote, refspec ]
  end
end
