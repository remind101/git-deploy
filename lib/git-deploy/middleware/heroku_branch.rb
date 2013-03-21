class Git::Deploy::Middleware::HerokuBranch

  def initialize( app )
    @app = app
  end

  ##
  # If this remote is a heroku app, sets the destination branch to "master".
  def call( env )

    options, remote, branch, *args = env

    if heroku?( remote )
      branch << ':master' unless branch.end_with?( ':master' )
    end

    @app.call [ options, remote, branch, *args ]
  end

  def heroku?( remote )
    `git config remote.#{remote}.url` =~ /^git@heroku\.com:/
  end

end
