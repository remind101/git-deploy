class Git::Deploy::Middleware::Sanity

  def initialize( app )
    @app = app
  end

  def call( env )

    options, remote, branch, *args = env

    git = Git::Deploy::Utils::Git.new env

    remote ||= git.current_remote
    branch ||= git.current_branch

    raise ArgumentError, 'No remote provided.' if !remote

    @app.call [ options, remote, branch, *args ]
  end
end
