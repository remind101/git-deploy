class Git::Deploy::Middleware::GitPush

  def initialize( app )
    @app = app
  end

  ##
  # Pretty much the most important thing.
  def call( env )

    `git push #{env[ 'remote' ]} #{env[ 'branch' ]}`

    @app.call env
  end
end
