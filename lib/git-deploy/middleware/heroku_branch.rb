##
# If this remote is a heroku app, sets the destination branch to "master".
class Git::Deploy::Middleware::HerokuBranch

  def initialize( app )
    @app = app
  end

  def call( env )

    if env[ 'remote.heroku' ] && env[ 'branch' ] != 'master'
      env[ 'branch' ] = '%s:master' % [ env[ 'branch' ] ]
    end

    @app.call env
  end
end
