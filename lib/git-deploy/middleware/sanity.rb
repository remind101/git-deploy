class Git::Deploy::Middleware::Sanity

  def initialize( app )
    @app = app
  end

  include Git::Deploy

  def call( env )

    options, remote, branch, *args = env

    remote ||= current_remote
    branch ||= current_branch

    raise ArgumentError, 'No remote provided.' if !remote

    @app.call [ options, remote, branch, *args ]
  end
end
