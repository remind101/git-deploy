class Git::Deploy::Middleware::GitPush

  def initialize( app )
    @app = app
  end

  ##
  # Deploys [branch] to [remote]. Pretty much the most important thing.
  # Consumes any leftover flags from the original command.
  def call( env )

    options, remote, branch, *args = env

    Git::Deploy::Remote.new( env ).push

    @app.call env
  end
end
