class Git::Deploy::HerokuBranch

  def initialize( app )
    @app = app
  end

  ##
  # If this remote is a heroku app, sets the destination branch to "master".
  def call( env )

    if env[ 'remote.heroku' ] && env[ 'branch' ] != 'master'
      env[ 'branch' ] = '%s:master' % [ env[ 'branch' ] ]
    end

    @app.call env
  end
end
